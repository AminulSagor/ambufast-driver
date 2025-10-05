import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'profile_details_controller.dart';
import '../../routes/app_routes.dart';

class ProfileDetailsView extends GetView<ProfileDetailsController> {
  const ProfileDetailsView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF7FBF8),
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: Text(
          'profile_details'.tr,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final url = controller.avatarUrl.value.trim();
          final hasAvatar =
              url.isNotEmpty &&
                  Uri.tryParse(url)?.hasScheme == true &&
                  Uri.parse(url).host.isNotEmpty;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              children: [
                _SectionHeader(title: 'basic_information'.tr),
                SizedBox(height: 14.h),

                // Avatar + name + member since
                Column(
                  children: [
                    CircleAvatar(
                      radius: 46.r,
                      backgroundColor: Colors.white,
                      backgroundImage: hasAvatar ? NetworkImage(url) : null,
                      child: hasAvatar ? null : const Icon(Icons.person),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      controller.name.value,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111111),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${'member_since'.tr} ${controller.memberSinceText}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Basic info (read-only “fields”)
                _ReadOnlyField(
                  label: 'name'.tr,
                  value: controller.name.value,
                  onTap: () => Get.toNamed(Routes.editProfileDetails),
                ),
                _ReadOnlyField(
                  label: 'date_of_birth'.tr,
                  value: controller.dobText,
                  onTap: () => Get.toNamed(Routes.editProfileDetails),
                ),
                _ReadOnlyField(
                  label: 'gender'.tr,
                  value: controller.gender.value,
                  onTap: () => Get.toNamed(Routes.editProfileDetails),
                ),
                _ReadOnlyField(
                  label: 'blood_group_p'.tr,
                  value: controller.bloodGroup.value,
                  onTap: () => Get.toNamed(Routes.editProfileDetails),
                ),

                SizedBox(height: 12.h),
                _SectionHeader(title: 'contact_information'.tr),
                SizedBox(height: 12.h),

                _ReadOnlyField(
                  label: 'phone'.tr,
                  value: controller.phone.value,
                  onTap: () => Get.toNamed(Routes.editProfileDetails),
                ),
                _ReadOnlyField(
                  label: 'email'.tr,
                  value: controller.email.value,
                  onTap: () => Get.toNamed(Routes.editProfileDetails),
                ),
                _ReadOnlyField(
                  label: 'street_address'.tr,
                  value: controller.streetAddress.value,
                  onTap: () => Get.toNamed(Routes.editProfileDetails),
                ),
                _ReadOnlyField(
                  label: 'apartment_suite_unit'.tr,
                  value: controller.apartment.value,
                  onTap: () => Get.toNamed(Routes.editProfileDetails),
                ),
                _ReadOnlyField(
                  label: 'city'.tr,
                  value: controller.city.value,
                  onTap: () => Get.toNamed(Routes.editProfileDetails),
                ),
                _ReadOnlyField(
                  label: 'state'.tr,
                  value: controller.state.value,
                  onTap: () => Get.toNamed(Routes.editProfileDetails),
                ),
                _ReadOnlyField(
                  label: 'zip_code'.tr,
                  value: controller.zipCode.value,
                  onTap: () => Get.toNamed(Routes.editProfileDetails),
                ),
                _ReadOnlyField(
                  label: 'country'.tr,
                  value: controller.country.value,
                  onTap: () => Get.toNamed(Routes.editProfileDetails),
                ),

                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.onEdit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF3B30),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: Text('edit'.tr),
                  ),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _HairLine()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(child: _HairLine()),
      ],
    );
  }
}

class _HairLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: const Color(0xFFE9EEF0));
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap; // optional tap action
  const _ReadOnlyField({
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = value.trim().isEmpty;
    return InkWell(
      onTap: isEmpty ? onTap : null, // only tappable when empty
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 8,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 0.40.sw),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  isEmpty ? 'Click to add $label' : value,
                  maxLines: 1,
                  softWrap: false,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isEmpty ? Colors.blue : const Color(0xFF111111),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

