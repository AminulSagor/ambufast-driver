import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../model/booking_model.dart';


enum ActivityTab { upcoming, past, cancelled }

class ActivityController extends GetxController {


  // ---------- Location (shared app-bar usage) ----------
  final location = 'Your location is not available'.obs;

  // ---------- UI state ----------
  final tab = ActivityTab.upcoming.obs;
  final query = ''.obs;
  final selectedDate = Rxn<DateTime>();

  // pagination state
  final items = <Booking>[].obs;
  final isInitialLoading = false.obs;
  final isFetchingMore = false.obs;
  final hasMore = true.obs;
  final page = 1.obs;
  final pageSize = 10.obs;
  final totalCount = 0.obs;

  Worker? _debounceWorker;

  // ---------- Mocked "server" dataset ----------
  static final List<Booking> _seed = _generateSeed();

  static List<Booking> _generateSeed() {
    final now = DateTime.now();
    final rnd = Random(42);
    final statuses = [
      BookingStatus.upcoming,
      BookingStatus.completed,
      BookingStatus.cancelled,
      BookingStatus.scheduled,
    ];
    final data = <Booking>[];

    for (int i = 0; i < 120; i++) {
      final when = now
          .subtract(Duration(days: rnd.nextInt(15)))
          .add(Duration(days: rnd.nextInt(15), hours: rnd.nextInt(24)));
      data.add(Booking(
        id: (i + 1).toString(),
        time: when,
        from: 'Gulshan 1, Dhaka, Bangladesh',
        to: 'Urgent care clinic (101 Elm ST)',
        fare: 580.0,
        status: statuses[rnd.nextInt(statuses.length)],
      ));
    }

    // deterministic “today/tomorrow/yesterday”
    data.insertAll(0, [
      Booking(
        id: 'A1',
        time: DateTime(now.year, now.month, now.day, 22),
        from: 'Gulshan 1, Dhaka, Bangladesh',
        to: 'Urgent care clinic (101 Elm ST)',
        fare: 580.0,
        status: BookingStatus.upcoming,
      ),
      Booking(
        id: 'A2',
        time: DateTime(now.year, now.month, now.day + 1, 22),
        from: 'Gulshan 1, Dhaka, Bangladesh',
        to: 'Urgent care clinic (101 Elm ST)',
        fare: 580.0,
        status: BookingStatus.upcoming,
      ),
      Booking(
        id: 'A3',
        time: DateTime(now.year, now.month, now.day - 1, 22),
        from: 'Gulshan 1, Dhaka, Bangladesh',
        to: 'Urgent care clinic (101 Elm ST)',
        fare: 580.0,
        status: BookingStatus.completed,
      ),
    ]);

    return data;
  }

  // ---------- Lifecycle ----------
  @override
  void onInit() {
    super.onInit();
    loadFirstPage();
    _debounceWorker =
        debounce(query, (_) => loadFirstPage(), time: const Duration(milliseconds: 350));
  }

  @override
  void onClose() {
    _debounceWorker?.dispose();
    super.onClose();
  }




  // ---------- Public actions ----------
  void onSearch(String v) => query.value = v;

  void changeTab(ActivityTab t) {
    if (tab.value == t) return;
    tab.value = t;
    loadFirstPage();
  }

  void pickDate(DateTime? d) {
    selectedDate.value = d;
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    isInitialLoading.value = true;
    page.value = 1;
    items.clear();

    final res = await _mockFetch(
      page: page.value,
      pageSize: pageSize.value,
      tab: tab.value,
      query: query.value,
      date: selectedDate.value,
    );

    items.assignAll(res.items);
    totalCount.value = res.total;
    hasMore.value = res.hasMore;
    isInitialLoading.value = false;
  }

  Future<void> loadMore() async {
    if (isFetchingMore.value || !hasMore.value) return;
    isFetchingMore.value = true;

    final next = page.value + 1;
    final res = await _mockFetch(
      page: next,
      pageSize: pageSize.value,
      tab: tab.value,
      query: query.value,
      date: selectedDate.value,
    );

    items.addAll(res.items);
    page.value = next;
    totalCount.value = res.total;
    hasMore.value = res.hasMore;
    isFetchingMore.value = false;
  }

  // ---------- Helpers ----------
  String humanTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dt.year, dt.month, dt.day);
    if (target == today) return '${'tk_today'.tr}, ${DateFormat('hh:mm a').format(dt)}';
    if (target == today.add(const Duration(days: 1))) {
      return '${'tk_tomorrow'.tr}, ${DateFormat('hh:mm a').format(dt)}';
    }
    if (target == today.subtract(const Duration(days: 1))) {
      return '${'tk_yesterday'.tr}, ${DateFormat('hh:mm a').format(dt)}';
    }
    return DateFormat('dd MMM, hh:mm a').format(dt);
  }

  BookingStatus? _statusFor(ActivityTab t) {
    switch (t) {
      case ActivityTab.upcoming:
        return BookingStatus.upcoming; // include scheduled too
      case ActivityTab.past:
        return BookingStatus.completed;
      case ActivityTab.cancelled:
        return BookingStatus.cancelled;
    }
  }

  // ---------- Mock “API” ----------
  Future<_PageSlice<Booking>> _mockFetch({
    required int page,
    required int pageSize,
    required ActivityTab tab,
    String? query,
    DateTime? date,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network

    final status = _statusFor(tab);
    Iterable<Booking> src = _seed;

    // status: upcoming tab also shows scheduled
    if (status != null) {
      if (status == BookingStatus.upcoming) {
        src = src.where((b) =>
        b.status == BookingStatus.upcoming || b.status == BookingStatus.scheduled);
      } else {
        src = src.where((b) => b.status == status);
      }
    }

    // date filter (Y/M/D)
    if (date != null) {
      src = src.where((b) =>
      b.time.year == date.year && b.time.month == date.month && b.time.day == date.day);
    }

    // search (id/from/to)
    final q = (query ?? '').trim().toLowerCase();
    if (q.isNotEmpty) {
      src = src.where((b) =>
      b.id.toLowerCase().contains(q) ||
          b.from.toLowerCase().contains(q) ||
          b.to.toLowerCase().contains(q));
    }

    final filtered = src.toList()..sort((a, b) => b.time.compareTo(a.time));
    final total = filtered.length;

    final start = (page - 1) * pageSize;
    final end = min(start + pageSize, total);
    final slice = (start < end) ? filtered.sublist(start, end) : <Booking>[];

    final hasMore = end < total;
    return _PageSlice(items: slice, total: total, hasMore: hasMore);
  }
}

class _PageSlice<T> {
  final List<T> items;
  final int total;
  final bool hasMore;
  const _PageSlice({required this.items, required this.total, required this.hasMore});
}
