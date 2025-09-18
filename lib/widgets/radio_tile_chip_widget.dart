import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RadioTileChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const RadioTileChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Colors
    final bg = selected ? const Color(0xFFE7ECFF) : const Color(0xFFF7F8F8); // <-- updated
    final border = selected ? const Color(0xFF4F46E5) : const Color(0xFFE5E7EB);

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: border),
        ),
        width: (Get.width - 16.w * 2 - 12.w) / 2, // two columns
        height: 60.h,
        child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 18.sp,
                color: selected ? const Color(0xFF4F46E5) : const Color(0xFF9CA3AF),
              ),
              6.w.horizontalSpace,
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF1E2430)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
