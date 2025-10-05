import 'package:get/get.dart';

import '../model/vehicle_model.dart';


class MyVehiclesController extends GetxController {
  final vehicles = <Vehicle>[].obs;
  final search = ''.obs;
  final selectedId = RxnString();

  @override
  void onInit() {
    super.onInit();
    _seed(); // TODO: replace with API call
    final active = vehicles.firstWhereOrNull((v) => v.isActive);
    if (active != null) selectedId.value = active.id;
  }

  void _seed() {
    vehicles.assignAll(const [
      Vehicle(
        id: 'v1',
        title: 'Ac Ambulance',
        subtitle: 'Toyota | Dhaka Metro 12 5896',
        imageUrl: 'https://picsum.photos/seed/amb1/120',
        isActive: true,
      ),
      Vehicle(
        id: 'v2',
        title: 'Non Ac Ambulance',
        subtitle: 'Toyota | Dhaka Metro 12 5897',
        imageUrl: 'https://picsum.photos/seed/amb2/120',
      ),
      Vehicle(
        id: 'v3',
        title: 'Ac Ambulance',
        subtitle: 'Toyota | Dhaka Metro 12 5898',
        imageUrl: 'https://picsum.photos/seed/amb3/120',
      ),
    ]);
  }

  List<Vehicle> get filtered {
    final q = search.value.trim().toLowerCase();
    if (q.isEmpty) return vehicles;
    return vehicles.where((v) =>
    v.title.toLowerCase().contains(q) ||
        v.subtitle.toLowerCase().contains(q)).toList();
  }

  Vehicle? get active => vehicles.firstWhereOrNull((v) => v.isActive);

  void onSearch(String q) => search.value = q;

  void onSelect(String id) => selectedId.value = id;

  void applySelection() {
    final id = selectedId.value;
    if (id == null || active?.id == id) return;
    // TODO: call backend to set active vehicle, then:
    vehicles.assignAll(
      vehicles.map((v) => v.copyWith(isActive: v.id == id)).toList(),
    );
  }
}
