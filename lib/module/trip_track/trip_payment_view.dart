import 'package:ambufast_driver/widgets/custom_back_navigaiton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_button.dart';
import 'trip_payment_controller.dart';

class TripPaymentView extends GetView<TripPaymentController> {
  const TripPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 8.h),
                Text('loading'.tr),
              ],
            ),
          );
        }
        final d = controller.data.value!;
        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: CustomBackNavigaiton(
                    isClose: true,
                    onTap: () {},
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  children: [
                    // Top green block
                    Container(
                      padding: EdgeInsets.all(20.sp),
                      decoration: BoxDecoration(
                        color: posititveBase,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'client_will_pay'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                          8.h.verticalSpace,
                          Text(
                            '${d.clientWillPay.toStringAsFixed(0)} BDT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Breakdown
                    _line('base_fare'.tr, controller.money(d.baseFare)),
                    _line('per_km_rate'.tr, controller.money(d.perKmRate)),
                    _line(
                      'waiting_charges'.tr,
                      controller.money(d.waitingCharges),
                    ),
                    _line('booking_fee'.tr, controller.money(d.bookingFee)),
                    _line('vat_tax'.tr, controller.money(d.vatTax)),
                    SizedBox(height: 10.h),
                    _line(
                      'confirm_payment'.tr,
                      controller.money(d.confirmPayment),
                      color: posititveBase,
                    ),
                    _line(
                      'due'.tr,
                      controller.money(d.due),
                      color: negativeBase,
                    ),
                    SizedBox(height: 16.h),

                    // Promo banner
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.asset(
                        'assets/slider_image.png',
                        fit: BoxFit.cover,
                        height: 120.h,
                      ),
                    ),
                  ],
                ),
              ),

              // Pay button
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomButton(
                    btnTxt: 'collected_cash'.trParams({
                      'amount': controller.data.value!.due.toString(),
                    }),
                    onTap: controller.onCollect,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // dotted leader row
  Widget _line(String left, String right, {Color? color}) {
    final textStyle = TextStyle(
      fontSize: 14.sp,
      color: color ?? neutral800,
      fontWeight: FontWeight.w500,
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Text(left, style: textStyle),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: CustomPaint(
                painter: _DashPainter(color: color ?? const Color(0xFF9CA3AF)),
              ),
            ),
          ),
          Text(right, style: textStyle),
        ],
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;
  _DashPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double x = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset(x + dashWidth, size.height / 2),
        paint,
      );
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter oldDelegate) =>
      oldDelegate.color != color;
}
