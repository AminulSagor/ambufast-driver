import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../routes/app_routes.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    print("🔄 LoginView build() called");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(
                left: 20.w, right: 20.w, top: 12.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Obx(() {
                    final isRegister = controller.intent.value == LoginIntent.register;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back
                        InkWell(
                          onTap: controller.goBack,
                          borderRadius: BorderRadius.circular(8.r),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back, size: 20.sp, color: Colors.black87),
                              SizedBox(width: 6.w),
                              Text('back'.tr,
                                  style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Logo
                        Center(
                          child: Image.asset("assets/logo_with_color.png", height: 70.h),
                        ),

                        SizedBox(height: 20.h),

                        // Title & subtitle (switch by mode)
                        Center(
                          child: Column(
                            children: [
                              Text(
                                isRegister ? 'create_account_title'.tr : 'login_title'.tr,
                                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                isRegister ? 'signup_subtitle'.tr : 'login_subtitle'.tr,
                                style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Tabs (phone/email)
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.changeTab(0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: controller.tabIndex.value == 0
                                        ? const Color(0xFF2E3239)
                                        : const Color(0xFFEDEDEE),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'tab_phone'.tr,
                                    style: TextStyle(
                                      color: controller.tabIndex.value == 0
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.changeTab(1),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: controller.tabIndex.value == 1
                                        ? const Color(0xFF2E3239)
                                        : const Color(0xFFEDEDEE),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'tab_email'.tr,
                                    style: TextStyle(
                                      color: controller.tabIndex.value == 1
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Phone / Email inputs (unchanged)
                        Obx(() {
                          if (controller.tabIndex.value == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('label_phone'.tr),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Container(
                                      height: 52.h,
                                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset("assets/icon/bangladesh_flag.png", width: 20.w),
                                          SizedBox(width: 6.w),
                                          Text('country_code_bd'.tr),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: TextField(
                                        controller: controller.phoneController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          hintText: 'hint_phone'.tr,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('label_email'.tr),
                                SizedBox(height: 8.h),
                                TextField(
                                  controller: controller.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'hint_email'.tr,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        }),

                        SizedBox(height: 20.h),

                        // Password (only for login mode)
                        if (!isRegister) ...[
                          Text('label_password'.tr),
                          SizedBox(height: 8.h),
                          Obx(() {

                            return TextField(
                              controller: controller.passwordController,
                              obscureText: controller.obscurePassword.value,
                              decoration: InputDecoration(
                                hintText: 'hint_password'.tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(controller.obscurePassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: controller.togglePasswordVisibility,
                                ),
                              ),
                            );
                          }),
                          SizedBox(height: 10.h),

                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: controller.goToRecover,
                              child: Text('recover_password'.tr,
                                  style: TextStyle(color: Colors.red, fontSize: 13.sp)),
                            ),
                          ),

                          SizedBox(height: 20.h),
                        ],

                        // Primary button: Login or Send OTP
                        // In your LoginView where the primary button is built:
                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: Obx(() {
                            final isRegister = controller.intent.value == LoginIntent.register;
                            final loading = controller.isSubmitting.value;

                            return ElevatedButton(
                              onPressed: loading ? null : controller.primaryAction,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF43023),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (loading) ...[
                                    SizedBox(
                                      width: 18.w,
                                      height: 18.w,
                                      child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    ),
                                    SizedBox(width: 10.w),
                                  ],
                                  Text(
                                    isRegister ? 'send_otp'.tr : 'login_btn'.tr,
                                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                  if (!loading) ...[
                                    SizedBox(width: 8.w),
                                    Image.asset("assets/icon/arrow.png", width: 20.w, height: 20.w),
                                  ],
                                ],
                              ),
                            );
                          }),
                        ),

                        SizedBox(height: 16.h),

                        // Bottom prompt: switch modes locally
                        Center(
                          child: GestureDetector(
                            onTap: () => isRegister
                                ? controller.goToLogin()
                                : controller.goToRegister(),
                            child: RichText(
                              text: TextSpan(
                                text: isRegister
                                    ? '${'have_account_q'.tr} '
                                    : '${'no_account'.tr} ',
                                style: TextStyle(color: Colors.black54, fontSize: 13.sp),
                                children: [
                                  TextSpan(
                                    text: isRegister ? 'login'.tr : 'create'.tr,
                                    style: const TextStyle(
                                        color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(bottom: 30.h),
                          child: Center(
                            child: Text(
                              'powered'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


}