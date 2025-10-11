// lib/widgets/ambu_app_bar_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../dialog_box/enable_location_dialog.dart';

class AmbuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final double height;

  // Show text from either a plain string or a reactive builder (e.g. Obx)
  final String? locationText;
  final Widget Function(BuildContext)? locationBuilder;

  /// Called if location is already set and user taps the row (optional).
  final VoidCallback? onLocationTapWhenSet;

  /// Predicate that tells the bar whether to open the enable-location dialog.
  final bool Function()? isLocationMissing;

  /// Called when dialog’s “Use my location” is pressed.
  final Future<void> Function()? onRequestDeviceLocation;

  /// Optional: called when dialog “Skip” is pressed (defaults to just closing)
  final VoidCallback? onDialogSkip;

  final VoidCallback? onNotificationTap;
  final bool showNotificationDot;

  const AmbuAppBar({
    super.key,
    this.backgroundColor = const Color(0xFFF6F8FB),
    this.height = 72,
    this.locationText,
    this.locationBuilder,
    this.onLocationTapWhenSet,
    this.isLocationMissing,
    this.onRequestDeviceLocation,
    this.onDialogSkip,
    this.onNotificationTap,
    this.showNotificationDot = false,
  }) : assert(locationText != null || locationBuilder != null,
  'Provide either locationText or locationBuilder');

  @override
  Size get preferredSize => Size.fromHeight(height.h);

  void _handleLocationTap() {
    final missing = isLocationMissing?.call() ?? false;

    if (missing) {
      // Show enable-location dialog
      Get.dialog(
        EnableLocationDialog(
          onUseMyLocation: () async {
            Get.back(); // close the dialog
            await onRequestDeviceLocation?.call();
          },
          onSkip: () {
            onDialogSkip?.call();
            Get.back();
          },
        ),
        barrierDismissible: true,
      );
    } else {
      // Already selected -> do nothing OR run optional callback
      onLocationTapWhenSet?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      toolbarHeight: height.h,
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 8.w, top: 6.h),
            child: Image.asset(
              'assets/logo_with_color.png',
              height: 28.h,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 6.h),

          // Location row
          GestureDetector(
            onTap: _handleLocationTap,
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 8.w),
              child: Row(
                children: [
                  Image.asset('assets/icon/home_page_icon/location_icon.png', height: 14.h),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: locationBuilder != null
                        ? locationBuilder!(context)
                        : Text(
                      locationText ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Image.asset('assets/icon/arrow.png', height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                onPressed: onNotificationTap,
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
              ),
              if (showNotificationDot)
                Positioned(
                  right: 15.w,
                  top: 14.h,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4D3A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
