// lib/core/localization/app_translations.dart
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // ======================= ENGLISH =======================
    'en_US': {
      // ----- Common -----
      'back': 'Back',
      'powered':
      'Powered By SafeCare24/7 Medical Services Limited\nBeta Version 1.0',
      'choose': 'Choose',
      'done': 'Done',
      'select': 'Select',

      // ----- Welcome -----
      'welcome_title': 'Welcome to AmbuFast',
      'welcome_subtitle':
      'The largest ambulance network and ride sharing platform in Bangladesh',
      'login': 'Login',
      'create_account': 'Create Account',

      // ----- Language -----
      'language_english': 'English',
      'language_bangla': 'Bangla',
      'continue_btn': 'Continue',

      // ----- Login -----
      'login_title': 'Welcome to AmbuFast',
      'login_subtitle': 'Your Emergency Ride sharing Partner.',
      'tab_phone': 'Phone Number',
      'tab_email': 'Email Address',
      'label_phone': 'Phone',
      'label_email': 'Email',
      'label_password': 'Password',
      'hint_phone': 'Enter phone number',
      'hint_email': 'Enter email address',
      'hint_password': 'Enter password',
      'recover_password': 'Recover Password',
      'login_btn': 'Login',
      'no_account': 'Don’t have an account?',
      'create': 'Create',
      'country_code_bd': '+880',

      // ----- Recover Password -----
      'recover_title': 'Recover Password',
      'recover_subtitle_phone': 'Please enter the phone number you used during registration to proceed with resetting your password.',
      'recover_subtitle_email': 'Please enter the email address you used during registration to proceed with resetting your password.',
      'send_otp': 'Send OTP',
      'have_account_q': 'Have an account?',

      // ----- Verify OTP -----
      'verify_title': 'Verify Your Account',
      'verify_subtitle_phone':
      'We’ve sent a one-time password (OTP) to your phone number. Please enter the code below to complete verification.',
      'verify_subtitle_email':
      'We’ve sent a one-time password (OTP) to your email address. Please enter the code below to complete verification.',
      'resend_otp': 'Resend OTP',
      'change_phone': 'Change Phone Number',
      'change_email': 'Change Email',
      'verify_btn': 'Verify',
      'timer_mm_ss': '%s:%s',

      // ----- Create Account -----
      'create_account_title': 'Create Your AmbuFast Account',
      'full_name': 'Full Name*',
      'hint_full_name': 'Enter full name',
      'dob': 'Date of Birth*',
      'gender_q': 'What is your gender?*',
      'male': 'Male',
      'female': 'Female',
      'others': 'Others',
      'blood_group': 'Blood Group*',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'hint_confirm_password': 'Enter confirm password',
      'next': 'Next',
      'req_field': 'This field is required',
      'min_6_chars': 'Minimum 6 characters',
      'password_mismatch': 'Passwords do not match',
      'invalid_title': 'Invalid form',
      'invalid_msg': 'Please complete all required fields correctly.',
      'terms_pre_a': 'By continuing I agree with the ',
      'terms_pre_b': 'terms and condition',
      'agree_continue': 'Agree and Continue',

      // ----- Set New Password -----
      'setpw_title': 'Set New Password',
      'setpw_subtitle':
      'Your new password should be strong and easy for you to remember.',
      'pw': 'Password',
      'confirm_pw': 'Confirm Password',
      'hint_pw': 'Enter password',
      'hint_confirm_pw': 'Enter confirm password',
      'submit': 'Submit',
      'pw_mismatch': 'Passwords do not match',
      'pw_too_short': 'Password must be at least 8 characters',
      'pw_updated': 'Password updated successfully',

      // ----- Profile creating -----
      'profile_creating': 'Your profile is being created...',
      'profile_customising': 'Customising your recommendations...',

      // ========== HOME (NEW) ==========
      'app_name': 'AmbuFast',
      'home_where_to': 'Where to?',
      'home_go_later': 'Go Later',
      'home_view_all': 'View All',

      'home_emergency': 'Emergency',
      'home_emergency_ac_ambulance': 'AC Ambulance',
      'home_emergency_non_ac_ambulance': 'Non AC Ambulance',
      'home_emergency_icu_ambulance': 'ICU/CCU Ambulance',
      'home_emergency_freezing_van': 'Freezing Van',

      'home_non_emergency': 'Non Emergency',
      'home_non_emergency_motorcycle': 'Motorcycle',
      'home_non_emergency_cng': 'CNG',
      'home_non_emergency_micro': 'Micro',

      'home_upcoming_trips': 'Upcoming Trips',
      'home_upcoming': 'Upcoming',

      'home_offer_title': '30% Savings',
      'home_offer_sub': 'on pregnancy pre-booking',
      'home_offer_code': 'CODE  PREAB01',

      'home_low_cost_intracity': 'Low Cost Intracity',
      'home_campaign': 'Campaign',
      'home_campaign_heart_attack': 'Heart Attack',
      'home_campaign_dialysis': 'Dialysis',
      'home_campaign_disabled': 'Disable Patient',

      'home_last_ride_title': 'Last Ride with Respect',
      'home_last_ride_body':
      'Your donation ensures a dignified final journey for those who cannot afford funeral transport.',
      'home_support_now': 'Support Now',

      'home_funeral_support_title': 'Last Ride with Respect',
      'home_funeral_support_body':
      'If your family is struggling with funeral transport costs, apply for our donation-based service to ensure a respectful farewell.',
      'home_request_support': 'Request Support',

      //.........enable_location............
      'loc_enable_title': 'Enable your location',
      'loc_enable_subtitle':
      'Choose your location to start find the request around you',
      'loc_use_my_location': 'Use my location',
      'loc_skip': 'Skip for now',

      // --- Support screen (choose) ---
      'support': 'Support',
      'choose_cause': 'Choose a Cause',
      'choose_amount': 'Choose Amount',
      'others_amount': 'Others Amount',
      'enter_amount': 'Enter Amount',
      'cant_find': 'Can’t find what you’re looking for?',
      'contact_support': 'Contact Support',
      'review': 'Review',
      'validation_title': 'Validation',
      'validation_support_msg':
      'Please select a cause, set an amount and agree to the terms.',

      // Cause labels
      'cause_general_fund': 'General Fund',
      'cause_ambulance_trip_help': 'Ambulance Trip Help',
      'cause_emergency_medical_help': 'Emergency Medical Help',
      'cause_dead_body_transfer': 'Dead Body Transfer',

      // --- Support Review / Payment Method ---
      'support_review': 'Support Review',
      'cause': 'Cause',
      'amount': 'Amount',
      'edit_below': 'You can edit below',
      'change': 'Change',
      'choose_payment': 'Choose Payment Method',
      'pay_now': 'Pay Now',

      // Payment methods (titles)
      'bkash': 'bKash',
      'nagad': 'Nagad',
      'city_bank': 'City Bank',
      'visa_master': 'Visa/Master Card',
      'pay_station': 'Pay Station',

      // Payment method subtitles
      'pay_bkash': 'Pay with bKash',
      'discount_10': 'Get 10% discount',

      // Payment validation / messages
      'validation_payment_msg': 'Please select a payment method.',
      'selected_method': 'Selected Method: @method',

      'payment': 'Payment',
      'invoice_number': 'Invoice Number',
      'bdt': 'BDT',
      'your_bkash_number': 'Your bKash Account Number',
      'bkash_placeholder': 'e.g 01XXXXXXXXX',
      'confirm_process_prefix': 'Confirm and Process, ',
      'terms_and_conditions': 'terms & conditions',
      'cancel': 'Cancel',
      'confirm': 'Confirm',

      'payment_success_title': 'Payment Successful!\nYour Vehicle booking is confirmed.',
      'payment_success_body': 'We’ve received your booking payment of ৳@amount. Your Vehicle is on its way to your pickup location on time.',
      'go_to_my_activity': 'Go to My Activity',
      'back_to_home': 'Back to home',

      // === EN ===
      'request_support_title': 'Support Request',
      'request_support_step': 'Step 1 of 2',
      'start_a_request': 'Start A Request',
      'start_a_request_hint': 'Tell us what you need help with. You can upload bills or prescriptions for faster approval.',

      'request_cause': 'Request Cause*',
      'amount_needed': 'Amount Needed*',
      'urgency': 'Urgency*',
      'describe_situation': 'Describe Your Situation*',
      'hint_enter_amount': 'Enter amount',
      'hint_select_cause': 'Select cause',
      'hint_select_urgency': 'Select urgency',
      'hint_write_situation': 'Write your situation',

      'doc_upload_title': 'Document Upload (Optional)',
      'doc_upload_sub': 'Add bill or prescriptions',
      'doc_upload_drop': 'Drag your file(s) or browse',
      'doc_upload_max': 'Max 10 MB files are allowed',
      'doc_upload_types': 'Only support .jpg, .png files',

      'nid_front_title': 'Front Side of National ID Card*',
      'nid_back_title': 'Back Side of National ID Card*',
      'click_to_upload_front': 'Click to Upload Front Side of Card',
      'click_to_upload_back': 'Click to Upload Back Side of Card',
      'max_file_size_25': '(Max. File size: 25 MB)',

      'agree_verification': 'By submitting, you agree to our verification process and terms.',
      'continue': 'Continue',

// validation
      'vs_select_cause': 'Please select a request cause.',
      'vs_amount': 'Please enter a valid amount.',
      'vs_urgency': 'Please select urgency.',
      'vs_desc': 'Please describe your situation.',
      'vs_nid_front': 'Please upload NID front image.',
      'vs_nid_back': 'Please upload NID back image.',
      'vs_terms': 'Please agree to the terms to continue.',
      'file_too_large': 'File is larger than allowed size.',
      'file_type_invalid': 'Only JPG/PNG allowed.',


      // ===== EN =====
      'request_review_title': 'Request Review',
      'confirm_request': 'Confirm Your Request',
      'confirm_request_hint': 'Double-check details before submitting. You can always edit items below.',
      'step_2_of_2': 'Step 2 of 2',

      'rr_cause': 'Cause',
      'rr_amount_needed': 'Amount Needed',
      'rr_urgency': 'Urgency',
      'rr_describe': 'Describe you situation',

      'rr_you_can_edit_below': 'You Can Edit Below',
      'rr_change': 'Change',
      'rr_submit_for_review': 'Submit for Review',

      'rr_doc_clinic_bill': 'Clinic Bill',
      'rr_doc_front_id': 'Front ID',
      'rr_doc_back_id': 'Back ID',
      'rr_within_24h': 'Within 24 Hours',


      // ===== EN =====
      'rs_success_title': "You're all set",
      'rs_success_body': "Your request has been submitted for review.\nWe'll notify you as soon as it's approved.",
      'rs_estimated_label': 'Estimated: under 6 hours',
      'rs_go_to_activity': 'Go to My Activity',
      'rs_back_home': 'Back to home',


      // ----- Request Ride -----
      'request_ride_title': 'Request a Ride',
      'pickup_now': 'Pickup now',
      'for_me': 'For me',
      'ac_ambulance': 'AC Ambulance',
      'pickup_address_hint': 'Pickup address',
      'dropoff_address_hint': 'Drop-off address',
      'need_round_trip': 'I need round trip',
      'set_location_on_map': 'Set location on map',
      'saved_address': 'Saved address',
      'popular_places': 'Popular places',

      // ----- Request Ride (places) -----
      'place_airport_title': 'Hazrat Shahjalal International Airport',
      'place_airport_sub':   'Airport - Dakshinkhan Rd, Dhaka',

      'place_jfp_title':     'Jamuna Future Park',
      'place_jfp_sub':       'KA-244, Kuril, Progoti Shoroni, Dhaka',

      'place_bcity_title':   'Bashundhara City Shopping Complex',
      'place_bcity_sub':     '3 No Tejturi Bazar West, পল্লব পথ, ঢাকা',




// ----- Bottom sheets (When / Contact / Service) -----
      'when_sheet_title': 'When do you need a ride?',
      'when_now_title': 'Now',
      'when_now_sub': 'Request a ride, hop-in, and go',
      'when_later_title': 'Later',
      'when_later_sub': 'Reserve for extra peace of mind',

      'contact_sheet_title': 'Switch contact',
      'contact_me_title': 'Me',
      'contact_add_title': 'Add New Contact',

      'service_sheet_title': 'Switch service',
      'service_non_ac': 'Non AC Ambulance',
      'service_ac': 'AC Ambulance',
      'service_icu': 'ICU/CCU Ambulance',
      'service_freezing': 'Freezing Van',
      'service_row_sub': 'Request a ride, hop-in, and go',

      'signup_subtitle': 'Sign up or book emergency service in seconds.',




    },

    // ======================= BANGLA =======================
    'bn_BD': {
      // ----- Common -----
      'back': 'পিছনে',
      'powered':
      'Powered By SafeCare24/7 Medical Services Limited\nBeta Version 1.0',
      'choose': 'নির্বাচন করুন',
      'done': 'সম্পন্ন',
      'select': 'নির্বাচন করুন',

      // ----- Welcome -----
      'welcome_title': 'AmbuFast-এ স্বাগতম',
      'welcome_subtitle':
      'বাংলাদেশের বৃহত্তম অ্যাম্বুলেন্স নেটওয়ার্ক এবং রাইড শেয়ারিং প্ল্যাটফর্ম',
      'login': 'লগইন',
      'create_account': 'অ্যাকাউন্ট তৈরি করুন',

      // ----- Language -----
      'language_english': 'ইংরেজি',
      'language_bangla': 'বাংলা',
      'continue_btn': 'চালিয়ে যান',

      // ----- Login -----
      'login_title': 'AmbuFast এ স্বাগতম',
      'login_subtitle': 'আপনার জরুরি রাইড শেয়ারিং অংশীদার',
      'tab_phone': 'ফোন নম্বর',
      'tab_email': 'ইমেইল ঠিকানা',
      'label_phone': 'ফোন',
      'label_email': 'ইমেইল',
      'label_password': 'পাসওয়ার্ড',
      'hint_phone': 'ফোন নম্বর প্রবেশ করুন',
      'hint_email': 'ইমেইল ঠিকানা প্রবেশ করুন',
      'hint_password': 'পাসওয়ার্ড প্রবেশ করুন',
      'recover_password': 'পাসওয়ার্ড পুনরুদ্ধার করুন',
      'login_btn': 'লগইন',
      'no_account': 'অ্যাকাউন্ট নেই?',
      'create': 'তৈরি করুন',
      'country_code_bd': '+৮৮০',

      // ----- Recover Password -----
      'recover_title': 'পাসওয়ার্ড পুনরুদ্ধার করুন',
      'recover_subtitle_phone': 'পাসওয়ার্ড পুনরায় সেট করতে এগিয়ে যেতে নিবন্ধনের সময় আপনি যে ফোন নম্বরটি ব্যবহার করেছিলেন সেটি প্রবেশ করুন।',
      'recover_subtitle_email': 'পাসওয়ার্ড পুনরায় সেট করতে এগিয়ে যেতে নিবন্ধনের সময় আপনি যে ইমেইল ঠিকানাটি ব্যবহার করেছিলেন সেটি প্রবেশ করুন।',
      'send_otp': 'OTP পাঠান',
      'have_account_q': 'আপনার একটি অ্যাকাউন্ট আছে?',

      // ----- Verify OTP -----
      'verify_title': 'আপনার অ্যাকাউন্ট যাচাই করুন',
      'verify_subtitle_phone':
      'আমরা আপনার ফোন নম্বরে একটি এককালীন পাসওয়ার্ড (OTP) পাঠিয়েছি। যাচাইকরণ সম্পূর্ণ করতে নিচের কোডটি প্রবেশ করুন।',
      'verify_subtitle_email':
      'আমরা আপনার ইমেইল ঠিকানায় একটি এককালীন পাসওয়ার্ড (OTP) পাঠিয়েছি। যাচাইকরণ সম্পূর্ণ করতে নিচের কোডটি প্রবেশ করুন।',
      'resend_otp': 'পুনরায় OTP পাঠান',
      'change_phone': 'ফোন নম্বর পরিবর্তন করুন',
      'change_email': 'ইমেইল পরিবর্তন করুন',
      'verify_btn': 'যাচাই করুন',
      'timer_mm_ss': '%s:%s',

      // ----- Create Account -----
      'create_account_title': 'আপনার AmbuFast অ্যাকাউন্ট তৈরি করুন',
      'full_name': 'পূর্ণ নাম*',
      'hint_full_name': 'পূর্ণ নাম প্রবেশ করুন',
      'dob': 'জন্ম তারিখ*',
      'gender_q': 'আপনার লিঙ্গ কী?*',
      'male': 'পুরুষ',
      'female': 'মহিলা',
      'others': 'অন্যান্য',
      'blood_group': 'রক্তের গ্রুপ*',
      'password': 'পাসওয়ার্ড',
      'confirm_password': 'পাসওয়ার্ড নিশ্চিত করুন',
      'hint_confirm_password': 'পাসওয়ার্ড নিশ্চিত করে প্রবেশ করুন',
      'next': 'পরবর্তী',
      'req_field': 'এই ঘরটি বাধ্যতামূলক',
      'min_6_chars': 'কমপক্ষে ৬ অক্ষর',
      'password_mismatch': 'পাসওয়ার্ড মেলেনি',
      'invalid_title': 'ফর্ম সঠিক নয়',
      'invalid_msg': 'দয়া করে সব প্রয়োজনীয় ঘর সঠিকভাবে পূরণ করুন।',
      'terms_pre_a': 'চালিয়ে যাওয়ার মাধ্যমে আমি ',
      'terms_pre_b': 'শর্তাবলী এবং শর্তাবলীর সাথে একমত',
      'agree_continue': 'একমত এবং চালিয়ে যান',

      // ----- Profile creating -----
      'profile_creating': 'আপনার প্রোফাইল তৈরি হচ্ছে...',
      'profile_customising': 'আপনার সুপারিশগুলি কাস্টমাইজ করা হচ্ছে...',

      // ========== HOME (নতুন) ==========
      'app_name': 'AmbuFast',
      'home_where_to': 'কোথায় যাবেন?',
      'home_go_later': 'পরে যাব',
      'home_view_all': 'সবগুলো দেখুন',

      'home_emergency': 'জরুরি অবস্থা',
      'home_emergency_ac_ambulance': 'এসি অ্যাম্বুলেন্স',
      'home_emergency_non_ac_ambulance': 'নন এসি অ্যাম্বুলেন্স',
      'home_emergency_icu_ambulance': 'আইসিইউ/সিসিইউ অ্যাম্বুলেন্স',
      'home_emergency_freezing_van': 'ফ্রিজিং ভ্যান',

      'home_non_emergency': 'নন-জরুরি',
      'home_non_emergency_motorcycle': 'মোটরসাইকেল',
      'home_non_emergency_cng': 'সিএনজি',
      'home_non_emergency_micro': 'মাইক্রো',

      'home_upcoming_trips': 'আসন্ন ভ্রমণ',
      'home_upcoming': 'আসছে',

      'home_offer_title': '৩০% সেভিংস',
      'home_offer_sub': 'প্রেগন্যান্সি প্রি-বুকিং এ',
      'home_offer_code': 'কোড  PREAB01',

      'home_low_cost_intracity': 'কম খরচে ইনট্রাসিটি',
      'home_campaign': 'ক্যাম্পেইন',
      'home_campaign_heart_attack': 'হার্ট অ্যাটাক',
      'home_campaign_dialysis': 'ডায়ালাইসিস',
      'home_campaign_disabled': 'প্রতিবন্ধী রোগী',

      'home_last_ride_title': 'সম্মানের সাথে শেষ যাত্রা',
      'home_last_ride_body':
      'আপনার দান সেইসব মানুষের মর্যাদাপূর্ণ শেষ যাত্রা নিশ্চিত করে যারা ফিউনারেল ট্রান্সপোর্টে সক্ষম নন।',
      'home_support_now': 'এখনই সহায়তা করুন',

      'home_funeral_support_title': 'সম্মানের সাথে শেষ যাত্রা',
      'home_funeral_support_body':
      'আপনার পরিবার যদি ফিউনারেল ট্রান্সপোর্ট ব্যয়ে সমস্যায় থাকে, সম্মানজনক বিদায় নিশ্চিত করতে আমাদের ডোনেশন-ভিত্তিক সার্ভিসে আবেদন করুন।',
      'home_request_support': 'সাপোর্ট রিকোয়েস্ট',

      //.........enable_location............
      'loc_enable_title': 'আপনার অবস্থান সক্ষম করুন',
      'loc_enable_subtitle':
      'আপনার আশেপাশে অনুরোধটি খুঁজে পেতে আপনার অবস্থান নির্বাচন করুন',
      'loc_use_my_location': 'আমার অবস্থান ব্যবহার করুন',
      'loc_skip': 'আপাতত এড়িয়ে যান',

      // --- Support screen (choose) ---
      'support': 'সহায়তা',
      'choose_cause': 'একটি কারণ বেছে নিন',
      'choose_amount': 'পরিমাণ বেছে নিন',
      'others_amount': 'অন্যান্য পরিমাণ',
      'enter_amount': 'পরিমাণ লিখুন',
      'cant_find': 'আপনি যা খুঁজছেন তা খুঁজে পাচ্ছেন না?',
      'contact_support': 'সাপোর্ট সাথে যোগাযোগ করুন',
      'review': 'পর্যালোচনা',
      'validation_title': 'যাচাই',
      'validation_support_msg':
      'অনুগ্রহ করে একটি কারণ নির্বাচন করুন, পরিমাণ দিন এবং শর্তাবলীতে সম্মতি দিন।',

      // Cause labels
      'cause_general_fund': 'সাধারণ তহবিল',
      'cause_ambulance_trip_help': 'অ্যাম্বুলেন্স ট্রিপ সহায়তা',
      'cause_emergency_medical_help': 'জরুরি চিকিৎসা সহায়তা',
      'cause_dead_body_transfer': 'মৃতদেহ স্থানান্তর',

      // --- Support Review / Payment Method ---
      'support_review': 'সহায়তার পর্যালোচনা',
      'cause': 'কারণ',
      'amount': 'পরিমাণ',
      'edit_below': 'আপনি নীচে সম্পাদনা করতে পারবেন',
      'change': 'পরিবর্তন',
      'choose_payment': 'পেমেন্ট পদ্ধতি বেছে নিন',
      'pay_now': 'এখনই পেমেন্ট করুন',

      // Payment methods (titles)
      'bkash': 'বিকাশ',
      'nagad': 'নগদ',
      'city_bank': 'সিটি ব্যাংক',
      'visa_master': 'ভিসা/মাস্টার কার্ড',
      'pay_station': 'পে',

      // Payment method subtitles
      'pay_bkash': 'বিকাশ দিয়ে পেমেন্ট করুন',
      'discount_10': '১০% ছাড় পান',

      // Payment validation / messages
      'validation_payment_msg': 'একটি পেমেন্ট পদ্ধতি নির্বাচন করুন।',
      'selected_method': 'নির্বাচিত পদ্ধতি: @method',

      'payment': 'পেমেন্ট',
      'invoice_number': 'ইনভয়েস নম্বর',
      'bdt': 'বিডিটি',
      'your_bkash_number': 'আপনার বিকাশ একাউন্ট নাম্বার',
      'bkash_placeholder': 'যেমন 01XXXXXXXXX',
      'confirm_process_prefix': 'কনফার্ম ও প্রসেস, ',
      'terms_and_conditions': 'টার্মস অ্যান্ড কন্ডিশনস',
      'cancel': 'বাতিল',
      'confirm': 'কনফার্ম',

      'payment_success_title': 'পেমেন্ট সফল!\nআপনার গাড়ির বুকিং নিশ্চিত হয়েছে।',
      'payment_success_body': 'আমরা আপনার বুকিং পেমেন্ট (৳@amount) পেয়েছি। আপনার গাড়ি সময়মতো আপনার পিকআপ লোকেশনের পথে রয়েছে।',
      'go_to_my_activity': 'আমার কার্যকলাপে যান',
      'back_to_home': 'বাড়ি ফিরে যাও',


      // === BN ===
      'request_support_title': 'সহায়তার জন্য অনুরোধ',
      'request_support_step': 'ধাপ ১ এর মধ্যে ২',
      'start_a_request': 'একটি অনুরোধ শুরু করুন',
      'start_a_request_hint': 'আপনি কী সহায়তা চান জানিয়ে দিন। দ্রুত অনুমোদনের জন্য বিল বা প্রেসক্রিপশন আপলোড করতে পারেন।',

      'request_cause': 'অনুরোধের কারণ*',
      'amount_needed': 'প্রয়োজনীয় পরিমাণ*',
      'urgency': 'জরুরিতা*',
      'describe_situation': 'আপনার পরিস্থিতি বর্ণনা করুন*',
      'hint_enter_amount': 'পরিমাণ লিখুন',
      'hint_select_cause': 'কারণ নির্বাচন করুন',
      'hint_select_urgency': 'জরুরিতা নির্বাচন করুন',
      'hint_write_situation': 'আপনার পরিস্থিতি লিখুন',

      'doc_upload_title': 'ডকুমেন্ট আপলোড (ঐচ্ছিক)',
      'doc_upload_sub': 'বিল বা প্রেসক্রিপশন যোগ করুন',
      'doc_upload_drop': 'ফাইল টানুন (ড্র্যাগ) অথবা ব্রাউজ করুন',
      'doc_upload_max': 'সর্বোচ্চ ১০ এমবি ফাইল অনুমোদিত',
      'doc_upload_types': 'শুধু .jpg, .png ফাইল সমর্থন করে',

      'nid_front_title': 'জাতীয় পরিচয়পত্র সামনের দিক*',
      'nid_back_title': 'জাতীয় পরিচয়পত্র পিছনের দিক*',
      'click_to_upload_front': 'কার্ডের সামনের দিকটি আপলোড করতে ক্লিক করুন',
      'click_to_upload_back': 'কার্ডের পিছনের দিকটি আপলোড করতে ক্লিক করুন',
      'max_file_size_25': '(সর্বোচ্চ ফাইল সাইজ: ২৫ এমবি)',

      'agree_verification': 'জমা দেওয়ার মাধ্যমে, আপনি আমাদের যাচাইকরণ প্রক্রিয়া এবং শর্তাবলীতে সম্মতি দিচ্ছেন।',
      'continue': 'চালিয়ে যান',

// validation
      'vs_select_cause': 'অনুগ্রহ করে একটি কারণ নির্বাচন করুন।',
      'vs_amount': 'অনুগ্রহ করে সঠিক পরিমাণ লিখুন।',
      'vs_urgency': 'অনুগ্রহ করে জরুরিতা নির্বাচন করুন।',
      'vs_desc': 'অনুগ্রহ করে আপনার পরিস্থিতি লিখুন।',
      'vs_nid_front': 'অনুগ্রহ করে এনআইডি সামনের দিক আপলোড করুন।',
      'vs_nid_back': 'অনুগ্রহ করে এনআইডি পিছনের দিক আপলোড করুন।',
      'vs_terms': 'চালিয়ে যেতে শর্তাবলীতে সম্মতি দিন।',
      'file_too_large': 'ফাইল অনুমোদিত সাইজের বেশি।',
      'file_type_invalid': 'শুধুমাত্র JPG/PNG অনুমোদিত।',


      // ===== BN =====
      'request_review_title': 'পর্যালোচনার অনুরোধ',
      'confirm_request': 'আপনার অনুরোধ নিশ্চিত করুন',
      'confirm_request_hint': 'জমা দেওয়ার আগে বিশদ বিবরণ দু’বার পরীক্ষা করুন। আপনি যেকোনো সময় নীচের আইটেমগুলি সম্পাদনা করতে পারবেন।',
      'step_2_of_2': 'ধাপ ২ এর মধ্যে ২',

      'rr_cause': 'কারণ',
      'rr_amount_needed': 'প্রয়োজনীয় পরিমাণ',
      'rr_urgency': 'জরুরি অবস্থা',
      'rr_describe': 'তোমার পরিস্থিতি বর্ণনা করো',

      'rr_you_can_edit_below': 'আপনি নীচে সম্পাদনা করতে পারেন',
      'rr_change': 'পরিবর্তন',
      'rr_submit_for_review': 'পর্যালোচনার জন্য জমা দিন',

      'rr_doc_clinic_bill': 'ক্লিনিক বিল',
      'rr_doc_front_id': 'ফ্রন্ট আইডি',
      'rr_doc_back_id': 'ব্যাক আইডি',
      'rr_within_24h': '২৪ ঘন্টার মধ্যে',

      // ===== BN =====
      'rs_success_title': 'তুমি সম্পূর্ণ প্রস্তুত।',
      'rs_success_body': 'আপনার অনুরোধটি পর্যালোচনার জন্য জমা দেওয়া হয়েছে।\nএটি অনুমোদিত হওয়ার সাথে সাথে আমরা আপনাকে জানাবো।',
      'rs_estimated_label': 'আনুমানিক: ৬ ঘণ্টার কম',
      'rs_go_to_activity': 'আমার কার্যকলাপে যান',
      'rs_back_home': 'হোম পেজে যাও',

      // ----- Request Ride -----
      'request_ride_title': 'যাত্রার অনুরোধ করুন',
      'pickup_now': 'এখনই',
      'for_me': 'আমার জন্য',
      'ac_ambulance': 'এসি অ্যাম্বুলেন্স',
      'pickup_address_hint': 'পিকআপ ঠিকানা',
      'dropoff_address_hint': 'ড্রপ-অফ ঠিকানা',
      'need_round_trip': 'আমার আবার যাওয়ার দরকার।', // note the "।"
      'set_location_on_map': 'মানচিত্রে অবস্থান সেট করুন',
      'saved_address': 'সংরক্ষিত ঠিকানা',
      'popular_places': 'জনপ্রিয় স্থান',


      // ----- Request Ride (places) -----
      'place_airport_title': 'হযরত শাহজালাল আন্তর্জাতিক বিমানবন্দর',
      'place_airport_sub':   'বিমানবন্দর – দক্ষিণখান সড়ক, ঢাকা',

      'place_jfp_title':     'যমুনা ফিউচার পার্ক',
      'place_jfp_sub':       'KA-244, কুরিল, প্রগতি সরণি, ঢাকা',

      'place_bcity_title':   'বসুন্ধরা সিটি শপিং কমপ্লেক্স',
      'place_bcity_sub':     '৩ নং তেজতুরী বাজার পশ্চিম, পল্লব পথ, ঢাকা',



// ----- Bottom sheets (When / Contact / Service) -----
      'when_sheet_title': 'কখন আপনার যাত্রার প্রয়োজন?',
      'when_now_title': 'এখন',
      'when_now_sub': 'যাত্রার অনুরোধ করুন, লাফিয়ে উঠুন এবং যান',
      'when_later_title': 'পরে',
      'when_later_sub': 'অতিরিক্ত মানসিক প্রশান্তির জন্য রিজার্ভ করুন',

      'contact_sheet_title': 'পরিচিতি পরিবর্তন করুন',
      'contact_me_title': 'আমি',
      'contact_add_title': 'নতুন পরিচিতি যোগ করুন',

      'service_sheet_title': 'পরিসেবা পরিবর্তন করুন',
      'service_non_ac': 'নন এসি অ্যাম্বুলেন্স',
      'service_ac': 'এসি অ্যাম্বুলেন্স',
      'service_icu': 'আইসিইউ/সিসিইউ অ্যাম্বুলেন্স',
      'service_freezing': 'ফ্রিজিং ভ্যান',
      'service_row_sub': 'যাত্রার অনুরোধ করুন, লাফিয়ে উঠুন এবং যান',

      'signup_subtitle': 'সেকেন্ডের মধ্যে সাইন আপ করুন বা জরুরি সেবা বুক করুন।',

    },
  };
}
