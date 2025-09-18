import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AmountTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback? onCustomSelected;

  // Prefer centralizing these in your theme
  static const _brandRed = Color(0xFFE53935);
  static const _border = Color(0xFFE5E7EB);
  static const _primary = Color(0xFF4F46E5);
  static const _hint = Color(0xFF98A2B3);
  static const _text = Color(0xFF1E2430);

  const AmountTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onCustomSelected,
  });

  @override
  Widget build(BuildContext context) {
    final fieldHeight = 56.h; // visually closer to the mock
    final prefixSize = fieldHeight; // square red block

    return SizedBox(
      height: fieldHeight,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (_) => onCustomSelected?.call(),
        style: TextStyle(fontSize: 16.sp, color: _text, height: 1.2),
        decoration: InputDecoration(
          // Red square prefix, flush with field’s rounded corners (left only)
          prefixIcon: Container(
            width: prefixSize,
            height: prefixSize,
            decoration: BoxDecoration(
              color: _brandRed,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "৳",
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Make sure our prefix fills the field height with no gaps
          prefixIconConstraints: BoxConstraints(
            minWidth: prefixSize,
            minHeight: prefixSize,
          ),

          hintText: 'enter_amount'.tr,
          hintStyle: TextStyle(fontSize: 16.sp, color: _hint, height: 1.2),
          filled: true,
          fillColor: const Color(0xFFF7F7FB),
          isDense: true,
          // keep content clear of the red block, but tight like the mock
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),

          // Borders to match the card-like input
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: _border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: _border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: _primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
