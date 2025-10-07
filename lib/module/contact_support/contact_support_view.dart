import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'contact_support_controller.dart';

class ContactSupportView extends GetView<ContactSupportController> {
  const ContactSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Support'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subject',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 6.h),
            TextField(
              controller: controller.subjectController,
              decoration: InputDecoration(
                hintText: 'Enter subject',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.all(12.w),
              ),
            ),
            SizedBox(height: 16.h),

            Text('Message',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 6.h),
            TextField(
              controller: controller.messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe your issue or question',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.all(12.w),
              ),
            ),
            SizedBox(height: 20.h),

            SizedBox(
              width: double.infinity,
              height: 45.h,
              child: ElevatedButton(
                onPressed: controller.sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Send',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.h),
            Center(
              child: Text(
                'Our support team typically responds within\n24–48 hours',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: Colors.black87, height: 1.4),
              ),
            ),
            SizedBox(height: 20.h),

            // Social / contact shortcuts — centered cards
            Center(
              child: Wrap(
                runSpacing: 12.h,
                spacing: 12.w,
                alignment: WrapAlignment.center,
                children: [
                  _supportButton(
                    '📩', 'Contact us',
                    bg: Colors.red.shade50,
                    fg: const Color(0xFFE53935),
                    onTap: () => controller.openUrl('sms:09678911911'),
                  ),
                  _supportButton(
                    '💬', 'WhatsApp',
                    onTap: () => controller.openUrl('https://wa.me/8809678911911'),
                  ),
                  _supportButton(
                    '📘', 'Facebook',
                    onTap: () => controller.openUrl('https://www.facebook.com/ambufast/'),
                  ),
                  _supportButton(
                    '▶️', 'YouTube',
                    onTap: () => controller.openUrl('https://www.youtube.com/@ambufast'),
                  ),
                  _supportButton(
                    '🔗', 'LinkedIn',
                    onTap: () => controller.openUrl('https://www.linkedin.com/company/ambufast/about/?viewAsMember=true'),
                  ),
                  _supportButton(
                    '🐦', 'Twitter',
                    onTap: controller.openTwitter,
                  ),

                  _supportButton(
                    '🌐', 'Website',
                    onTap: () => controller.openUrl('https://ambufast.com/'),
                  ),
                  _supportButton(
                    '✈️', 'Telegram',
                    onTap: controller.openTelegram,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),
            Center(
              child: Text(
                '24/7 Customer Care',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 10.h),

            // Smaller, centered call button
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 0.7.sw, // 70% of screen width
                height: 42.h,
                child: ElevatedButton(
                  onPressed: controller.callSupport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Call 09678 911 911',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _supportButton(
      String icon,
      String label, {
        required VoidCallback onTap,
        Color? bg,
        Color? fg,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 160.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: bg ?? Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        alignment: Alignment.center,
        child: Text(
          '$icon $label',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
            color: fg ?? Colors.black87,
          ),
        ),
      ),
    );
  }
}
