import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SupportSummaryCard extends StatelessWidget {
  final String causeKey; // e.g. 'cause_general_fund'
  final int amount;      // e.g. 10000
  final VoidCallback onChange;

  const SupportSummaryCard({
    super.key,
    required this.causeKey,
    required this.amount,
    required this.onChange,
  });

  // Tokens
  static const _bg      = Color(0xFFF7F8F8); // neutral/50
  static const _border  = Color(0xFFE6E6E9); // neutral/100
  static const _text    = Color(0xFF384250);
  static const _label   = Color(0xFF6B7280);
  static const _value   = Color(0xFF384250);
  static const _accent  = Color(0xFFE53935);
  static const _shadow  = Color(0x0D000000); // 5% black (alpha 0x0D ≈ 5%)

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w), // a bit tighter
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: _shadow,
            offset: Offset(0, 1.h), // Y=1
            blurRadius: 3.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          _KVRow(
            label: 'cause'.tr,
            value: causeKey.tr,
            // smaller, closer to mock
            labelSize: 14.sp,
            valueSize: 14.sp,
          ),
          10.h.verticalSpace,
          _KVRow(
            label: 'amount'.tr,
            value: '৳$amount',
            labelSize: 14.sp,
            valueSize: 14.sp,
          ),
          14.h.verticalSpace,
          // Divider (#E6E6E9)
          Container(height: 1.h, width: double.infinity, color: _border),
          8.h.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Text(
                  'edit_below'.tr,
                  style: TextStyle(fontSize: 14.sp, color: _text, height: 1.2),
                ),
              ),
              InkWell(
                onTap: onChange,
                borderRadius: BorderRadius.circular(6.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                  child: Text(
                    'change'.tr,
                    style: TextStyle(
                      fontSize: 14.sp, // reduced from 18
                      color: _accent,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KVRow extends StatelessWidget {
  final String label;
  final String value;
  final double labelSize;
  final double valueSize;

  const _KVRow({
    required this.label,
    required this.value,
    required this.labelSize,
    required this.valueSize,
  });

  static const _labelColor = Color(0xFF6B7280); // subtle label
  static const _valueColor = Color(0xFF384250);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Keep label natural width so it doesn't wrap (“Cause”, “Amount”)
        Text(
          label,
          style: TextStyle(
            fontSize: labelSize,
            color: _labelColor,
            height: 1.2,

          ),
        ),
        10.w.horizontalSpace,
        // Value takes remaining space, right-aligned
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: valueSize,
              color: _valueColor,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
