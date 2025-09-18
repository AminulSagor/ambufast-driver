import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const BottomNavBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  void _defaultNavigate(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed('/home');
        break;
      case 1:
        Get.offAllNamed('/service');
        break;
      case 2:
        Get.offAllNamed('/home');
        break;
      case 3:
        Get.offAllNamed('/account');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0B1B2E);

    final items = <_BottomItem>[
      const _BottomItem(
        label: 'Home',
        active:  'assets/bottom_navigation/home.png',
        inactive:'assets/bottom_navigation/not_selected_home.png',
      ),
      const _BottomItem(
        label: 'Service',
        active:  'assets/bottom_navigation/service.png',
        inactive:'assets/bottom_navigation/not_selected_service.png',
      ),
      const _BottomItem(
        label: 'Activity',
        active:  'assets/bottom_navigation/activity.png',
        inactive:'assets/bottom_navigation/not_selected_activity.png',
      ),
      const _BottomItem(
        label: 'Account',
        active:  'assets/bottom_navigation/account.png',
        inactive:'assets/bottom_navigation/not_selected_account.png',
      ),
    ];

    return Container(
      height: 64,
      color: bg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final it = items[i];
          final selected = i == currentIndex;

          return Expanded(
            child: InkWell(
              onTap: () {
                // use external handler if provided, else built-in navigation
                if (onTap != null) {
                  onTap!(i);
                } else {
                  _defaultNavigate(i);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    selected ? it.active : it.inactive,
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    it.label,
                    style: TextStyle(
                      fontSize: 11,
                      color: selected ? Colors.white : Colors.white70,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
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
