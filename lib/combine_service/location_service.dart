// lib/combine_service/location_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as g;

import '../model/location_address_model.dart';

class LocationService {
  LocationService({
    required String barikoiApiKey,
    http.Client? client,
  })  : _apiKey = barikoiApiKey,
        _http = client ?? http.Client();

  final String _apiKey;
  final http.Client _http;

  // Live stream support (only when startListening() is called)
  StreamSubscription<Position>? _posSub;
  final _addrCtrl = StreamController<LocationAddress>.broadcast();
  LocationAddress? _lastEmitted;

  /// Latest address we emitted/resolved (optional convenience).
  LocationAddress? get lastAddress => _lastEmitted;

  /// Stream of meaningful address changes (area/city changes only).
  Stream<LocationAddress> get onAddressChanged => _addrCtrl.stream;

  // ---------------- Public, one-shot ----------------

  /// "Area, City, Country" or empty string if all parts missing.
  Future<String> getPrettyLocation() async {
    final addr = await getCurrentAddress();
    return addr.formatted;
  }

  /// Typed address (Area/SubLocality, City/District, Country).
  Future<LocationAddress> getCurrentAddress() async {
    final pos = await _getPosition();
    final addr = await _reverseToAddress(pos);
    _lastEmitted = addr;
    return addr;
  }

  // ---------------- Live updates (opt-in) ----------------

  /// Start listening; emits only when area or city changes.
  Future<void> startListening({
    int distanceFilterMeters = 400,
    Duration minEmitGap = const Duration(seconds: 20),
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    await _ensurePermissions();

    final settings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilterMeters,
    );

    DateTime lastEmit = DateTime.fromMillisecondsSinceEpoch(0);

    await _posSub?.cancel();
    _posSub = Geolocator.getPositionStream(locationSettings: settings).listen(
          (pos) async {
        // Debounce by time to avoid reverse-geocoding spam
        if (DateTime.now().difference(lastEmit) < minEmitGap) return;
        try {
          final addr = await _reverseToAddress(pos);
          final changed = _lastEmitted == null ||
              _lastEmitted!.subLocality != addr.subLocality ||
              _lastEmitted!.city != addr.city;
          if (changed) {
            _lastEmitted = addr;
            lastEmit = DateTime.now();
            if (!_addrCtrl.isClosed) _addrCtrl.add(addr);
          }
        } catch (_) {
          // Swallow stream-level errors; UI can retry on demand
        }
      },
      onError: (_) {},
      cancelOnError: false,
    );
  }

  Future<void> stopListening() async {
    await _posSub?.cancel();
    _posSub = null;
  }

  // ---------------- Internals ----------------

  Future<Position> _getPosition() async {
    await _ensurePermissions();
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
    );
  }

  Future<void> _ensurePermissions() async {
    final serviceOn = await Geolocator.isLocationServiceEnabled();
    if (!serviceOn) {
      throw const LocationException(LocationError.serviceDisabled);
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied) {
      throw const LocationException(LocationError.permissionDenied);
    }
    if (perm == LocationPermission.deniedForever) {
      throw const LocationException(LocationError.permissionDeniedForever);
    }
  }

  /// Try Barikoi first; fall back to device geocoder if Barikoi fails/empty.
  Future<LocationAddress> _reverseToAddress(Position pos) async {
    try {
      final viaBkoi = await _reverseViaBarikoi(pos);
      if (viaBkoi != null) return viaBkoi;
    } catch (_) {
      // fall through
    }
    return _reverseViaGeocoding(pos);
  }

  // -------- Barikoi Reverse Geocoding (robust parsing) --------
  //
  // Handles shapes: {place:{}}, {geocoded_address:{}}, or top-level fields.
  // City often comes as district/sub_district in BD; include those fallbacks.
  Future<LocationAddress?> _reverseViaBarikoi(Position pos) async {
    if (_apiKey.isEmpty) return null;

    final uri = Uri.parse(
      // Check your plan; this endpoint works for many plans:
      'https://barikoi.xyz/v2/api/search/reverse/current'
          '?apikey=$_apiKey'
          '&latitude=${pos.latitude}'
          '&longitude=${pos.longitude}',
    );

    final res = await _http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) return null;

    final json = jsonDecode(res.body) as Map<String, dynamic>;

    Map<String, dynamic> body;
    if (json['place'] is Map) {
      body = json['place'] as Map<String, dynamic>;
    } else if (json['geocoded_address'] is Map) {
      body = json['geocoded_address'] as Map<String, dynamic>;
    } else {
      body = json;
    }

    String subLocality = _firstNonEmpty(
      body,
      const [
        'area', 'sub_area', 'neighbourhood', 'neighborhood',
        'ward', 'road', 'street', 'union', 'pouroshova',
      ],
    );

    String city = _firstNonEmpty(
      body,
      const [
        'city', 'district', 'sub_district', 'upazila', 'thana', 'metropolitan',
      ],
    );

    String country = _firstNonEmpty(body, const ['country', 'country_name']);
    if (country.isEmpty) country = 'Bangladesh'; // sensible default for your app

    if (subLocality.isEmpty && city.isEmpty && country.isEmpty) return null;

    return LocationAddress(
      subLocality: subLocality,
      city: city,
      country: country,
    );
  }

  // -------- Fallback: device geocoder (Google/Apple providers) --------
  Future<LocationAddress> _reverseViaGeocoding(Position pos) async {
    try {
      final pms = await g.placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (pms.isNotEmpty) {
        final p = pms.first;

        final area = (p.subLocality ?? '').trim(); // Gulshan-1 / Khilkhet / Mirpur
        // BD-friendly city/district fallbacks:
        String city = (p.locality ?? '').trim();
        if (city.isEmpty) city = (p.subAdministrativeArea ?? '').trim(); // District (e.g., Barishal)
        if (city.isEmpty) city = (p.administrativeArea ?? '').trim();    // Division

        final country = (p.country ?? '').trim();

        return LocationAddress(subLocality: area, city: city, country: country);
      }
    } catch (_) {}
    return const LocationAddress(subLocality: '', city: '', country: '');
  }

  // Helpers
  String _firstNonEmpty(Map<String, dynamic> src, List<String> keys) {
    for (final k in keys) {
      final v = src[k];
      if (v == null) continue;
      final s = v.toString().trim();
      if (s.isNotEmpty) return s;
    }
    return '';
  }
}

// ---------------- Errors ----------------
enum LocationError { serviceDisabled, permissionDenied, permissionDeniedForever, unknown }

class LocationException implements Exception {
  final LocationError code;
  const LocationException(this.code);
}
