import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final VoidCallback? onCenterTap;

  const BottomNavBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
    this.onCenterTap,
  });

  void _defaultNavigate(int index) {
    switch (index) {
      case 0: Get.offAllNamed('/home'); break;
      case 1: Get.offAllNamed('/activity'); break;
      case 2: Get.offAllNamed('/down-trips'); break;
      case 3: Get.offAllNamed('/account'); break;
    }
  }

  void _defaultCenterAction() => Get.offAllNamed('/service');

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0B1B2E);

    final items = <_BottomItem>[
      const _BottomItem(
        label: 'Home',
        active: 'assets/bottom_navigation/home.png',
        inactive: 'assets/bottom_navigation/not_selected_home.png',
      ),
      const _BottomItem(
        label: 'Activity',
        active: 'assets/bottom_navigation/activity.png',
        inactive: 'assets/bottom_navigation/not_selected_activity.png',
      ),
      const _BottomItem(
        label: 'Down Trips',
        active: 'assets/bottom_navigation/down_trip.png',
        inactive: 'assets/bottom_navigation/not_selected_down_trip.png',
      ),
      const _BottomItem(
        label: 'Account',
        active: 'assets/bottom_navigation/account.png',
        inactive: 'assets/bottom_navigation/not_selected_account.png',
      ),
    ];

    // GO button size (PNG) and spacer width beneath it.
    final goSize = 84.w;
    final centerSpacer = 40.w; // add a little extra breathing room

    Widget buildItem(int idx) {
      final it = items[idx];
      final selected = idx == currentIndex;
      return InkWell(
        onTap: () => onTap != null ? onTap!(idx) : _defaultNavigate(idx),
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 8.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                selected ? it.active : it.inactive,
                height: 22.h,
                fit: BoxFit.contain,
                semanticLabel: it.label,
              ),
              SizedBox(height: 4.h),
              Text(
                it.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: selected ? Colors.white : Colors.white70,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: 0.2.sp,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: SizedBox(
        height: (64 + 34).h, // bar + overlap room for GO
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Flat bar (no corner radius)
            Container(
              height: 64.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: bg,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10.r,
                    offset: Offset(0, -2.h),
                    color: Colors.black26,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [buildItem(0), buildItem(1)],
                    ),
                  ),
                  SizedBox(width: centerSpacer),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [buildItem(2), buildItem(3)],
                    ),
                  ),
                ],
              ),
            ),

            // Center GO using PNG (overlapping)
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: onCenterTap ?? _defaultCenterAction,
                behavior: HitTestBehavior.translucent,
                child: Image.asset(
                  'assets/bottom_navigation/go_button.png',
                  width: goSize,
                  height: goSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomItem {
  final String label;
  final String active;
  final String inactive;
  const _BottomItem({
    required this.label,
    required this.active,
    required this.inactive,
  });
}
