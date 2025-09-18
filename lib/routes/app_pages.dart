// lib/routes/app_pages.dart
import 'package:get/get.dart';


import '../module/account/create_account_controller.dart';
import '../module/account/create_account_view.dart';
import '../module/bkash_payment/bkash_payment_controller.dart';
import '../module/bkash_payment/bkash_payment_view.dart';
import '../module/donate/donate_money_controller.dart';
import '../module/donate/donate_money_view.dart';
import '../module/donate_payment_setection/support_payment_controller.dart';
import '../module/donate_payment_setection/support_payment_view.dart';
import '../module/home/home_controller.dart';
import '../module/home/home_view.dart';
import '../module/language/language_controller.dart';
import '../module/language/language_view.dart';
import '../module/launch/launch_screen_controller.dart';
import '../module/launch/launch_screen_view.dart';
import '../module/login/login_controller.dart';
import '../module/login/login_view.dart';
import '../module/payment_success/payment_success_controller.dart';
import '../module/payment_success/payment_success_view.dart';
import '../module/recover/recover_controller.dart';
import '../module/recover/recover_view.dart';
import '../module/request_submission_success/request_submission_success_controller.dart';
import '../module/request_submission_success/request_submission_success_view.dart';
import '../module/ride/request_ride_controller.dart';
import '../module/ride/request_ride_view.dart';
import '../module/set_password/set_password_controller.dart';
import '../module/set_password/set_password_view.dart';
import '../module/support_request/support_request_controller.dart';
import '../module/support_request/support_request_view.dart';
import '../module/support_request_review/support_request_review_controller.dart';
import '../module/support_request_review/support_request_review_view.dart';
import '../module/verify/verify_controller.dart';
import '../module/verify/verify_view.dart';
import 'app_routes.dart';


class AppPages {
  AppPages._();

  static final initial = Routes.language;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.launch,
      page: () => const LaunchScreenView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LaunchScreenController>(() => LaunchScreenController());
      }),
    ),

    GetPage(
      name: Routes.language,
      page: () => const LanguageView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LanguageController>(() => LanguageController());
      }),
    ),

    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        // ✅ Add fenix: true so a fresh LoginController is recreated
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),


    GetPage(
      name: Routes.recover,
      page: () => const RecoverView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<RecoverController>(() => RecoverController());
      }),
    ),

    GetPage(
      name: Routes.verify,
      page: () => const VerifyView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<VerifyController>(() => VerifyController());
      }),
    ),

    GetPage(
      name: Routes.setPassword,
      page: () => const SetPasswordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SetPasswordController>(() => SetPasswordController());
      }),
    ),
    GetPage(
      name: Routes.createAccount,
      page: () => const CreateAccountView(),
      binding: BindingsBuilder.put(() => CreateAccountController()),
    ),

    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),

    GetPage(
      name: Routes.donateMoney,
      page: () => const DonateMoneyView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DonateMoneyController>(() => DonateMoneyController());
      }),
    ),

    GetPage(
      name: Routes.supportPayment,
      page: () => const SupportPaymentView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SupportPaymentController>(() => SupportPaymentController());
      }),
    ),

    GetPage(
      name: Routes.bkashPayment,
      page: () => const BkashPaymentView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<BkashPaymentController>(() => BkashPaymentController());
      }),
    ),

    GetPage(
      name: Routes.paymentSuccessful,
      page: () => const PaymentSuccessView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PaymentSuccessController>(() => PaymentSuccessController());
      }),
    ),

    GetPage(
      name: Routes.requestSupport,
      page: () => const SupportRequestView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SupportRequestController>(() => SupportRequestController());
      }),
    ),

    GetPage(
      name: Routes.supportRequestReview,
      page: () => const SupportRequestReviewView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SupportRequestReviewController>(
              () => SupportRequestReviewController(),
        );
      }),
    ),

    GetPage(
      name: Routes.requestSubmissionSuccess,
      page: () => const RequestSubmissionSuccessView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<RequestSubmissionSuccessController>(
              () => RequestSubmissionSuccessController(),
        );
      }),
    ),

    GetPage(
      name: Routes.requestRide,
      page: () => const RequestRideView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<RequestRideController>(() => RequestRideController());
      }),
    ),


  ];
}
