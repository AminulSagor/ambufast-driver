// lib/modules/rating/rating_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'rating_controller.dart';

class RatingView extends GetView<RatingController> {
  const RatingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Yellowish accent for stars & chip checkmarks
    const amber = Color(0xFFFFB300); // amber 600-ish
    const primaryRed = Color(0xFFE24636); // keep for Done button

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('rating.title'.tr,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: Get.back),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header card (white with shadow)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10.r, offset: Offset(0, 4.h))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 38.r,
                    backgroundImage: controller.avatarUrl.isNotEmpty ? NetworkImage(controller.avatarUrl) : null,
                    child: controller.avatarUrl.isEmpty ? const Icon(Icons.person) : null,
                  ),
                  SizedBox(height: 10.h),
                  Text(controller.driverName, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(controller.driverRating.toStringAsFixed(1),
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                      SizedBox(width: 4.w),
                      const Icon(Icons.star, size: 16, color: Color(0xFFFFB300)),
                      SizedBox(width: 6.w),
                      Text('(${controller.totalRatings} ratings)', style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(controller.vehicleLine, textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(height: 4.h),
                    Text('rating.header.question'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                    SizedBox(height: 10.h),

                    // Dynamic subtitle (per-star)
                    Obx(() => Text(
                      controller.subtitleKey.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: controller.stars.value == 0 ? Colors.black54 : Colors.black87,
                      ),
                    )),
                    SizedBox(height: 16.h),

                    // Stars row (amber fill, no red)
                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        final idx = i + 1;
                        final filled = controller.stars.value >= idx;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: GestureDetector(
                            onTap: () => controller.setStars(idx),
                            child: Icon(
                              filled ? Icons.star_rounded : Icons.star_border_rounded,
                              size: 34.sp,
                              color: filled ? amber : Colors.grey.shade500,
                            ),
                          ),
                        );
                      }),
                    )),
                    SizedBox(height: 20.h),

                    // Dynamic chips (no "Others" when 0 stars). Yellow checkmark.
                    Obx(() => Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      alignment: WrapAlignment.center,
                      children: controller.visibleTags.map((k) {
                        final isSel = controller.selected.contains(k);
                        return FilterChip(
                          label: Text(k.tr, style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade900)),
                          selected: isSel,
                          onSelected: (_) => controller.toggleTag(k),
                          showCheckmark: true,
                          checkmarkColor: amber,
                          backgroundColor: const Color(0xFFF1F1F5),
                          selectedColor: amber.withOpacity(.18),
                          side: BorderSide(color: isSel ? amber : Colors.transparent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        );
                      }).toList(),
                    )),

                    SizedBox(height: 18.h),

                    // Others text area (only when "Others" selected)
                    Obx(() => controller.showOthersField
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('rating.form.tell_more'.tr,
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8.h),
                        TextField(
                          maxLines: 5,
                          onChanged: (v) => controller.note.value = v,
                          decoration: InputDecoration(
                            hintText: 'rating.form.hint'.tr,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                            contentPadding: EdgeInsets.all(12.w),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    )
                        : const SizedBox.shrink()),
                    SizedBox(height: 96.h),
                  ],
                ),
              ),
            ),

            // Sticky Done button (kept brand red)
            Obx(() => Padding(
              padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 16.h + 6.h),
              child: SizedBox(
                height: 48.h,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  onPressed: controller.submitting.value ? null : controller.submit,
                  child: controller.submitting.value
                      ? const CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white))
                      : Text('common.done'.tr,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
