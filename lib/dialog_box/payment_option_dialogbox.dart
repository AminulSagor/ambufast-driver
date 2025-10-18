// Payment Option Model (Optional, but good practice)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaymentOptionDialogbox extends StatelessWidget {
  final VoidCallback onSelect;
  const PaymentOptionDialogbox({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final options = [
      PaymentOption(
        'bkash',
        'pay_with_bkash',
        'assets/icon/bkash.png',
        const Color(0xFFFFF3F8),
      ),
      PaymentOption(
        'nagad',
        'pay_with_nagad',
        'assets/icon/nagad.png',
        const Color(0xFFFFF4E7),
      ),
      PaymentOption(
        'city_bank',
        'pay_with_city_bank',
        'assets/icon/city_bank.png',
        const Color(0xFFFFF0F1),
      ),
      PaymentOption(
        'visa_master_card',
        '',
        'assets/icon/visa.png',
        const Color(0xFFFFF0D6),
      ),
      PaymentOption(
        'pay_station',
        '',
        'assets/icon/pay_station.png',
        const Color(0xFFF7F2FF),
      ),
    ];
    return Dialog(
      // Ensure dialog takes minimum space and is styled correctly
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.only(top: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header: "Select Payment Method" ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'select_payment_method'.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // --- Payment Options List ---
            ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.r, vertical: 4.h),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFFF7F8F8), width: 1),
                  ),
                  child: _PaymentOptionTile(option: option, onTap: onSelect),
                );
              },
            ),

            Padding(
              padding: EdgeInsets.all(16.h),
              child: Container(
                height: 64.h,
                width: double.infinity,
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/support_page_image.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Payment Option Model (Optional, but good practice)
class PaymentOption {
  final String titleKey;
  final String subtitleKey;
  final String logoPath;
  final Color logoBgColor;

  PaymentOption(
    this.titleKey,
    this.subtitleKey,
    this.logoPath,
    this.logoBgColor,
  );
}

// Helper Widget for a single payment tile
class _PaymentOptionTile extends StatelessWidget {
  final PaymentOption option;
  final VoidCallback onTap;

  const _PaymentOptionTile({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              margin: EdgeInsets.only(right: 15.w),
              decoration: BoxDecoration(
                color: option.logoBgColor,
                borderRadius: BorderRadius.circular(10.r),
                image: DecorationImage(image: AssetImage(option.logoPath)),
              ),
            ),

            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    option.titleKey.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (option.subtitleKey.isNotEmpty)
                    Text(
                      option.subtitleKey.tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF8C8F9A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),

            // Forward Arrow Icon
            Icon(Icons.chevron_right, size: 24.sp, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
