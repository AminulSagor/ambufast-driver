import 'package:flutter/material.dart';

class CenterTitleDivider extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry padding;
  final Color lineColor;
  final double lineThickness;
  final TextStyle? textStyle;

  const CenterTitleDivider({
    super.key,
    required this.title,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 8),
    this.lineColor = const Color(0xFFE5E7EB),      // light grey
    this.lineThickness = 1,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final style = textStyle ??
        const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1E2430),
        );

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(child: Divider(color: lineColor, thickness: lineThickness, height: lineThickness)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(title, style: style),
          ),
          Expanded(child: Divider(color: lineColor, thickness: lineThickness, height: lineThickness)),
        ],
      ),
    );
  }
}
