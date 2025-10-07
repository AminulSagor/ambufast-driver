// lib/module/my_vehicles/my_vehicles_controller.dart
import 'package:get/get.dart';
import '../../combine_service/profile_service.dart'; // ✅ uses TokenHttpClient
import '../model/vehicle_model.dart';

class MyVehiclesController extends GetxController {
  final vehicles = <Vehicle>[].obs;
  final search = ''.obs;
  final selectedId = RxnString();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final _profileSvc = ProfileService();

  @override
  void onInit() {
    super.onInit();
    fetchVehicles(); // 🔁 dynamic data from API
  }

  Future<void> fetchVehicles() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res = await _profileSvc.getUserInfo(
        riderinfo: false,
        vehicleinfo: true,
        profile: false,
        address: false,
        agentinfo: false,
      );

      final list = (res['data']?['riderInfo']?['vehicles'] as List? ?? []);

      final mapped = list.map<Vehicle>((v) {
        final photos = (v['vehiclePhotos'] as List?) ?? const [];
        final firstPhoto = photos.isNotEmpty ? photos.first?.toString() : null;

        return Vehicle(
          id: (v['vehicleid'] ?? '').toString(),
          title: (v['vehicleType'] ?? '').toString(), // e.g., Ambulance
          subtitle:
          '${(v['brandAndModel'] ?? '').toString()} | ${(v['vehicleNumber'] ?? '').toString()}',
          imageUrl: firstPhoto,
          isActive: (v['vehicleStatus'] ?? '').toString().toUpperCase() == 'ACTIVE',
        );
      }).toList();

      vehicles.assignAll(mapped);

      // Select active vehicle (or the first one if none active)
      final active = vehicles.firstWhereOrNull((v) => v.isActive) ?? vehicles.firstOrNull;
      if (active != null) selectedId.value = active.id;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Optional: for pull-to-refresh
  Future<void> refreshVehicles() => fetchVehicles();

  List<Vehicle> get filtered {
    final q = search.value.trim().toLowerCase();
    if (q.isEmpty) return vehicles;
    return vehicles.where((v) =>
    v.title.toLowerCase().contains(q) ||
        v.subtitle.toLowerCase().contains(q)).toList();
  }

  Vehicle? get active => vehicles.firstWhereOrNull((v) => v.isActive);

  void onSearch(String q) => search.value = q;


  void onSelect(String? id) => selectedId.value = id;

  void applySelection() {
    final id = selectedId.value;
    if (id == null || active?.id == id) return;

    // TODO: call backend to set active vehicle, then update local state:
    vehicles.assignAll(
      vehicles.map((v) => v.copyWith(isActive: v.id == id)).toList(),
    );
  }
}
