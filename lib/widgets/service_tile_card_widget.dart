import 'package:flutter/material.dart';

class ServiceTileCard extends StatelessWidget {
  final String asset;            // e.g. 'assets/icon/home_page_icon/ambulance_icon.png'
  final String title;            // localized text already resolved (e.g. 'home_emergency_ambulance'.tr)
  final VoidCallback onTap;
  final double radius;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final Color background;
  final bool selected;           // optional state styling

  const ServiceTileCard({
    super.key,
    required this.asset,
    required this.title,
    required this.onTap,
    this.radius = 16,
    this.iconSize = 28,
    this.padding = const EdgeInsets.all(10),
    this.background = const Color(0xFFEDEDEF), // light grey from mock
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFFE7ECFF) : background;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(asset, height: iconSize),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Color(0xFF1E2430)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
