import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Existing error snackbar (unchanged)
void showErrorSnackbar(String message) {
  Get.rawSnackbar(
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.all(12),
    backgroundColor: Colors.white,
    borderRadius: 8,
    borderColor: Colors.red.shade200,
    borderWidth: 1.2,
    messageText: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Image.asset(
            "assets/icon/error_icon.png",
            width: 20, height: 20,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Error',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.red),
              ),
              const SizedBox(height: 2),
              Text(
                message,
                style: TextStyle(fontSize: 13, color: Colors.red.shade700),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// New: warning snackbar (same layout; orange palette)
void showWarningSnackbar(String message) {
  Get.rawSnackbar(
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.all(12),
    backgroundColor: Colors.white,
    borderRadius: 8,
    borderColor: Colors.orange.shade200, // only color changed
    borderWidth: 1.2,
    messageText: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Image.asset(
            // Use your warning icon if you have one; falls back to error icon path.
            "assets/icon/warning_icon.png",
            width: 20, height: 20,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'warning', // per mock (lowercase)
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.orange),
              ),
              const SizedBox(height: 2),
              Text(
                message,
                style: TextStyle(fontSize: 13, color: Colors.orange.shade700),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
