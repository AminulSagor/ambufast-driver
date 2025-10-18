import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'models/earning_entry.dart';

/// Preset list shown in the inner sheet.
enum FilterPreset { today, yesterday, lastWeek, lastMonth, lastYear, custom }

class EarningsController extends GetxController {
  final isLoading = true.obs;
  final entries = <EarningEntry>[].obs;

  // Filtering state
  final selectedPreset = FilterPreset.lastYear.obs;
  final customStart = Rxn<DateTime>();
  final customEnd = Rxn<DateTime>();

  // derived
  final totalTrips = 0.obs;
  final totalDrivingMinutes = 0.obs;
  final totalEarning = 0.0.obs;

  String get _locale => Get.locale?.toLanguageTag() ?? Intl.getCurrentLocale();

  NumberFormat get moneyFmt => NumberFormat.currency(
        locale: _locale,
        symbol: (Get.locale?.languageCode == 'bn') ? '৳' : '\$',
        decimalDigits: 2,
      );

  DateFormat get monthHeaderFmt => DateFormat('MMMM yyyy', _locale);
  DateFormat get rowDateFmt => DateFormat('dd MMMM yyyy, hh:mm a', _locale);

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));

    // --------- mock data ----------
    final now = DateTime.now();
    final List<EarningEntry> mock = [];
    const base = 873.01;

    for (int m in [1, 2, 3, 10, 11, 12]) {
      mock.add(EarningEntry(
        date: DateTime(now.year - 1, m, 1, 16, 40),
        amount: base,
        referenceId: 'AMB-${now.year - 1}$m-12313',
        drivingMinutes: 170,
      ));
    }
    for (int m in [1, 2, 3, 10, 11, 12]) {
      mock.add(EarningEntry(
        date: DateTime(now.year - 1, m, 1, 16, 40),
        amount: base,
        referenceId: 'AMB-${now.year - 1}$m-12313',
        drivingMinutes: 170,
      ));
    }
    for (int m in [1, 2, 3, 4, 5, 6]) {
      mock.add(EarningEntry(
        date: DateTime(now.year, m, 1, 16, 40),
        amount: base,
        referenceId: 'AMB-${now.year}$m-12313',
        drivingMinutes: 170,
      ));
    }
    entries.assignAll(mock..sort((a, b) => b.date.compareTo(a.date)));
    _recalc();
    isLoading.value = false;
  }

  // ----- Filtering -----

  /// Returns active [start,end] range based on preset/custom.
  (DateTime start, DateTime end) _activeRange() {
    final now = DateTime.now();
    DateTime start, end;

    switch (selectedPreset.value) {
      case FilterPreset.today:
        start = DateTime(now.year, now.month, now.day);
        end = start.add(const Duration(days: 1));
        break;
      case FilterPreset.yesterday:
        end = DateTime(now.year, now.month, now.day);
        start = end.subtract(const Duration(days: 1));
        break;
      case FilterPreset.lastWeek:
        end = DateTime(now.year, now.month, now.day);
        start = end.subtract(const Duration(days: 7));
        break;
      case FilterPreset.lastMonth:
        end = DateTime(now.year, now.month, 1);
        start = DateTime(end.year, end.month - 1, 1);
        break;
      case FilterPreset.lastYear:
        start = DateTime(now.year - 1, 1, 1);
        end = DateTime(now.year, 1, 1);
        break;
      case FilterPreset.custom:
        // Fallback to last 30 days if custom incomplete.
        final s = customStart.value;
        final e = customEnd.value;
        if (s != null && e != null && !e.isBefore(s)) {
          start = DateTime(s.year, s.month, s.day);
          end = DateTime(e.year, e.month, e.day).add(const Duration(days: 1));
        } else {
          end = DateTime(now.year, now.month, now.day);
          start = end.subtract(const Duration(days: 30));
        }
        break;
    }
    return (start, end);
  }

  List<EarningEntry> _filtered() {
    final (start, end) = _activeRange();
    return entries
        .where((e) => !e.date.isBefore(start) && e.date.isBefore(end))
        .toList();
  }

  void applyPreset(FilterPreset p) {
    selectedPreset.value = p;
    if (p != FilterPreset.custom) {
      customStart.value = null;
      customEnd.value = null;
    }
    _recalc();
  }

  void applyCustom(DateTime? start, DateTime? end) {
    selectedPreset.value = FilterPreset.custom;
    customStart.value = start;
    customEnd.value = end;
    _recalc();
  }

  void _recalc() {
    final data = _filtered();
    totalTrips.value = data.length;
    totalDrivingMinutes.value = data.fold(0, (p, e) => p + e.drivingMinutes);
    totalEarning.value = data.fold(0.0, (p, e) => p + e.amount);
  }

  // ----- Labels -----

  String presetLabel(FilterPreset p) {
    switch (p) {
      case FilterPreset.today:
        return 'filter_today'.tr;
      case FilterPreset.yesterday:
        return 'filter_yesterday'.tr;
      case FilterPreset.lastWeek:
        return 'filter_last_week'.tr;
      case FilterPreset.lastMonth:
        return 'filter_last_month'.tr;
      case FilterPreset.lastYear:
        return 'filter_last_year'.tr;
      case FilterPreset.custom:
        final s = customStart.value, e = customEnd.value;
        if (s == null || e == null) return 'filter_custom'.tr;
        final df = DateFormat('dd MMM', _locale);
        return '${df.format(s)} – ${df.format(e)}';
    }
  }

  Map<String, List<EarningEntry>> groupedByMonth() {
    final data = _filtered()..sort((a, b) => b.date.compareTo(a.date));
    final Map<String, List<EarningEntry>> groups = {};
    for (final e in data) {
      final key = monthHeaderFmt.format(e.date).toUpperCase();
      groups.putIfAbsent(key, () => []).add(e);
    }
    return groups;
  }
}
