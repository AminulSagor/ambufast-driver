import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import 'help_center_controller.dart';

class HelpCenterView extends GetView<HelpCenterController> {
  const HelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('help_center_title'.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading text (you asked for this)
            Center(
              child: Text(
                'faq_heading'.tr, // "Current Frequently Asked Questions"
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 12.h),

            // Search (now actually filters the list)
            TextField(
              onChanged: (v) => controller.query.value = v,
              decoration: InputDecoration(
                hintText: 'faq_search_hint'.tr, // "Search FAQs"
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF3F5F8),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // FAQs list
            Expanded(
              child: Obx(() {
                final items = controller.filteredFaqs;
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, i) {
                    final q = items[i];
                    final id = q['id']!;
                    final isOpen = controller.expanded.contains(id);

                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      elevation: 0,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () => controller.toggle(id),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: const Color(0xFFE6E8EC)),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 12.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row with question + +/- icon
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      q['question'] ?? '',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Icon(isOpen ? Icons.remove : Icons.add,
                                      size: 20.sp, color: Colors.black87),
                                ],
                              ),
                              // answer
                              AnimatedCrossFade(
                                firstChild: const SizedBox.shrink(),
                                secondChild: Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.h, right: 4.w, bottom: 2.h),
                                  child: Text(
                                    q['answer'] ?? '',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black87,
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                                crossFadeState: isOpen
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 180),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            SizedBox(height: 10.h),

            // Can't find + CTA
            Center(
              child: Text(
                'faq_cant_find'.tr,
                style: TextStyle(fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.contactSupport);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'faq_contact_support'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
