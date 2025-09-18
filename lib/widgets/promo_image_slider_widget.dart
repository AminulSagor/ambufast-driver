import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromoImageSlider extends StatefulWidget {
  const PromoImageSlider({
    super.key,
    required this.images,
    this.height = 160,                 // logical units (will be .h)
    this.cornerRadius = 16,            // logical units (will be .r)
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.onTap,
  });

  /// List of asset image paths, e.g. ['assets/slider_image.png', ...]
  final List<String> images;
  final double height;
  final double cornerRadius;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final void Function(int index)? onTap;

  @override
  State<PromoImageSlider> createState() => _PromoImageSliderState();
}

class _PromoImageSliderState extends State<PromoImageSlider> {
  final _pageCtrl = PageController();
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay && widget.images.length > 1) {
      _timer = Timer.periodic(widget.autoPlayInterval, (_) {
        if (!mounted) return;
        final next = (_index + 1) % widget.images.length;
        _pageCtrl.animateToPage(
          next,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.cornerRadius.r),
            child: SizedBox(
              height: widget.height.h,
              width: 1.sw, // full screen width
              child: PageView.builder(
                controller: _pageCtrl,
                itemCount: widget.images.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) {
                  final img = widget.images[i];
                  return GestureDetector(
                    onTap: widget.onTap == null ? null : () => widget.onTap!(i),
                    child: Image.asset(
                      img,
                      fit: BoxFit.contain,          // show full image (no crop)
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (widget.images.length > 1)
          _Dots(index: _index, count: widget.images.length),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  final int index;
  final int count;
  const _Dots({required this.index, required this.count});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (i) {
          final active = i == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            height: 6.h,
            width: active ? 16.w : 6.w, // active dot is a pill
            decoration: BoxDecoration(
              color: active ? const Color(0xFFED4C3A) : Colors.black26,
              borderRadius: BorderRadius.circular(999.r),
            ),
          );
        }),
      ),
    );
  }
}
