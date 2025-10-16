import 'dart:math' as math;

import 'package:ambufast_driver/utils/bottom_sheet_helper.dart';
import 'package:ambufast_driver/widgets/custom_back_navigaiton.dart';
import 'package:ambufast_driver/widgets/user_details_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_button.dart';
import 'trip_track_controller.dart';
import 'widgets/slide_to_action_button.dart';

class TripTrackView extends GetView<TripTrackController> {
  const TripTrackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 8.h),
                Text('loading'.tr),
              ],
            ),
          );
        }

        return Stack(children: [
          // Map placeholder
          Positioned.fill(
            child: Container(
              color: Colors.grey[200], // Placeholder for the map widget
              child: Center(
                child: Image.asset(
                  'assets/map_image.png', // Replace with a real map widget (e.g., google_maps_flutter)
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          Positioned(
            top: 125.5.h,
            right: 66.w,
            child: Image.asset(
              'assets/trip/direction_line.png',
              fit: BoxFit.cover,
              width: 245.w,
              height: 242.5.h,
            ),
          ),
          Positioned(
            top: 110.5.h,
            right: 66.w,
            child: Transform.rotate(
              angle: -90 * (math.pi / 180),
              child: Image.asset(
                'assets/trip/start_pin.png',
                fit: BoxFit.cover,
                width: 27.w,
              ),
            ),
          ),
          Positioned(
            top: 354.h,
            right: 293.w,
            child: Image.asset(
              'assets/trip/available_vehicle_icon.png',
              fit: BoxFit.cover,
              width: 28.w,
            ),
          ),

          // --- Persistent, non-dismissible bottom sheet ---
          // DraggableScrollableSheet never dismisses; it expands/collapses only.
          _buildBottomSheet(),

          Positioned(
            left: 16.w,
            top: 220.h,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
              elevation: 0,
              backgroundColor: primaryBase,
              foregroundColor: Colors.white,
              onPressed: controller.openEmergencySheet,
              child: const Icon(Icons.warning),
            ),
          ),

          // Close
          Positioned(
            top: 60.h,
            left: 16.w,
            child: CustomBackNavigaiton(
              onTap: () => Get.back(),
            ),
          ),
        ]);
      }),
    );
  }

  // void justBack() {
  //   // Bottom sheet shell
  //   Align(
  //     alignment: Alignment.bottomCenter,
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
  //         boxShadow: const [
  //           BoxShadow(
  //               color: Color(0x22000000), blurRadius: 16, offset: Offset(0, -4))
  //         ],
  //       ),
  //       child: SafeArea(
  //         top: false,
  //         child: Padding(
  //           padding: EdgeInsets.only(bottom: 14.h),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // drag handle
  //               Padding(
  //                 padding: EdgeInsets.only(top: 8.h, bottom: 6.h),
  //                 child: Container(
  //                   width: 60.w,
  //                   height: 5.h,
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xFFE5E7EB),
  //                     borderRadius: BorderRadius.circular(3.r),
  //                   ),
  //                 ),
  //               ),

  //               // Header with countdown
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 16.w),
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text('Driver is arriving',
  //                               style: TextStyle(
  //                                   fontSize: 16.sp,
  //                                   fontWeight: FontWeight.w800)),
  //                           SizedBox(height: 2.h),
  //                           Text('Meet you driver at the pickup spot',
  //                               style: TextStyle(
  //                                   fontSize: 12.sp,
  //                                   color: const Color(0xFF6B7280))),
  //                         ],
  //                       ),
  //                     ),
  //                     Obx(() => Container(
  //                           padding: EdgeInsets.symmetric(
  //                               horizontal: 12.w, vertical: 6.h),
  //                           decoration: BoxDecoration(
  //                             color: const Color(0xFFFFE9EC),
  //                             borderRadius: BorderRadius.circular(12.r),
  //                           ),
  //                           child: Row(
  //                             children: [
  //                               Text(controller.countdownMin.value.toString(),
  //                                   style: TextStyle(
  //                                       fontSize: 16.sp,
  //                                       fontWeight: FontWeight.w800,
  //                                       color: const Color(0xFFE11D48))),
  //                               SizedBox(width: 4.w),
  //                               Text('Min',
  //                                   style: TextStyle(
  //                                       fontSize: 12.sp,
  //                                       color: const Color(0xFFE11D48))),
  //                             ],
  //                           ),
  //                         )),
  //                   ],
  //                 ),
  //               ),

  //               SizedBox(height: 10.h),

  //               // Driver card
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 16.w),
  //                 child: Container(
  //                   padding: EdgeInsets.all(10.w),
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xFFF8FAFC),
  //                     borderRadius: BorderRadius.circular(12.r),
  //                     border: Border.all(color: const Color(0xFFE5E7EB)),
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       CircleAvatar(
  //                         radius: 22.r,
  //                         backgroundImage:
  //                             const AssetImage('assets/avatar_placeholder.png'),
  //                       ),
  //                       SizedBox(width: 10.w),
  //                       Expanded(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text('Md Kamrul Hasan',
  //                                 style: TextStyle(
  //                                     fontSize: 14.sp,
  //                                     fontWeight: FontWeight.w700)),
  //                             Row(
  //                               children: const [
  //                                 Icon(Icons.star_rounded,
  //                                     size: 18, color: Color(0xFFF59E0B)),
  //                                 SizedBox(width: 4),
  //                                 Text('5.0 (1.2 ratings)',
  //                                     style: TextStyle(
  //                                         fontSize: 12,
  //                                         color: Color(0xFF6B7280))),
  //                               ],
  //                             ),
  //                             Text('Toyota | Dhaka Metro 12 5896',
  //                                 style: TextStyle(
  //                                     fontSize: 12.sp,
  //                                     color: const Color(0xFF6B7280))),
  //                           ],
  //                         ),
  //                       ),
  //                       SizedBox(width: 8.w),
  //                       InkWell(
  //                         onTap: controller.onCall,
  //                         child: Container(
  //                           width: 40.w,
  //                           height: 40.w,
  //                           decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             borderRadius: BorderRadius.circular(10.r),
  //                             border:
  //                                 Border.all(color: const Color(0xFFE5E7EB)),
  //                           ),
  //                           child: const Icon(Icons.call_outlined,
  //                               color: Color(0xFF10B981)),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),

  //               SizedBox(height: 12.h),

  //               // Addresses (radio)
  //               _addressTile(
  //                 title: 'Pick-up address',
  //                 subtitle: controller.request.from,
  //                 value: AddressSelect.pickup,
  //               ),
  //               _addressTile(
  //                 title: 'Drop-off address',
  //                 subtitle: controller.request.to,
  //                 value: AddressSelect.dropoff,
  //               ),

  //               // See trip details
  //               TextButton(
  //                 onPressed: controller.onSeeDetails,
  //                 child: Text('See Trip Details',
  //                     style: TextStyle(
  //                         fontSize: 13.sp,
  //                         color: const Color(0xFF64748B),
  //                         fontWeight: FontWeight.w600)),
  //               ),

  //               // Due row
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 16.w),
  //                 child: Row(
  //                   children: [
  //                     Row(
  //                       children: const [
  //                         Icon(Icons.info_outline_rounded,
  //                             size: 18, color: Color(0xFF64748B)),
  //                         SizedBox(width: 6),
  //                         Text('Due',
  //                             style: TextStyle(color: Color(0xFF374151))),
  //                       ],
  //                     ),
  //                     const Spacer(),
  //                     Obx(() => Text(controller.money(controller.due.value),
  //                         style: TextStyle(
  //                             fontSize: 14.sp, fontWeight: FontWeight.w700))),
  //                   ],
  //                 ),
  //               ),

  //               SizedBox(height: 12.h),

  //               // Slide to start
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 16.w),
  //                 child: SlideToStartButton(
  //                   text: 'Start the trip',
  //                   onCompleted: controller.onSlideCompleted,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBottomSheet() {
    final s = controller.state.value!;
    final isStart = controller.stage.value == TripStage.start;
    final isApproaching = controller.stage.value == TripStage.approaching;
    final isArrived = controller.stage.value == TripStage.arrived;
    final isInProgress = controller.stage.value == TripStage.inProgress;
    final isCompleted = controller.stage.value == TripStage.completed;

    print(controller.stage.value);

    return DraggableScrollableSheet(
      initialChildSize: isStart || isApproaching ? 0.65 : 0.6,
      minChildSize: 0.1,
      maxChildSize: isStart || isApproaching ? 0.65 : 0.6,
      snap: true,
      expand: true,
      builder: (context, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: ListView(
            controller: scrollCtrl,
            padding: EdgeInsets.zero,
            children: [
              8.h.verticalSpace,
              // drag handle
              dragHandle(),

              // >>> Header with smooth stage transitions <<<
              const _HeaderAnimated(), // <-- NEW

              12.h.verticalSpace,
              divider(),

              // driver card
              Container(
                color: neutral50,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: UserDetailsCard(
                  userInfo: s.user,
                  showCallBtn: true,
                  onCall: controller.onCallUser,
                ),
              ),

              // pickup address (selected)
              Obx(() {
                return _addressTile(
                  title: 'pickup_address'.tr,
                  address: s.pickupAddress,
                  selected: controller.active.value == ActiveAddress.pickup,
                  selectedColor: negative50,
                  trailing: (isArrived || isInProgress || isCompleted)
                      ? const Icon(
                          Icons.check_box_rounded,
                          color: posititveBase,
                        )
                      : null,
                );
              }),

              // drop address
              Obx(() {
                return _addressTile(
                  title: 'dropoff_address'.tr,
                  address: s.dropAddress,
                  selected: controller.active.value == ActiveAddress.drop,
                  selectedColor: negative50,
                  trailing: isCompleted
                      ? const Icon(
                          Icons.check_box_rounded,
                          color: Color(0xFF22C55E),
                        )
                      : (isInProgress
                          ? const Icon(
                              Icons.radio_button_checked,
                              color: Color(0xFFE11D48),
                            )
                          : null),
                );
              }),

              SizedBox(height: 8.h),

              Container(
                color: adminBg,
                padding: EdgeInsets.all(16.sp),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      // See trip details
                      if (isStart || isApproaching) ...[
                        GestureDetector(
                          onTap: controller.onSeeDetails,
                          child: Text(
                            'See Trip Details',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: neutral700,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        8.h.verticalSpace,
                      ],
                      // Due row
                      Row(
                        children: [
                          Text(
                            'due'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: neutral700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          const Icon(Icons.info, size: 16, color: neutral700),
                          const Spacer(),
                          Text(
                            controller.formatCurrency(
                              s.dueAmount,
                              symbol: 'BDT ',
                            ),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: neutral700,
                            ),
                          ),
                        ],
                      ),
                      24.h.verticalSpace,

                      // actions
                      if (isStart || isArrived)
                        SlideToActionButton(
                          text: 'start_trip'.tr,
                          onCompleted: controller.onTripStart,
                        ),

                      if (isApproaching)
                        CustomButton(
                          btnTxt: 'waiting_for_passenger',
                          onTap: controller.onWaiting,
                        ),

                      if (isInProgress)
                        SlideToActionButton(
                          text: 'end_trip'.tr,
                          onCompleted: controller.onTripEnd,
                        ),

                      if (isCompleted)
                        CustomButton(
                          btnTxt: 'collect_cash'.tr,
                          onTap: controller.onCollectCash,
                        ),

                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _addressTile({
    required String title,
    required String address,
    required bool selected,
    required Color selectedColor,
    Widget? trailing, // NEW
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(color: selected ? selectedColor : Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: blackFrontS,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: neutral700,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          trailing ??
              Radio<bool>(
                value: true,
                groupValue: selected,
                onChanged: (_) {},
                activeColor: negativeBase,
              ),
        ],
      ),
    );
  }
}

// ---------------- Header section (isolated & animated) ----------------

class _HeaderAnimated extends GetView<TripTrackController> {
  const _HeaderAnimated();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TripTrackController>();
    // final isCompleted = controller.stage.value == TripStage.completed;

    return GetBuilder<TripTrackController>(
      id: 'header', // only this small part rebuilds on stage change
      builder: (_) {
        final isStart = controller.stage.value == TripStage.start;
        final isApproaching = controller.stage.value == TripStage.approaching;
        final isArrived = controller.stage.value == TripStage.arrived;
        final isInProgress = controller.stage.value == TripStage.inProgress;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SizeTransition(sizeFactor: anim, child: child),
            // child: child,
          ),
          child: () {
            final locale = Get.locale?.toLanguageTag() ?? 'en_US';
            // final timeFmt = DateFormat('hh:mm a', locale);

            if (isStart || isApproaching) {
              return _HeaderApproaching(
                key: const ValueKey('approaching'),
                etaBadge: Obx(
                  () => _EtaBadge(text: controller.remainingBadgeText),
                ),
              );
            } else if (isArrived) {
              return _HeaderOtherStages(
                key: const ValueKey('arrived'),
                title: 'driver_arrived'.tr,
                subTitle: 'reach_pickup_in_5min'.tr,
              );
            } else if (isInProgress) {
              final locale = Get.locale?.toLanguageTag() ?? 'en_US';
              final timeFmt = DateFormat('hh:mm a', locale);
              final etaStr = controller.destinationEta.value != null
                  ? timeFmt.format(controller.destinationEta.value!)
                  : '--:--';
              return _HeaderOtherStages(
                key: const ValueKey('inprogress'),
                title: 'ride_in_progress'.tr,
                subTitle: 'reach_destination_by'.trParams({'time': etaStr}),
                titleColor: posititve700,
              );
            } else {
              // COMPLETED
              return _HeaderOtherStages(
                key: const ValueKey('completed'),
                title: 'ride_complete'.tr,
                subTitle: 'reached_destination'.tr,
                titleColor: posititveBase,
              );
            }
          }(),
        );
      },
    );
  }
}

class _EtaBadge extends StatelessWidget {
  final String text;
  const _EtaBadge({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 51.w,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: primaryBase,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _HeaderApproaching extends StatelessWidget {
  final Widget etaBadge;
  const _HeaderApproaching({super.key, required this.etaBadge});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'driver_arriving'.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: blackFrontS,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'meet_driver_hint'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: neutral700,
                  ),
                ),
              ],
            ),
          ),
          etaBadge,
        ],
      ),
    );
  }
}

class _HeaderOtherStages extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color? titleColor;
  const _HeaderOtherStages({
    super.key,
    required this.title,
    required this.subTitle,
    this.titleColor,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title.tr, //'driver_arrived'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: titleColor ?? blackFrontS,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            subTitle.tr, //'reach_pickup_in_5min'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: neutral700,
            ),
          ),
        ],
      ),
    );
  }
}
