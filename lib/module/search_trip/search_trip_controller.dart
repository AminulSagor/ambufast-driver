import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class SearchTripController extends GetxController {
  static const styleId = 'osm-liberty';

  // ✅ Load from .env
  static final String apiKey = dotenv.env['BARIKOI_API_KEY'] ?? '';
  static String get mapUrl =>
      'https://map.barikoi.com/styles/$styleId/style.json?key=$apiKey';

  RxBool isOnline = false.obs;
  Rxn<Position> currentPosition = Rxn<Position>();
  late MaplibreMapController mapController;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition.value = pos;

    if (mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(pos.latitude, pos.longitude),
          16,
        ),
      );
      await _addCustomIcon();
      await _addMarkerAtCurrentLocation(pos.latitude, pos.longitude);
    }
  }

  void onMapCreated(MaplibreMapController controller) {
    mapController = controller;
    _addCustomIcon();
    if (currentPosition.value != null) {
      _addMarkerAtCurrentLocation(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
      );
    }
  }

  Future<void> _addCustomIcon() async {
    final ByteData byteData =
    await rootBundle.load('assets/icon/car_icon.png');
    final Uint8List imageData = byteData.buffer.asUint8List();
    await mapController.addImage('car_icon', imageData);
  }

  Future<void> _addMarkerAtCurrentLocation(double lat, double lng) async {
    await mapController.addSymbol(
      SymbolOptions(
        iconImage: 'car_icon',
        iconSize: 1.2,
        geometry: LatLng(lat, lng),
      ),
    );
  }

  void toggleOnlineOffline() {
    isOnline.value = !isOnline.value;
  }
}
