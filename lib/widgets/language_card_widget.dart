// Language selection card widget (reusable)

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? highlightColor; // selected background override
  final Color? borderColor;    // selected border override

  const LanguageCard({
    Key? key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.highlightColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? (highlightColor ?? const Color(0xFFFDECEC)) // soft red
        : Colors.white;
    final border = selected
        ? (borderColor ?? const Color(0xFFF43023))   // #F43023
        : const Color(0xFFCBD5E1);
    final textColor = selected
        ? const Color(0xFFF43023)                    // #F43023 when selected
        : const Color(0xFF1E1E1E);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          height: 96.h,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: border, width: 1.4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
