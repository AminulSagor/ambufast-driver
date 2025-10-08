import 'package:get/get.dart';

enum NotifType { regular, promo }

class NotificationItem {
  final String titleKey;
  final String? subKey;
  final String time; // already formatted (e.g., "20 min ago")
  final NotifType type;
  final bool isToday;
  NotificationItem({
    required this.titleKey,
    this.subKey,
    required this.time,
    required this.type,
    required this.isToday,
  });
}

class NotificationController extends GetxController {
  final items = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Seed sample data (match screenshots)
    items.assignAll([
      NotificationItem(
        titleKey: 'notif_rate_title',
        subKey: 'notif_rate_sub',
        time: 'ago_min'.trParams({'x': '20'}),
        type: NotifType.regular,
        isToday: true,
      ),
      NotificationItem(
        titleKey: 'notif_paypal_title',
        subKey: null,
        time: 'ago_min'.trParams({'x': '50'}),
        type: NotifType.promo,
        isToday: true,
      ),
      NotificationItem(
        titleKey: 'notif_coupon_title',
        time: 'ago_day'.trParams({'x': '01'}),
        type: NotifType.regular,
        isToday: false,
      ),
      NotificationItem(
        titleKey: 'notif_update_photo_title',
        time: 'ago_week'.trParams({'x': '1'}),
        type: NotifType.regular,
        isToday: false,
      ),
      NotificationItem(
        titleKey: 'notif_rate_title',
        subKey: 'notif_rate_sub',
        time: 'ago_week'.trParams({'x': '7'}),
        type: NotifType.regular,
        isToday: false,
      ),
      NotificationItem(
        titleKey: 'notif_paypal_title',
        time: 'ago_month'.trParams({'x': '6'}),
        type: NotifType.promo,
        isToday: false,
      ),
      NotificationItem(
        titleKey: 'notif_coupon_title',
        time: 'ago_day'.trParams({'x': '01'}),
        type: NotifType.regular,
        isToday: false,
      ),
    ]);
  }

  List<NotificationItem> get today =>
      items.where((e) => e.isToday).toList(growable: false);

  List<NotificationItem> get earlier =>
      items.where((e) => !e.isToday).toList(growable: false);
}
