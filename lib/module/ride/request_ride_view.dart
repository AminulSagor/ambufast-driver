// lib/ride/request_ride_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'request_ride_controller.dart';

const _border = Color(0xFFE6E6E9);
const _label  = Color(0xFF7A7F89);
const _text   = Color(0xFF1E2430);
const _chipBg = Color(0xFFF0EFF3);

class RequestRideView extends GetView<RequestRideController> {
  const RequestRideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('request_ride_title'.tr), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const _TopChips(),
              18.h.verticalSpace,
              const _AddressBlock(), // ⬅️ card + floating plus
              12.h.verticalSpace,
              const _RoundTripCheckbox(),
              12.h.verticalSpace,

              ..._PopularPlacesList(), // ⬅️ now localized
              8.h.verticalSpace,

              _ActionRow(
                iconPath: 'assets/ride_icons/set_location.png',
                title: 'set_location_on_map'.tr,
                onTap: () => controller.pickOnMap(true),
              ),
              _ActionRow(
                iconPath: 'assets/ride_icons/star_icon.png',
                title: 'saved_address'.tr,
                onTap: controller.openSavedAddresses,
              ),
              16.h.verticalSpace,

              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset('assets/slider_image.png', fit: BoxFit.cover),
              ),
              24.h.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

/// Chips row with icons
class _TopChips extends GetView<RequestRideController> {
  const _TopChips();

  @override
  Widget build(BuildContext context) {
    Widget chip({required RxString label, required IconData icon}) => Obx(
          () => InputChip(
        // put leading icon inside label to control spacing precisely
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.sp, color: _text),
            SizedBox(width: 4.w), // tiny gap between icon and text
            Flexible(
              child: Text(
                label.value.length <= 10
                    ? label.value
                    : '${label.value.substring(0, 10)}...', // 👈 truncate after 10 chars
                style: TextStyle(fontSize: 12.sp),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis, // still safe if the chip is narrower
              ),

            ),
            SizedBox(width: 2.w), // tiny gap before chevron
            Icon(Icons.expand_more, size: 14.sp, color: _text),
          ],
        ),
            // inside _TopChips -> chip(...)
            onPressed: () {
              if (icon == Icons.schedule_outlined) {
                _showWhenSheet(context, controller);
              } else if (icon == Icons.person_outline) {
                _showContactSheet(context, controller);
              } else {
                _showServiceSheet(context, controller);
              }
            },

            backgroundColor: _chipBg,

        // ultra-tight chip spacing
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        labelPadding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(horizontal: 4, vertical: 0),
        shape: const StadiumBorder(),
      ),
    );


    final row = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        chip(label: controller.whenLabel, icon: Icons.schedule_outlined),
        SizedBox(width: 8.w), // control the gap explicitly
        chip(label: controller.whoLabel,  icon: Icons.person_outline),
        SizedBox(width: 8.w),
        chip(label: controller.typeLabel, icon: Icons.swap_horiz_outlined),
      ],
    );

    // if there’s a chance of overflow on small screens, keep it scrollable
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: row,
    );
  }
}

// ---------- Shared UI primitives ----------
Widget _sheetHandle() => Center(
  child: Container(
    width: 42.w,
    height: 4.h,
    margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
    decoration: BoxDecoration(
      color: const Color(0xFFE6E6E9),
      borderRadius: BorderRadius.circular(100.r),
    ),
  ),
);

Future<T?> _showSheet<T>({
  required BuildContext context,
  required String title,
  required Widget child,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: false,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (_) => SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w, right: 16.w, bottom: 16.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sheetHandle(),
            SizedBox(height: 4.h),
            Text(title,
              style: TextStyle(
                  fontSize: 18.sp, fontWeight: FontWeight.w700, color: _text),
            ),
            SizedBox(height: 12.h),
            Divider(height: 1.h, color: _border),
            SizedBox(height: 4.h),

            // body
            child,

            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935), // red button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('done'.tr,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _radioRow({
  required Widget leading,
  required String title,
  String? subtitle,
  required bool selected,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          SizedBox(width: 28.w, child: Center(child: leading)),
          10.w.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: TextStyle(
                      fontSize: 15.sp, fontWeight: FontWeight.w700, color: _text),
                ),
                if (subtitle != null) ...[
                  2.h.verticalSpace,
                  Text(subtitle,
                      style: TextStyle(fontSize: 12.sp, color: _label)),
                ]
              ],
            ),
          ),
          // trailing radio (outlined when false, filled when true)
          Container(
            width: 20.w, height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _label, width: 1.6),
            ),
            alignment: Alignment.center,
            child: selected
                ? Container(
              width: 10.w, height: 10.w,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    ),
  );
}
// ---------- WHEN sheet ----------
void _showWhenSheet(BuildContext context, RequestRideController c) {
  final nowTitle   = 'when_now_title'.tr;
  final nowSub     = 'when_now_sub'.tr;
  final laterTitle = 'when_later_title'.tr;
  final laterSub   = 'when_later_sub'.tr;

  String current = c.whenLabel.value;

  _showSheet(
    context: context,
    title: 'when_sheet_title'.tr,
    child: Column(
      children: [
        _radioRow(
          leading: const Icon(Icons.schedule, color: _text),
          title: nowTitle, subtitle: nowSub,
          selected: current == nowTitle,
          onTap: () { c.whenLabel.value = nowTitle; Navigator.pop(context); },
        ),
        Divider(height: 1.h, color: _border),
        _radioRow(
          leading: const Icon(Icons.calendar_month, color: _text),
          title: laterTitle, subtitle: laterSub,
          selected: current == laterTitle,
          onTap: () { c.whenLabel.value = laterTitle; Navigator.pop(context); },
        ),
      ],
    ),
  );
}

void _showContactSheet(BuildContext context, RequestRideController c) {
  final meTitle  = 'contact_me_title'.tr;
  final addTitle = 'contact_add_title'.tr;

  String current = c.whoLabel.value;

  _showSheet(
    context: context,
    title: 'contact_sheet_title'.tr,
    child: Column(
      children: [
        _radioRow(
          leading: const Icon(Icons.person, color: _text),
          title: meTitle,
          selected: current == meTitle,
          onTap: () { c.whoLabel.value = meTitle; Navigator.pop(context); },
        ),
        Divider(height: 1.h, color: _border),
        _radioRow(
          leading: const Icon(Icons.add, color: _text),
          title: addTitle,
          selected: current == addTitle,
          onTap: () {
            c.whoLabel.value = addTitle;
            // TODO: open create-contact flow if needed
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

void _showServiceSheet(BuildContext context, RequestRideController c) {
  final items = <Map<String, String>>[
    {'t': 'service_non_ac'.tr, 's': 'service_row_sub'.tr},
    {'t': 'service_ac'.tr,     's': 'service_row_sub'.tr},
    {'t': 'service_icu'.tr,    's': 'service_row_sub'.tr},
    {'t': 'service_freezing'.tr, 's': 'service_row_sub'.tr},
  ];

  String current = c.typeLabel.value;

  _showSheet(
    context: context,
    title: 'service_sheet_title'.tr,
    child: Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _radioRow(
            leading: Image.asset(
              'assets/icon/home_page_icon/ambulance_icon.png', // adjust to your asset
              width: 20.w, height: 20.w, fit: BoxFit.contain,
            ),
            title: items[i]['t']!,
            subtitle: items[i]['s']!,
            selected: current == items[i]['t']!,
            onTap: () { c.typeLabel.value = items[i]['t']!; Navigator.pop(context); },
          ),
          if (i != items.length - 1) Divider(height: 1.h, color: _border),
        ],
      ],
    ),
  );
}



/// Stack: address card + round plus button on the right
// ===================== Address Block (matches mock) =====================

class _AddressBlock extends StatelessWidget {
  const _AddressBlock();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: Stack(
        children: [
          const Positioned.fill(child: _AddressCard()),
          Positioned(
            right: 0,
            top: 16.h,
            child: RawMaterialButton(
              onPressed: () {}, // TODO: add extra stop
              elevation: 0,
              shape: const CircleBorder(),
              fillColor: const Color(0xFFEDEDEF),
              constraints: BoxConstraints.tight(Size(44.w, 44.w)),
              child: Icon(Icons.add, size: 22.sp, color: _text),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends GetView<RequestRideController> {
  const _AddressCard();

  @override
  Widget build(BuildContext context) {
    final r = 12.r;
    return Container(
      margin: EdgeInsets.only(right: 56.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        // outer (darker) outline + soft shadow like the mock
        color: Colors.transparent,
        boxShadow: [
          // Outer grey ring
          BoxShadow(
            color: const Color(0xFFA1A1AA),
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 4,
          ),
          // Inner white ring
          BoxShadow(
            color: Colors.white,
            offset: Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Outer border
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF7F8F8),
              borderRadius: BorderRadius.circular(r),
              border: Border.all(color: const Color(0xFFD4D5D9), width: 1.4),
            ),
          ),
          // Inner faint outline to mimic the “double border”
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(r - 2.r),
                  border: Border.all(color: const Color(0xFFE9E9EE), width: 1),
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left rail (circle -> line -> square)
                // Left rail (use asset instead of CustomPaint)
                SizedBox(
                  width: 20.w,
                  height: 76.h,
                  child: Image.asset(
                    'assets/ride_icons/pickup_drop_address.png',
                    fit: BoxFit.contain,
                  ),
                ),

                8.w.horizontalSpace,

                // Fields
                Expanded(
                  child: Column(
                    children: [
                      // Pickup row with tiny settings icon (inside)
                      Row(
                        children: [
                          Expanded(
                            child: _AddressField(
                              controller: controller.pickupCtrl,
                              hint: 'pickup_address_hint'.tr,
                            ),
                          ),
                          6.w.horizontalSpace,
                          InkResponse(
                            onTap: () {}, // TODO: settings
                            radius: 18.r,
                            child: Icon(Icons.my_location_outlined,
                                size: 16.sp, color: _label),
                          ),

                          // IconButton(
                          //   icon: const Icon(Icons.my_location_outlined),
                          //   color: _label,
                          //   onPressed: () => controller.pickOnMap(true),
                          //   tooltip: 'set_location_on_map'.tr,
                          //   constraints: const BoxConstraints(),
                          //   padding: EdgeInsets.zero,
                          //   iconSize: 20.sp,
                          // ),
                        ],
                      ),

                      Divider(height: 16.h, color: _border),

                      // Drop-off row (no gear)
                      _AddressField(
                        controller: controller.dropoffCtrl,
                        hint: 'dropoff_address_hint'.tr,
                      ),
                    ],
                  ),
                ),

                6.w.horizontalSpace,

                // Locate button (as in mock right side icon)

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressField extends StatelessWidget {
  const _AddressField({required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 14.sp, color: _text),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp, color: _label),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero, // tighter like mock
      ),
      textInputAction: TextInputAction.next,
    );
  }
}

// ===================== Painter: left rail =====================

class _AddressRailPainter extends CustomPainter {
  _AddressRailPainter({
    required this.railColor,
    required this.nodeColor,
  });

  final Color railColor;
  final Color nodeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paintRail = Paint()
      ..color = railColor
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintFill = Paint()
      ..color = nodeColor
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;

    // connector line
    final topY = 4.0;
    final botY = size.height - 4.0;
    canvas.drawLine(Offset(cx, topY + 10), Offset(cx, botY - 10), paintRail);

    // top circle
    canvas.drawCircle(Offset(cx, topY + 5), 5, paintFill);

    // bottom square
    final s = 10.0;
    final rect = Rect.fromCenter(
      center: Offset(cx, botY - 5),
      width: s,
      height: s,
    );
    canvas.drawRect(rect, paintFill);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoundTripCheckbox extends GetView<RequestRideController> {
  const _RoundTripCheckbox();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 22.w, height: 22.w,
          child: Checkbox(
            value: controller.needRoundTrip.value,
            onChanged: controller.toggleRoundTrip,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.selected)
                ? const Color(0xFF4DD14D)
                : const Color(0xFFFFFFFF)),
          ),
        ),

        8.w.horizontalSpace,

        // ↓ don't use Expanded here
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            'need_round_trip'.tr,
            style: TextStyle(fontSize: 13.sp, color: _text, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ),
        ),

        6.w.horizontalSpace, // control the gap explicitly

        Container(
          width: 20.w,
          height: 20.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.info,
            size: 18.sp,              // fits inside 20x20
            color: Color(0xFFFFA500),
          ),
        ),
      ],
    ));
  }
}


/// Use localized keys from controller.placesKeys
List<Widget> _PopularPlacesList() {
  final c = Get.find<RequestRideController>();
  return c.placesKeys.map((keys) {
    final title = keys[0].tr;
    final sub   = keys[1].tr;
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
          subtitle: Text(sub, style: TextStyle(fontSize: 12.sp, color: _label)),
          onTap: () {
            if (c.pickupCtrl.text.isEmpty) {
              c.pickupCtrl.text = title;
            } else {
              c.dropoffCtrl.text = title;
            }
          },
        ),
        Divider(height: 1.h, color: _border),
      ],
    );
  }).toList();
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.iconPath, required this.title, required this.onTap});
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Image.asset(iconPath, width: 32.w, height: 32.w),
            12.w.horizontalSpace,
            Expanded(child: Text(title, style: TextStyle(fontSize: 15.sp, color: _text))),
            // const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
