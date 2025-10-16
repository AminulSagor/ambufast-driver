import 'package:ambufast_driver/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SlideToActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onCompleted;

  const SlideToActionButton({
    super.key,
    required this.text,
    required this.onCompleted,
  });

  @override
  State<SlideToActionButton> createState() => _SlideToActionButtonState();
}

class _SlideToActionButtonState extends State<SlideToActionButton> {
  double _dx = 0; // thumb x
  bool _completed = false;

  @override
  Widget build(BuildContext context) {
    final trackHeight = 64.h;
    final thumbSize = 40.h;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final maxX = width - thumbSize - 12.w - 16.w; // padding from right
        final doneThreshold = width * 0.8;

        _dx = _dx.clamp(0, maxX);

        return Stack(
          children: [
            // Track
            Container(
              height: trackHeight,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFFD0880), Color(0xFFFF6A00)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            // Text centered
            SizedBox(
              height: trackHeight,
              width: width,
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            // Thumb
            Positioned(
              left: 12.w + _dx,
              top: (trackHeight - thumbSize) / 2,
              child: GestureDetector(
                onHorizontalDragUpdate: (d) {
                  if (_completed) return;
                  setState(() => _dx += d.delta.dx);
                },
                onHorizontalDragEnd: (d) {
                  if (_completed) return;
                  if ((12.w + _dx) + thumbSize >= doneThreshold) {
                    // success
                    setState(() {
                      _dx = maxX;
                      _completed = true;
                    });
                    widget.onCompleted();
                    //reset button
                    _dx = 0;
                    _completed = false;
                  } else {
                    // snap back
                    setState(() => _dx = 0);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: thumbSize,
                  height: thumbSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: primaryBase,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
