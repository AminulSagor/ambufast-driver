import 'package:get/get.dart';

enum PolicyType {
  terms,
  privacy,
  cancellation, // settings version (plain body)
  refund,
}

class LegalPolicyController extends GetxController {
  // =============== CONFIG ===============
  // Set your client-provided date ONCE here; used by all 4 standard pages.
  static const String kEffectiveDate = '2025-10-01';

  // =============== STATE ===============
  late final PolicyType type;
  late final String title;

  /// Effective date for all 4 standard pages.
  late final String effectiveDate;

  @override
  void onInit() {
    super.onInit();

    final map = (Get.arguments is Map) ? Get.arguments as Map : const {};
    final typeStr = (map['type'] as String?)?.trim();

    type = PolicyType.values.firstWhere(
          (e) => e.name == typeStr,
      orElse: () => PolicyType.terms,
    );

    effectiveDate = kEffectiveDate;

    switch (type) {
      case PolicyType.terms:
        title = 'Terms & Conditions';
        break;
      case PolicyType.privacy:
        title = 'Privacy Policy';
        break;
      case PolicyType.cancellation:
        title = 'Cancellation Policy';
        break;
      case PolicyType.refund:
        title = 'Refund Policy';
        break;
    }
  }

  // ---------------- Simple Cancellation (settings) content ----------------
  final String cancelSimpleIntro = '''
At AmbuFast, we understand that emergency situations can change rapidly, and patients or their guardians may sometimes need to cancel a booked ambulance. To balance user flexibility with fairness to ambulance providers, we have implemented the following cancellation policy for customers. This section outlines the rules, eligibility for refunds, fees involved, and actions taken in cases of repeated cancellations.
''';

  final String cancelWhenTitle = '✅ When You Can Cancel';
  final String cancelWhenBody = '''
As a customer, you are allowed to cancel a trip directly from the app interface any time before the ambulance reaches your pickup location. The cancel button will be visible in your booking details page while the trip is still in the “Confirmed” or “On the Way” status. Once the driver has arrived or marked the trip as “Started,” cancellation is no longer allowed through the app.
''';

  final String cancelGraceTitle = '⏱️ Grace Period for Free Cancellation';
  final String cancelGraceBody = '''
To ensure a fair experience for everyone, AmbuFast provides a 2-minute grace period immediately after confirming your booking. If you cancel your trip within this 2-minute window, you are eligible for a full refund of the advance payment, with no penalty or deduction. This gives you time to change your mind or correct accidental bookings without any financial impact.
''';

  final String cancelAfterTwoTitle = '⚠️ Cancellations After 2 Minutes';
  final String cancelAfterTwoBody = '''
If you cancel your trip after 2 minutes, a cancellation fee will apply. This fee is deducted from your advance payment and typically ranges between ৳100 to ৳300, depending on the ambulance type and zone. The fee helps compensate the driver for time lost, fuel costs, and the blocked slot which could have served another emergency patient.
''';

  final List<String> cancelFeeExamples = const [
    'Basic Ambulance: ৳100 cancellation fee',
    'AC Ambulance: ৳150',
    'ICU or Freezing Ambulance: ৳200–৳300',
  ];

  final String cancelFeeNote =
      'The exact fee will be shown to you before you confirm cancellation, ensuring full transparency.';

  final String cancelNoTitle = '❌ No Cancellation After Arrival or Trip Start';
  final String cancelNoBody = '''
If the ambulance has already arrived at your location or the driver has marked the trip as “Started,” cancellation is no longer allowed. In such cases, no refund will be issued, and the full advance amount is considered forfeited. This policy prevents abuse and ensures that ambulance resources are not wasted or blocked unnecessarily.
''';

  final String cancelRepeatTitle = '🔁 Repeated or Abusive Cancellations';
  final String cancelRepeatBody = '''
AmbuFast monitors cancellation patterns to prevent misuse. If a user is found to cancel trips frequently, especially after the grace period or without valid reasons, the following actions may be taken:
''';

  final List<String> cancelRepeatSteps = const [
    '1st warning: Notification and reminder of cancellation terms',
    '2nd violation: Temporary suspension of booking privileges',
    'Repeated misuse: Permanent restriction from using the app',
  ];

  final String cancelOutro =
      'This policy helps maintain platform integrity and ensures that ambulances remain available for genuine emergencies.';

  // ---------------- Terms & Conditions ----------------
  String get termsIntro => '''
Welcome to AmbuFast.com. These terms and conditions govern your use of our website and services. By accessing or using AmbuFast.com, you agree to comply with these terms. If you do not agree with any part of these terms, you must refrain from using our website and services.
''';

  List<String> get termsDefinitions => const [
    '"AmbuFast" refers to AmbuFast.com, its website, mobile application, and services.',
    '"User" refers to any individual or entity accessing or using AmbuFast services.',
    '"Service" refers to ambulance ride-sharing, online lab test bookings, or any other services provided by AmbuFast.',
  ];

  List<String> get termsEligibility => const [
    'You must be at least 18 years old to use our services.',
    'By using our platform, you confirm that you have the legal capacity to enter into binding agreements under Bangladeshi law.',
  ];

  List<String> get termsResponsibilities => const [
    'You agree to provide accurate and complete information during registration and booking processes.',
    'You must not use our platform for any unlawful or unauthorized purpose, including fraud or abuse.',
    'Users are responsible for maintaining the confidentiality of their account credentials.',
  ];

  List<String> get termsAvailability => const [
    'AmbuFast strives to ensure uninterrupted availability of services. However, we do not guarantee that the services will always be available or error-free.',
    'Service availability may vary based on location, technical issues, or third-party dependencies.',
  ];

  List<String> get termsPricingPayments => const [
    'All service fees are displayed in Bangladeshi Taka (BDT) and are subject to applicable taxes.',
    'Payments can be made via the methods specified on the platform (e.g., digital wallets, credit/debit cards, or cash).',
    'Once a service is booked, payments are non-refundable unless otherwise stated in the cancellation policy.',
  ];

  List<String> get termsCancellationRefunds => const [
    'Users may cancel bookings according to the cancellation policy outlined on the platform.',
    'Refunds, if applicable, will be processed within the specified timeframe and may be subject to service charges.',
  ];

  List<String> get termsLiabilityDisclaimer => const [
    'AmbuFast is a platform that connects users with ambulance service providers. We do not operate ambulances directly and are not liable for the actions or inactions of third-party service providers.',
    'While we strive for accuracy, all information provided on our platform is for general guidance and does not constitute medical or professional advice.',
    'AmbuFast is not liable for delays, disruptions, or damages caused by circumstances beyond our control, including accidents, traffic, or natural disasters.',
  ];

  List<String> get termsDataPrivacy => const [
    'We respect your privacy and handle your personal data per our Privacy Policy.',
    'By using our platform, you consent to the collection and use of your information as outlined in the Privacy Policy.',
  ];

  List<String> get termsProhibited => const [
    'Misuse of the platform, including hacking, spamming, or transmitting harmful material, is strictly prohibited.',
    'Users must not engage in activities that violate Bangladeshi laws or infringe on the rights of others.',
  ];

  List<String> get termsModifications => const [
    'AmbuFast reserves the right to modify these terms at any time. Users will be notified of significant changes via the website or email.',
    'Continued use of the platform after modifications constitutes acceptance of the updated terms.',
  ];

  List<String> get termsTermination => const [
    'AmbuFast may suspend or terminate your account if you violate these terms or engage in unlawful activities.',
    'Upon termination, your right to use the platform ceases immediately.',
  ];

  List<String> get termsLaw => const [
    "These terms are governed by the laws of the People's Republic of Bangladesh.",
    'Any disputes arising from these terms will be subject to the exclusive jurisdiction of Bangladeshi courts.',
  ];

  // inside LegalPolicyController
  final String privacyContactIntro =
      'For questions, requests, or complaints about your data or this policy, contact:';


  List<String> get termsContact => const [
    'Email: care@ambufast.com',
    'Phone: 09614-911911',
  ];

  // ---------------- Privacy Policy ----------------
  String get privacyIntro => '''
AmbuFast, operated by SafeCare 24/7 Medical Services Ltd, is committed to protecting your personal information and privacy. This policy explains how we collect, use, store, and share your data when you use our app, website, and services.
''';

  List<String> get privacyCollect => const [
    'Personal Identification: Name, phone number, email, address, payment information, emergency contacts.',
    'Booking & Usage Data: Ambulance booking details, trip history, feedback, communication logs, payment records.',
    'Location Data: Real-time GPS location (for bookings and live tracking).',
    'Device & Technical Data: Device type, operating system, IP address, app usage statistics, cookies (for web).',
    'Special Categories: Health-related information (when relevant for service, e.g., pregnancy pre-booking).',
  ];

  List<String> get privacyUse => const [
    'Provide and improve ambulance booking and related healthcare services.',
    'Process payments and refunds.',
    'Communicate with you (alerts, confirmations, support).',
    'Ensure safety, fraud prevention, and compliance.',
    'Analyze trends and improve user experience.',
    'Fulfill legal obligations and regulatory requirements.',
  ];

  List<String> get privacyShare => const [
    'Service Providers: Drivers, agents, and partners involved in fulfilling your booking.',
    'Payment Processors: For handling payments and refunds.',
    'Legal Authorities: If required by law, court order, or to protect rights and safety.',
    'Partners: For exclusive offers (e.g., Shukhee, Robi) only with your consent.',
  ];

  List<String> get privacySecurity => const [
    'AES-256 encryption for data storage.',
    'TLS 1.2+ for data transmission.',
    'Multi-factor authentication (MFA) and role-based access control (RBAC).',
    'Regular security audits and compliance with ISO 27001 standards.',
    'Staff training on privacy and data protection.',
  ];

  List<String> get privacyRetention => const [
    'We retain your data only as long as necessary for service delivery, legal, and regulatory purposes.',
    'You may request deletion or correction of your data (subject to legal requirements).',
  ];

  List<String> get privacyRights => const [
    'Access, correct, or delete your personal data.',
    'Withdraw consent for non-essential processing.',
    'Request restriction or object to certain processing activities.',
    'Lodge a complaint with the appropriate authority.',
  ];

  List<String> get privacyCookies => const [
    'Our website uses cookies and similar technologies to enhance user experience and analyze usage.',
    'You can manage cookie preferences in your browser settings.',
  ];

  List<String> get privacyChildren => const [
    'AmbuFast services are not intended for children under 16 without parental consent.',
  ];

  List<String> get privacyIntl => const [
    'If your data is transferred outside Bangladesh, we ensure it is protected with appropriate safeguards.',
  ];

  List<String> get privacyUpdates => const [
    'We may update this policy from time to time. Changes will be communicated via app, website, or email.',
  ];

  List<String> get privacyContact => const [
    'care@ambufast.com',
    '09678 911 911',
  ];

  // ---------------- Refund Policy ----------------
  String get refundIntro => '''
AmbuFast is committed to providing reliable ambulance services and transparent payment processes. We offer refunds in specific cases where bookings cannot be fulfilled or are canceled under eligible conditions.
''';

  List<String> get refundBookingFee => const [
    'Booking Confirmation Fee: Customers pay 20% of the estimated fare as a Booking Confirmation Fee during the booking process.',
  ];

  List<String> get refundEligibility => const [
    'If AmbuFast cannot assign an ambulance within the promised time (after up to 3 attempts or 10 minutes), the full Booking Confirmation Fee is refunded.',
    'If the booking is canceled by AmbuFast (e.g., no available drivers, operational issues), the full Booking Confirmation Fee is refunded.',
    'If the customer cancels before the ambulance is confirmed/assigned, the Booking Confirmation Fee is refunded in full for non-emergency rides.',
    'For emergency rides, cancellation after confirmation may incur a cancellation fee (see below).',
  ];

  List<String> get refundProcess => const [
    'Instant Refunds: If a booking cannot be assigned, refunds are processed instantly to the user’s AmbuFast wallet.',
    'Payment Gateway Refunds: For payments made via bKash, Nagad, or card, refunds are processed within 2–3 business days (depending on the payment provider).',
    'Notification: Customers receive SMS/app/email notifications once refunds are processed.',
  ];

  List<String> get refundCancelFees => const [
    'Non-Emergency Rides: Free cancellation and full refund of the Booking Confirmation Fee before pickup/assignment.',
    'Emergency Rides: Cancellation after assignment/confirmation may result in a partial refund (Booking Confirmation Fee minus cancellation fee), as operational costs may be incurred.',
    'Frequent Cancellations: Accounts with repeated cancellations may face restrictions or require Booking Confirmation Fees for future bookings.',
  ];

  List<String> get refundSpecial => const [
    'Failed Service: If the ambulance does not arrive or the booking is not fulfilled for reasons outside the customer’s control, the Booking Confirmation Fee is fully refunded.',
    'Partial Service: If a trip is only partially completed due to operational issues, a partial refund may be considered on a case-by-case basis.',
    'Pre-Booked (e.g., Pregnancy): If the service is canceled in advance (before the scheduled date), a 75% refund applies. If canceled after assignment, standard cancellation rules apply.',
  ];

  List<String> get refundHow => const [
    'Refunds are processed automatically in eligible cases.',
    'For manual requests or disputes, contact AmbuFast support via app, website, WhatsApp (+8809678911911), or email (care@ambufast.com) with booking details.',
  ];

  List<String> get refundExceptions => const [
    'No refunds for completed rides or when the customer is at fault (e.g., providing incorrect pickup details, not being present at pickup).',
    'Refunds are not provided for cash paid directly to drivers after trip completion.',
  ];

  List<String> get refundUpdates => const [
    'AmbuFast may update this refund policy as needed. Changes will be communicated via app, website, or email.',
  ];

  List<String> get refundContact => const [
    'care@ambufast.com',
    '09678 911 911',
    'WhatsApp: +8809678911911',
  ];
}
