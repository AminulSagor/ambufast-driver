import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackbar(String message) {
  Get.rawSnackbar(
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.all(12),
    backgroundColor: Colors.white,
    borderRadius: 8,
    borderColor: Colors.red.shade200,
    borderWidth: 1.2,
    messageText: Row(
      crossAxisAlignment: CrossAxisAlignment.start, // align top
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2), // fine-tune vertical align
          child: Image.asset(
            "assets/icon/error_icon.png",
            width: 20,
            height: 20,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Error',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                message,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
