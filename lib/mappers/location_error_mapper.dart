import 'package:get/get.dart';
import '../../combine_service/location_service.dart';
import '../utils/snackbar_helper.dart'; // <- where your showErrorSnackbar/showWarningSnackbar live

/// Call this from any controller to show a localized snackbar for a LocationError.
void showLocationError(LocationError err) {
  switch (err) {
    case LocationError.serviceDisabled:
      showWarningSnackbar('err_location_service_disabled'.tr);
      break;
    case LocationError.permissionDenied:
      showErrorSnackbar('err_location_permission_denied'.tr);
      break;
    case LocationError.permissionDeniedForever:
      showErrorSnackbar('err_location_permission_denied_forever'.tr);
      break;
    case LocationError.unknown:
      showErrorSnackbar('err_location_unknown'.tr);
      break;
  }
}
