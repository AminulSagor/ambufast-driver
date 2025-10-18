import 'package:ambufast_driver/utils/bottom_sheet_helper.dart';
import 'package:ambufast_driver/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'earnings_controller.dart';
import 'models/earning_entry.dart';
import 'widgets/earnings_filter_sheet.dart';

class EarningsView extends GetView<EarningsController> {
  const EarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'my_earning'.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: neutral700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: 16.h.verticalSpace),
              SliverToBoxAdapter(child: _HeaderCard(controller: controller)),
              SliverToBoxAdapter(child: 32.h.verticalSpace),
              ..._buildMonthGroups(context),
              SliverToBoxAdapter(child: 24.verticalSpace),
              SliverToBoxAdapter(
                child: _FooterSignature(),
              ),
              SliverToBoxAdapter(child: 12.verticalSpace),
            ],
          );
        }),
      ),
    );
  }

  List<Widget> _buildMonthGroups(BuildContext context) {
    final groups = controller.groupedByMonth();
    final List<Widget> slivers = [];

    groups.forEach((monthTitle, items) {
      slivers.addAll([
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Divider(
                    color: Color(0xFFE1E6EF),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    monthTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF607080),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                const Expanded(
                  child: Divider(
                    color: Color(0xFFE1E6EF),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList.separated(
          itemCount: items.length,
          separatorBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: divider(),
          ),
          itemBuilder: (_, i) => _EarningTile(
            entry: items[i],
            money: controller.moneyFmt,
            dateFmt: controller.rowDateFmt,
          ),
        ),
        SliverToBoxAdapter(child: 26.h.verticalSpace),
      ]);
    });

    return slivers;
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.controller});
  final EarningsController controller;

  @override
  Widget build(BuildContext context) {
    final Color chipBg = const Color(0xFF364B63);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: neutral900,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          children: [
            // Top strip with title + filter pill
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'earn_trips_title'.tr, // "Earning & Trips"
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openFilterSheet(context),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: chipBg,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: baseWhite50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() => Text(
                                controller.presetLabel(
                                    controller.selectedPreset.value),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                ),
                              )),
                          6.w.horizontalSpace,
                          const Icon(
                            Icons.unfold_more_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Two mini cards
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      return _MiniStat(
                        title: 'total_trips'.tr,
                        value: controller.totalTrips.value.toString(),
                      );
                    }),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Obx(() {
                      final mins = controller.totalDrivingMinutes.value;
                      final hrs = (mins / 60).round();
                      return _MiniStat(
                        title: 'total_hours'.tr,
                        value: '${hrs} ${'hrs'.tr}',
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Big earning area
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 22.h),
              decoration: BoxDecoration(
                color: primaryBase,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(6.r),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'total_earning'.tr,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.92),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  6.h.verticalSpace,
                  Obx(() => Text(
                        controller.moneyFmt.format(
                          controller.totalEarning.value,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 36.sp,
                          letterSpacing: -0.4,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterSheet(BuildContext context) {
    Get.bottomSheet(
      EarningsFilterSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final Color chipBg = const Color(0xFF364B63);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: chipBg,
        border: Border.all(color: baseWhite50),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
            ),
          ),
          6.verticalSpace,
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 17.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _EarningTile extends StatelessWidget {
  const _EarningTile({
    required this.entry,
    required this.money,
    required this.dateFmt,
  });

  final EarningEntry entry;
  final NumberFormat money;
  final DateFormat dateFmt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: _TileTexts(
                title: 'your_earning'.tr,
                subtitle:
                    '${'reference_id'.tr}: ${entry.referenceId}\n${dateFmt.format(entry.date)}',
              ),
            ),
            10.horizontalSpace,
            Text(
              money.format(entry.amount),
              style: TextStyle(
                color: posititveBase,
                fontWeight: FontWeight.w500,
                fontSize: 17.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TileTexts extends StatelessWidget {
  const _TileTexts({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
            color: const Color(0xFF132235),
          ),
        ),
        4.verticalSpace,
        Text(
          subtitle,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: const Color(0xFF364B63),
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _FooterSignature extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: .7,
        child: Column(
          children: [
            Text(
              'powered_by'.tr, // “Powered By …”
              style: TextStyle(fontSize: 11.sp),
            ),
            4.verticalSpace,
            Text(
              'beta_version'.tr, // “Beta Version 1.0”
              style: TextStyle(fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }
}
