import 'package:ambufast_driver/combine_service/profile_service.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';


class ProfileDetailsController extends GetxController {
  // Observables
  final name = ''.obs;
  final memberSince = DateTime.now().obs;
  final avatarUrl = ''.obs;

  final dob = DateTime.now().obs;
  final gender = ''.obs;
  final bloodGroup = ''.obs;

  final phone = ''.obs;
  final email = ''.obs;
  final streetAddress = ''.obs;
  final apartment = ''.obs;
  final city = ''.obs;
  final state = ''.obs;
  final zipCode = ''.obs;
  final country = ''.obs;

  // Loading/error flags
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final _profileService = ProfileService();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res = await _profileService.getUserInfo(
        profile: true,
        address: true,
        riderinfo: false,
        vehicleinfo: false,
        agentinfo: false,
      );

      // top-level "data"
      final d = res['data'] as Map<String, dynamic>;

      // top-level fields
      name.value = (d['fullname'] ?? '').toString();
      phone.value = (d['phone'] ?? '').toString();
      email.value = (d['email'] ?? '').toString();
      memberSince.value =
          DateTime.tryParse(d['createdAt'] ?? '') ?? DateTime.now();

      // profile sub-object
      final p = (d['profile'] ?? {}) as Map<String, dynamic>;
      avatarUrl.value = (p['profilephoto'] ?? '').toString();
      gender.value = (p['gender'] ?? '').toString();
      bloodGroup.value = (p['bloodgroup'] ?? '').toString();
      dob.value = DateTime.tryParse(p['dob'] ?? '') ?? DateTime(2000, 1, 1);

      // first address if any
      final addrs = (d['addresses'] ?? []) as List;
      if (addrs.isNotEmpty) {
        final a = addrs.first as Map<String, dynamic>;
        streetAddress.value = (a['street'] ?? '').toString();
        apartment.value = (a['apartment'] ?? '').toString();
        city.value = (a['city'] ?? '').toString();
        state.value = (a['state'] ?? '').toString();
        zipCode.value = (a['zipcode'] ?? '').toString();
        country.value = (a['country'] ?? '').toString();
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  String get memberSinceText {
    final d = memberSince.value;
    return '${_monthName(d.month)} ${d.year}';
  }

  String get dobText {
    final d = dob.value;
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  String _monthName(int m) =>
      [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ][m - 1];

  void onEdit() {
     Get.toNamed(Routes.editProfileDetails);
  }
}
