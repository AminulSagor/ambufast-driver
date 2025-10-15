import 'package:get/get.dart';

class DownTripController extends GetxController {
  RxList<Map<String, dynamic>> trips = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;

  final int _limit = 6;
  int _page = 1;

  @override
  void onInit() {
    super.onInit();
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay

    // Fake data generator
    final newTrips = List.generate(_limit, (i) {
      final index = ((_page - 1) * _limit) + i + 1;
      return {
        "id": index,
        "from": "Naogaon",
        "to": "Dhaka",
        "discount": "30%",
        "date": "02 Jul, 10:00 PM",
        "timeAfter": "2 hour after",
        "image": "assets/down_tripImage.png",
      };
    });

    trips.addAll(newTrips);
    if (newTrips.length < _limit) hasMore.value = false;
    _page++;
    isLoading.value = false;
  }
}
