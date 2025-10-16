import 'package:flutter/material.dart';

class CustomBackNavigaiton extends StatelessWidget {
  final bool isClose;
  final VoidCallback onTap;

  const CustomBackNavigaiton({
    super.key,
    this.isClose = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
        ],
      ),
      child: IconButton(
        icon: isClose
            ? const Icon(Icons.close_rounded)
            : const Icon(Icons.arrow_back),
        onPressed: onTap,
      ),
    );
    ;
  }
}
