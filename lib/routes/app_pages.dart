import 'package:ambufast_driver/module/down_trip/create_down_trip_controller.dart';
import 'package:ambufast_driver/module/down_trip/create_down_trip_view.dart';
import 'package:ambufast_driver/module/subscription/payment_history_controller.dart';
import 'package:ambufast_driver/module/subscription/payment_history_view.dart';
import 'package:ambufast_driver/module/trip_request/trip_await_payment_controller.dart';
import 'package:ambufast_driver/module/trip_request/trip_await_payment_view.dart';
import 'package:ambufast_driver/module/trip_request/trip_request_controller.dart';
import 'package:ambufast_driver/module/trip_request/trip_request_view.dart';
import 'package:ambufast_driver/module/trip_track/trip_payment_controller.dart';
import 'package:ambufast_driver/module/trip_track/trip_payment_view.dart';
import 'package:ambufast_driver/module/trip_track/trip_track_controller.dart';
import 'package:ambufast_driver/module/trip_track/trip_track_view.dart';
import 'package:get/get.dart';
import '../legal/legal_policy_controller.dart';
import '../legal/legal_policy_view.dart';
import '../legal/payment_cancellation_view.dart';
import '../module/account/account_controller.dart';
import '../module/account/account_view.dart';
import '../module/account/create_account_controller.dart';
import '../module/account/create_account_view.dart';
import '../module/account/profile_creating_view.dart';
import '../module/activity/activity_controller.dart';
import '../module/activity/activity_view.dart';
import '../module/all_review/all_review_controller.dart';
import '../module/all_review/all_review_view.dart';
import '../module/bkash_payment/bkash_payment_controller.dart';
import '../module/bkash_payment/bkash_payment_view.dart';
import '../module/car/car_details_controller.dart';
import '../module/car/car_details_view.dart';
import '../module/change_password/change_password_controller.dart';
import '../module/change_password/change_password_view.dart';
import '../module/contact_support/contact_support_controller.dart';
import '../module/contact_support/contact_support_view.dart';
import '../module/delete_account/delete_account_controller.dart';
import '../module/delete_account/delete_account_view.dart';
import '../module/donate/donate_money_controller.dart';
import '../module/donate/donate_money_view.dart';
import '../module/donate_payment_setection/support_payment_controller.dart';
import '../module/donate_payment_setection/support_payment_view.dart';
import '../module/down_trip/create_down_trip_messsage.dart';
import '../module/down_trip/down_trip_controller.dart';
import '../module/down_trip/down_trip_view.dart';
import '../module/edit_profile_details/edit_profile_details_controller.dart';
import '../module/edit_profile_details/edit_profile_details_view.dart';
import '../module/emergency_sos/emergency_sos_controller.dart';
import '../module/emergency_sos/emergency_sos_view.dart';
import '../module/help_center/help_center_controller.dart';
import '../module/help_center/help_center_view.dart';
import '../module/home/home_controller.dart';
import '../module/home/home_view.dart';
import '../module/input_profile_details/input_profile_details_controller.dart';
import '../module/input_profile_details/input_profile_details_view.dart';
import '../module/language/language_controller.dart';
import '../module/language/language_view.dart';
import '../module/launch/launch_screen_controller.dart';
import '../module/launch/launch_screen_view.dart';
import '../module/licence/licence_details_controller.dart';
import '../module/licence/licence_details_view.dart';
import '../module/login/login_controller.dart';
import '../module/login/login_view.dart';
import '../module/notification/notification_controller.dart';
import '../module/notification/notification_view.dart';
import '../module/payment_success/payment_success_controller.dart';
import '../module/payment_success/payment_success_view.dart';
import '../module/profile_details/profile_details_controller.dart';
import '../module/profile_details/profile_details_view.dart';
import '../module/rating/rating_controller.dart';
import '../module/rating/rating_view.dart';
import '../module/recover/recover_controller.dart';
import '../module/recover/recover_view.dart';
import '../module/request_submission_success/request_submission_success_controller.dart';
import '../module/request_submission_success/request_submission_success_view.dart';
import '../module/ride/request_ride_controller.dart';
import '../module/ride/request_ride_view.dart';
import '../module/search_trip/search_trip_controller.dart';
import '../module/search_trip/search_trip_view.dart';
import '../module/set_password/set_password_controller.dart';
import '../module/set_password/set_password_view.dart';
import '../module/subscription/subscription_controller.dart';
import '../module/subscription/subscription_view.dart';
import '../module/support_request/support_request_controller.dart';
import '../module/support_request/support_request_view.dart';
import '../module/support_request_review/support_request_review_controller.dart';
import '../module/support_request_review/support_request_review_view.dart';
import '../module/trip_details/trip_details_controller.dart';
import '../module/trip_details/trip_details_view.dart';
import '../module/vehicles/my_vehicles_controller.dart';
import '../module/vehicles/my_vehicles_view.dart';
import '../module/verify/verify_controller.dart';
import '../module/verify/verify_view.dart';
import '../module/waiting_approval/waiting_approval_controller.dart';
import '../module/waiting_approval/waiting_approval_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

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
    GetPage(
      name: Routes.inputProfileDetails,
      page: () => const InputProfileDetailsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<InputProfileDetailsController>(
          () => InputProfileDetailsController(),
        );
      }),
    ),
    GetPage(
      name: Routes.licenceDetails,
      page: () => const LicenceDetailsView(),
      binding: BindingsBuilder(() {
        Get.put(LicenceDetailsController());
      }),
    ),
    GetPage(
      name: Routes.carDetails,
      page: () => const CarDetailsView(),
      binding: BindingsBuilder(() {
        Get.put(CarDetailsController());
      }),
    ),
    GetPage(
      name: Routes.waitingApproval,
      page: () => const WaitingApprovalView(),
      binding: BindingsBuilder(() {
        Get.put(WaitingApprovalController());
      }),
    ),
    GetPage(
        name: Routes.profileCreating, page: () => const ProfileCreatingView()),
    GetPage(
      name: Routes.account,
      page: () => const AccountView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AccountController>(() => AccountController());
      }),
    ),
    GetPage(
      name: Routes.profileDetails,
      page: () => const ProfileDetailsView(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<ProfileDetailsController>()) {
          Get.delete<ProfileDetailsController>(force: true);
        }
        Get.put(ProfileDetailsController());
      }),
    ),
    GetPage(
      name: Routes.editProfileDetails,
      page: () => const EditProfileDetailsView(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<EditProfileDetailsController>()) {
          Get.delete<EditProfileDetailsController>(force: true);
        }
        Get.put(EditProfileDetailsController());
      }),
    ),
    GetPage(
      name: Routes.allReview,
      page: () => const AllReviewView(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<AllReviewController>()) {
          Get.delete<AllReviewController>(force: true);
        }
        Get.put(AllReviewController());
      }),
    ),
    GetPage(
      name: Routes.emergencySos,
      page: () => const EmergencySosView(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<EmergencySosController>()) {
          Get.delete<EmergencySosController>(force: true);
        }
        Get.put(EmergencySosController());
      }),
    ),
    GetPage(
      name: Routes.myVehicles,
      page: () => const MyVehiclesView(),
      binding: BindingsBuilder(() {
        // Ensure a fresh controller each time you open the screen
        if (Get.isRegistered<MyVehiclesController>()) {
          Get.delete<MyVehiclesController>(force: true);
        }
        Get.put(MyVehiclesController());
      }),
    ),
    GetPage(
      name: Routes.helpCenter,
      page: () => const HelpCenterView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HelpCenterController>(() => HelpCenterController());
      }),
    ),
    GetPage(
      name: Routes.contactSupport,
      page: () => const ContactSupportView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ContactSupportController>(() => ContactSupportController());
      }),
    ),
    GetPage(
      name: Routes.legalPolicy,
      page: () => const LegalPolicyView(),
      binding: BindingsBuilder(() {
        // New instance on every Get.find<LegalPolicyController>()
        Get.create<LegalPolicyController>(() => LegalPolicyController());
      }),
    ),
    GetPage(
      name: Routes.cancellationPaymentInfo,
      page: () => const PaymentCancellationInfoView(),
    ),
    GetPage(
      name: Routes.changePassword,
      page: () => const ChangePasswordView(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<ChangePasswordController>()) {
          Get.delete<ChangePasswordController>(force: true);
        }
        Get.put(ChangePasswordController());
      }),
    ),
    GetPage(
      name: Routes.deleteAccount,
      page: () => const DeleteAccountView(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<DeleteAccountController>()) {
          Get.delete<DeleteAccountController>(force: true);
        }
        Get.put(DeleteAccountController());
      }),
    ),
    GetPage(
      name: Routes.notification,
      page: () => const NotificationView(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<NotificationController>()) {
          Get.delete<NotificationController>(force: true);
        }
        Get.put(NotificationController());
      }),
    ),
    GetPage(
      name: Routes.activity,
      page: () => const ActivityView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ActivityController>(() => ActivityController());
      }),
    ),
    GetPage(
      name: Routes.rating,
      page: () => const RatingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<RatingController>(() => RatingController());
      }),
    ),
    GetPage(
      name: Routes.tripDetails,
      page: () => const TripDetailsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TripDetailsController>(() => TripDetailsController());
      }),
    ),
    GetPage(
      name: Routes.downTrip,
      page: () => const DownTripView(),
      binding: BindingsBuilder(() {
        Get.put(DownTripController());
      }),
    ),
    GetPage(
      name: Routes.searchTrip,
      page: () => const SearchTripView(),
      binding: BindingsBuilder(() {
        Get.put(SearchTripController());
      }),
    ),
    GetPage(
      name: Routes.tripRequest,
      page: () => const TripRequestView(),
      binding: BindingsBuilder(() {
        Get.put(TripRequestController());
      }),
    ),
    GetPage(
      name: Routes.tripAwaitPayment,
      page: () => const TripAwaitPaymentView(),
      binding: BindingsBuilder(() {
        Get.put(TripAwaitPaymentController());
      }),
    ),
    GetPage(
      name: Routes.tripStart,
      page: () => const TripTrackView(),
      binding: BindingsBuilder(() {
        Get.put(TripTrackController());
      }),
    ),
    GetPage(
      name: Routes.tripPayment,
      page: () => const TripPaymentView(),
      binding: BindingsBuilder(() {
        Get.put(TripPaymentController());
      }),
    ),
    GetPage(
      name: Routes.createDownTripMessage,
      page: () => const CreateDownTripMessage(),
      binding: BindingsBuilder(() {
        Get.put(DownTripController());
      }),
    ),
    GetPage(
      name: Routes.downTripCreate,
      page: () => const CreateDownTripView(),
      binding: BindingsBuilder(() {
        Get.put(CreateDownTripController());
      }),
    ),
    GetPage(
      name: Routes.subscription,
      page: () => const SubscriptionView(),
      binding: BindingsBuilder(() {
        Get.put(SubscriptionController());
      }),
    ),
    GetPage(
      name: Routes.paymentHistory,
      page: () => const PaymentHistoryView(),
      binding: BindingsBuilder(() {
        Get.put(PaymentHistoryController());
      }),
    ),
  ];
}
