import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../model/vehicle_model.dart';
import 'my_vehicles_controller.dart';


class MyVehiclesView extends StatelessWidget {
  const MyVehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MyVehiclesController());

    const bg = Color(0xFFF6FBFD);
    const border = Color(0xFFE7EEF2);
    const text = Color(0xFF23313F);
    const muted = Color(0xFF6D7A87);
    const danger = Color(0xFFE53935);
    const success = Color(0xFF1AA053);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: text,
        centerTitle: true,
        title: Text(
          'my_vehicles_title'.tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: text),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            _SearchField(hint: 'search_vehicle'.tr, onChanged: c.onSearch),
            SizedBox(height: 8.h),

            Expanded(
              child: Obx(() {
                if (c.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = c.filtered;
                if (items.isEmpty) return _EmptyState(message: 'no_vehicle'.tr);

                return ListView.separated(
                  padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => Divider(height: 1.h, color: border),
                  itemBuilder: (_, i) => _VehicleTile(
                    v: items[i],
                    selectedId: c.selectedId.value,
                    onTap: () => _onSelectWithConfirm(c, items[i], danger, success, text),
                  ),
                );
              }),
            ),

            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                // onPressed of your "Add Vehicle" button IN THE VIEW:
                onPressed: () async {
                  final added = await Get.toNamed(
                    Routes.carDetails,
                    arguments: {'fromAddVehicle': true}, // 👈 pass the flag
                  );

                  if (added == true) {

                    //Get.find<MyVehiclesController>().fetchVehicles();
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: danger,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text('add_vehicle'.tr, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700,color: Colors.white)),
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  void _onSelectWithConfirm(
      MyVehiclesController c,
      Vehicle tapped,
      Color danger,
      Color success,
      Color text,
      ) {
    final prev = c.active;
    c.onSelect(tapped.id);

    if (prev?.id == tapped.id) return;

    Get.dialog(
      _ConfirmDialog(
        title: 'confirm_change_vehicle_title'.tr,
        bodyIntro: 'confirm_change_vehicle_body_1'.tr,
        prevText: prev?.subtitle ?? '-',
        nextText: tapped.subtitle,
        danger: danger,
        success: success,
        text: text,
        onConfirm: () {
          c.applySelection();
          Get.back();
        },
      ),
      barrierDismissible: false,
    );
  }
}

class _SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchField({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.05),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 20.sp, color: Colors.black45),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ).copyWith(hintText: hint),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleTile extends StatelessWidget {
  final Vehicle v;
  final String? selectedId;
  final VoidCallback onTap;
  const _VehicleTile({required this.v, required this.selectedId, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF23313F));
    final subStyle = TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: const Color(0xFF6D7A87));
    final isChecked = selectedId == v.id;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
          Container(
          width: 54.r,
          height: 54.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE9EEF2), width: 6.r),
          ),
            // inside _VehicleTile.build()
            child: ClipOval(
              child: (v.imageUrl != null && v.imageUrl!.isNotEmpty)
                  ? Image.network(
                v.imageUrl!, // now non-null
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.directions_car),
              )
                  : const Icon(Icons.directions_car),
            ),

          ),
          SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(v.title, style: titleStyle),
                  SizedBox(height: 2.h),
                  Text(v.subtitle, style: subStyle),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // radio
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black54, width: 2),
              ),
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: isChecked ? 10.r : 0,
                height: isChecked ? 10.r : 0,
                decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.sp, color: Colors.black54, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String bodyIntro;
  final String prevText;
  final String nextText;
  final Color danger;
  final Color success;
  final Color text;
  final VoidCallback onConfirm;

  const _ConfirmDialog({
    required this.title,
    required this.bodyIntro,
    required this.prevText,
    required this.nextText,
    required this.danger,
    required this.success,
    required this.text,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      fontSize: 14.sp,
      color: text.withOpacity(.8),
      fontWeight: FontWeight.w600,
    );

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 6.h),
            Icon(Icons.error_outline, size: 40.sp, color: danger),
            SizedBox(height: 10.h),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: text),
            ),
            SizedBox(height: 10.h),

            Text(
              bodyIntro,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: text.withOpacity(.8)),
            ),
            SizedBox(height: 4.h),

            // ---------- FROM (label on its own line, then value) ----------
            Text('from'.tr, style: labelStyle, textAlign: TextAlign.center),
            SizedBox(height: 4.h),
            Text(
              prevText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: danger,
                decoration: TextDecoration.lineThrough,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),

            // ---------- TO (label on its own line, then value) ----------
            Text('to'.tr, style: labelStyle, textAlign: TextAlign.center),
            SizedBox(height: 4.h),
            Text(
              nextText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: success,
                fontWeight: FontWeight.w800,
              ),
            ),

            SizedBox(height: 12.h),

            Text(
              'confirm_note'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: danger.withOpacity(.85)),
            ),
            SizedBox(height: 16.h),

            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: danger,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  'confirm'.tr,
                  style: TextStyle(
                    color: Colors.white, // force white
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),

            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black12, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  'go_back'.tr,
                  style: TextStyle(fontSize: 15.sp, color: Colors.black54, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

