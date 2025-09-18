import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../module/home/home_controller.dart';


class SearchBarRow extends StatelessWidget {
  final HomeController controller;
  const SearchBarRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F1F5),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Image.asset('assets/icon/home_page_icon/search_icon.png', height: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'home_where_to'.tr,
                style: const TextStyle(
                  color: Color(0xFF2D2F39),
                  fontSize: 14,
                ),
              ),
            ),
            InkWell(
              onTap: controller.onGoLaterTap,
              borderRadius: BorderRadius.circular(32),
              child: Container(
                height: 36,
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4D3A),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  children: [
                    Image.asset('assets/icon/home_page_icon/calendar_icon.png', height: 18),
                    const SizedBox(width: 6),
                    Text(
                      'home_go_later'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
