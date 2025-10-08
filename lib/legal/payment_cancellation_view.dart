import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentCancellationInfoView extends StatelessWidget {
  const PaymentCancellationInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancellation Policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                'assets/cancel_header_image.jpeg',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.h),

            const Text(
              'At AmbuFast, we understand that emergency situations can change rapidly, and patients or their guardians may sometimes need to cancel a booked ambulance. To balance user flexibility with fairness to ambulance providers, we have implemented the following cancellation policy for customers. This section outlines the rules, eligibility for refunds, fees involved, and actions taken in cases of repeated cancellations.',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            SizedBox(height: 20.h),

            _sectionTitle('✅ When You Can Cancel'),
            _sectionBody(
              'As a customer, you are allowed to cancel a trip directly from the app interface any time before the ambulance reaches your pickup location. The cancel button will be visible in your booking details page while the trip is still in the “Confirmed” or “On the Way” status. Once the driver has arrived or marked the trip as “Started,” cancellation is no longer allowed through the app.',
            ),

            _sectionTitle('⏱️ Grace Period for Free Cancellation'),
            _sectionBody(
              'To ensure a fair experience for everyone, AmbuFast provides a 2-minute grace period immediately after confirming your booking. If you cancel your trip within this 2-minute window, you are eligible for a full refund of the advance payment, with no penalty or deduction. This gives you time to change your mind or correct accidental bookings without any financial impact.',
            ),

            _sectionTitle('⚠️ Cancellations After 2 Minutes'),
            _sectionBody(
              'If you cancel your trip after 2 minutes, a cancellation fee will apply. This fee is deducted from your advance payment and typically ranges between ৳100 to ৳300, depending on the ambulance type and zone. The fee helps compensate the driver for time lost, fuel costs, and the blocked slot which could have served another emergency patient.',
            ),
            _sectionBody(
              'For example:\n'
                  '• Basic Ambulance: ৳100 cancellation fee\n'
                  '• AC Ambulance: ৳150\n'
                  '• ICU or Freezing Ambulance: ৳200–৳300\n\n'
                  'The exact fee will be shown to you before you confirm cancellation, ensuring full transparency.',
            ),

            _sectionTitle('❌ No Cancellation After Arrival or Trip Start'),
            _sectionBody(
              'If the ambulance has already arrived at your location or the driver has marked the trip as “Started,” cancellation is no longer allowed. In such cases, no refund will be issued, and the full advance amount is considered forfeited. This policy prevents abuse and ensures that ambulance resources are not wasted or blocked unnecessarily.',
            ),

            _sectionTitle('🔁 Repeated or Abusive Cancellations'),
            _sectionBody(
              'AmbuFast monitors cancellation patterns to prevent misuse. If a user is found to cancel trips frequently, especially after the grace period or without valid reasons, the following actions may be taken:',
            ),
            _sectionBody(
              '1st warning: Notification and reminder of cancellation terms\n\n'
                  '2nd violation: Temporary suspension of booking privileges\n\n'
                  'Repeated misuse: Permanent restriction from using the app',
            ),
            _sectionBody(
              'This policy helps maintain platform integrity and ensures that ambulances remain available for genuine emergencies.',
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  static Widget _sectionTitle(String title) => Padding(
    padding: EdgeInsets.only(top: 12.h, bottom: 6.h),
    child: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: Colors.teal,
      ),
    ),
  );

  static Widget _sectionBody(String text) => Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Text(
      text,
      style: const TextStyle(fontSize: 13, height: 1.6),
    ),
  );
}
