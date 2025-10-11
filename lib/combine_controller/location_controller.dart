// lib/combine_controller/location_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import '../combine_service/location_service.dart';
import '../mappers/location_error_mapper.dart';
import '../model/location_address_model.dart';

class LocationController extends GetxController {
  LocationController(this._service);
  final LocationService _service;

  final RxString locationText = 'Your location is not available'.obs;
  final RxBool   isLoading    = false.obs;

  StreamSubscription<LocationAddress>? _sub;
  bool _liveStarted = false;

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  /// One-shot fetch (asks permission + reverse geocode) and update UI.
  Future<void> refreshFromDevice() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final pretty = await _service.getPrettyLocation();
      if (pretty.isNotEmpty) locationText.value = pretty;
    } on LocationException catch (e) {
      showLocationError(e.code);
    } catch (_) {
      showLocationError(LocationError.unknown);
    } finally {
      isLoading.value = false;
    }
  }

  /// Start continuous updates (only after user opted-in).
  Future<void> startLiveUpdatesIfNeeded() async {
    if (_liveStarted) return;
    _liveStarted = true;

    await _service.startListening(distanceFilterMeters: 400); // no permission prompt if already granted
    _sub = _service.onAddressChanged.listen((addr) {
      if (addr.formatted.isNotEmpty) {
        locationText.value = addr.formatted;
      }
    });
  }

  void setLocation(String v) => locationText.value = v;
}
