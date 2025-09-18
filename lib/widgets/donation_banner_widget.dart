// lib/widgets/donation_banner_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum BannerSide { left, right }
enum BannerVAlign { top, center, bottom }

class DonationBanner extends StatelessWidget {
  final String body;
  final String buttonText;
  final String imageAsset;
  final VoidCallback onPressed;

  // Layout controls
  final BannerSide imageSide;
  final BannerSide buttonSide;
  final BannerVAlign imageVAlign;
  final BannerVAlign buttonVAlign;
  final double? height;          // if null -> 140.h
  final double imageScale;       // 0.0–1.0 of inner height

  // Styling
  final EdgeInsets? margin;      // if null -> EdgeInsets.fromLTRB(16,8,16,12).r
  final double? borderRadius;    // if null -> 18.r
  final List<Color> gradient;

  const DonationBanner({
    super.key,
    required this.body,
    required this.buttonText,
    required this.imageAsset,
    required this.onPressed,
    this.imageSide = BannerSide.right,
    this.buttonSide = BannerSide.left,
    this.imageVAlign = BannerVAlign.center,
    this.buttonVAlign = BannerVAlign.center,
    this.height,
    this.imageScale = 0.75,
    this.margin,
    this.borderRadius,
    this.gradient = const [Color(0xFFFFB799), Color(0xFFFF8D64)],
  });

  double _y(BannerVAlign v) {
    switch (v) {
      case BannerVAlign.top:
        return -1;
      case BannerVAlign.center:
        return 0;
      case BannerVAlign.bottom:
        return 1;
    }
  }

  Alignment _buttonAlignment() {
    final y = _y(buttonVAlign);
    final x = buttonSide == BannerSide.left ? -1.0 : 1.0;
    return Alignment(x, y);
  }

  @override
  Widget build(BuildContext context) {
    final double h   = (height ?? 140.h);
    final double pad = 14.w;
    final double br  = (borderRadius ?? 18.r);
    final EdgeInsets m = margin ?? EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h);

    final double innerH = h - (pad * 2);
    final double imgH   = innerH * imageScale;

    Widget imageWidget() => ClipRRect(
      borderRadius: BorderRadius.circular(br - 6.r),
      child: Image.asset(imageAsset, height: imgH, fit: BoxFit.contain),
    );

    Widget imageAligned() => SizedBox(
      height: innerH,
      child: Align(
        alignment: Alignment(0, _y(imageVAlign)),
        child: imageWidget(),
      ),
    );

    Widget textAndCta() => Expanded(
      child: SizedBox(
        height: innerH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            Expanded(
              child: Text(
                body,
                style: TextStyle(
                  fontSize: 12.sp,
                  height: 1.4,
                  color: const Color(0xFF1E2430),
                ),
              ),
            ),
            Align(
              alignment: _buttonAlignment(),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFED4C3A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final children = <Widget>[
      if (imageSide == BannerSide.left) imageAligned(),
      if (imageSide == BannerSide.left) SizedBox(width: 12.w),
      textAndCta(),
      if (imageSide == BannerSide.right) SizedBox(width: 12.w),
      if (imageSide == BannerSide.right) imageAligned(),
    ];

    return Padding(
      padding: m,
      child: Container(
        height: h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(br),
        ),
        padding: EdgeInsets.all(pad),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: children),
      ),
    );
  }
}
