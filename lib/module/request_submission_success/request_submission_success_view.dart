import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'request_submission_success_controller.dart';

const kBrandRed = Color(0xFFE53935);
const kTextDark = Color(0xFF1E2430);

class RequestSubmissionSuccessView extends GetView<RequestSubmissionSuccessController> {
  const RequestSubmissionSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              28.h.verticalSpace,

              // ✅ Success mark
              Image.asset(
                'assets/icon/done_mark.png',
                width: 120.w,
                height: 120.w,
              ),

              20.h.verticalSpace,

              // ✅ Title
              Text(
                'rs_success_title'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: kTextDark,
                ),
              ),

              10.h.verticalSpace,

              // ✅ Body
              Text(
                'rs_success_body'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),

              16.h.verticalSpace,

              // ✅ ETA row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time, size: 18.w, color: Colors.black45),
                  6.w.horizontalSpace,
                  Text(
                    'rs_estimated_label'.tr,
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                  ),
                ],
              ),

              24.h.verticalSpace,

              // ✅ CTA buttons
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: controller.goToActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBrandRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'rs_go_to_activity'.tr,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              12.h.verticalSpace,

              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: OutlinedButton(
                  onPressed: controller.backHome,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: const Color(0xFFE6E6E9)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'rs_back_home'.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: kTextDark,
                    ),
                  ),
                ),
              ),

              16.h.verticalSpace,

              // ✅ Bottom banner
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  'assets/support_page_image.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // push content up but allow banner to be visible on short screens
              12.h.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
