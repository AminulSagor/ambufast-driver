import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'legal_policy_controller.dart';

class LegalPolicyView extends GetView<LegalPolicyController> {
  const LegalPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    // Payment-style is removed. Always render the standard layout.
    return _buildStandard(context);
  }

  // ---------- Standard pages (Terms, Privacy, Cancellation, Refund) ----------
  Widget _buildStandard(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.effectiveDate.isNotEmpty)
              _subHeader('Effective Date: ${controller.effectiveDate}'),
            if (controller.effectiveDate.isNotEmpty) SizedBox(height: 8.h),
            ..._standardBody(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  List<Widget> _standardBody() {
    switch (controller.type) {
      case PolicyType.terms:
        return _buildTermsBody();
      case PolicyType.privacy:
        return _buildPrivacyBody();
      case PolicyType.cancellation:
        return _buildCancellationPlainBody();
      case PolicyType.refund:
        return _buildRefundBody();
    }
  }

  // ----------------------- Terms body -----------------------
  List<Widget> _buildTermsBody() => [
    _para(controller.termsIntro),
    _h2('1. Definitions'),
    _bulletList(controller.termsDefinitions),
    _h2('2. Eligibility'),
    _bulletList(controller.termsEligibility),
    _h2('3. User Responsibilities'),
    _bulletList(controller.termsResponsibilities),
    _h2('4. Service Availability'),
    _bulletList(controller.termsAvailability),
    _h2('5. Pricing and Payments'),
    _bulletList(controller.termsPricingPayments),
    _h2('6. Cancellation and Refunds'),
    _bulletList(controller.termsCancellationRefunds),
    _h2('7. Liability and Disclaimer'),
    _bulletList(controller.termsLiabilityDisclaimer),
    _h2('8. Data Privacy'),
    _bulletList(controller.termsDataPrivacy),
    _h2('9. Prohibited Activities'),
    _bulletList(controller.termsProhibited),
    _h2('10. Modifications to Terms'),
    _bulletList(controller.termsModifications),
    _h2('11. Termination of Services'),
    _bulletList(controller.termsTermination),
    _h2('12. Governing Law and Jurisdiction'),
    _bulletList(controller.termsLaw),
    _h2('13. Contact Us'),
    _para('For questions or concerns regarding these terms, please contact us at:'),
    _bulletList(controller.termsContact),
    _para('By using AmbuFast, you acknowledge that you have read, understood, and agree to these terms and conditions.'),
  ];

  // ----------------------- Privacy body -----------------------
  List<Widget> _buildPrivacyBody() => [
    _h2('1. Introduction'),
    _para(controller.privacyIntro),
    _h2('2. Information We Collect'),
    _bulletList(controller.privacyCollect),
    _h2('3. How We Use Your Information'),
    _bulletList(controller.privacyUse),
    _h2('4. Sharing Your Information'),
    _bulletList(controller.privacyShare),
    _h2('5. Data Security'),
    _bulletList(controller.privacySecurity),
    _h2('6. Data Retention'),
    _bulletList(controller.privacyRetention),
    _h2('7. Your Rights'),
    _bulletList(controller.privacyRights),
    _h2('8. Cookies & Tracking'),
    _bulletList(controller.privacyCookies),
    _h2('9. Children’s Privacy'),
    _bulletList(controller.privacyChildren),
    _h2('10. International Transfers'),
    _bulletList(controller.privacyIntl),
    _h2('11. Policy Updates'),
    _bulletList(controller.privacyUpdates),
    _h2('12. Contact Us'),
    _para(controller.privacyContactIntro),
    _bulletList(controller.privacyContact),
  ];

  // ------------------- Cancellation (settings) body -------------------
  List<Widget> _buildCancellationPlainBody() => [
    _para(controller.cancelSimpleIntro),

    _h2(controller.cancelWhenTitle),
    _para(controller.cancelWhenBody),

    _h2(controller.cancelGraceTitle),
    _para(controller.cancelGraceBody),

    _h2(controller.cancelAfterTwoTitle),
    _para(controller.cancelAfterTwoBody),
    _subHeader('For example:'),
    _bulletList(controller.cancelFeeExamples),
    _para(controller.cancelFeeNote),

    _h2(controller.cancelNoTitle),
    _para(controller.cancelNoBody),

    _h2(controller.cancelRepeatTitle),
    _para(controller.cancelRepeatBody),
    _bulletList(controller.cancelRepeatSteps),

    _para(controller.cancelOutro),
  ];

  // ----------------------- Refund body -----------------------
  List<Widget> _buildRefundBody() => [
    _h2('1. General Principles'),
    _para(controller.refundIntro),
    _h2('2. Booking Confirmation Fee'),
    _bulletList(controller.refundBookingFee),
    _h2('Refund Eligibility'),
    _bulletList(controller.refundEligibility),
    _h2('3. Refund Process & Timeline'),
    _bulletList(controller.refundProcess),
    _h2('4. Cancellation Fees'),
    _bulletList(controller.refundCancelFees),
    _h2('5. Special Cases'),
    _bulletList(controller.refundSpecial),
    _h2('6. How to Request a Refund'),
    _bulletList(controller.refundHow),
    _h2('7. Exceptions'),
    _bulletList(controller.refundExceptions),
    _h2('8. Policy Updates'),
    _bulletList(controller.refundUpdates),
    _h2('Contact for Refunds'),
    _bulletList(controller.refundContact),
  ];

  // ---------------- helper widgets ----------------
  Widget _para(String text) => Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Text(
      text.trim(),
      style: TextStyle(fontSize: 13.5.sp, height: 1.55, color: Colors.black87),
    ),
  );

  Widget _h2(String title) => Padding(
    padding: EdgeInsets.only(top: 10.h, bottom: 6.h),
    child: Text(
      title,
      style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w700, height: 1.35),
    ),
  );

  Widget _subHeader(String t) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      t,
      style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w700, color: Colors.black87),
    ),
  );

  Widget _bulletList(List<String> items) => Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (e) => Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('•  ', style: TextStyle(fontSize: 13.5.sp, height: 1.55)),
              Expanded(
                child: Text(
                  e,
                  style: TextStyle(fontSize: 13.5.sp, height: 1.55, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      )
          .toList(),
    ),
  );
}
