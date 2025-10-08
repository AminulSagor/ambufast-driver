import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/bottom_nav_widget.dart';
import '../../widgets/logout_confirm_sheet.dart';
import 'account_controller.dart';


const Color _bgTop = Color(0xFFE63C2F);
const Color _chipGreen = Color(0xFF29C17E);
const Color _cardBg = Color(0xFFF7FAF8);
const Color _divider = Color(0xFFECECEC);


class AccountView extends GetView<AccountController> {
  const AccountView({super.key});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header()),
            SliverToBoxAdapter(child: 90.verticalSpace),
            _Section(
              title: 'basic_info'.tr,
              children: [
                _Tile('profile', 'assets/account/profile_icon.png'),
                _Tile('subscription', 'assets/account/crown_icon.png'),
                _Tile('reviews', 'assets/account/review_icon.png'),
                _Tile('my_earning', 'assets/account/earning_icon.png'),
                _Tile('my_vehicles', 'assets/account/vehicle_icon.png'),
              ],
            ),
            _Section(
              title: 'documents'.tr,
              children: [
                _Tile('driving_license', 'assets/account/license_icon.png'),
                _Tile('vehicle_papers', 'assets/account/papers_icon.png'),
              ],
            ),
            _Section(
              title: 'settings_prefs'.tr,
              children: [
                _Tile(
                  'language',
                  'assets/account/language_icon.png',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'english_us'.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black54,
                        ),
                      ),
                      8.horizontalSpace,
                      Icon(Icons.chevron_right, size: 18.sp, color: Colors.black45),
                    ],
                  ),
                ),

                _Tile('notification', 'assets/account/notification_icon.png'),
              ],
            ),
            _Section(
              title: 'security_privacy'.tr,
              children: [
                _Tile(
                    'change_password', 'assets/account/change_password_icon.png'),
                _Tile('tap_sos', 'assets/account/sos_icon.png'),
                _Tile('delete_account', 'assets/account/delete_icon.png'),

              ],
            ),
            _Section(
              title: 'support_legal'.tr,
              children: [
                _Tile('help_center', 'assets/account/help_icon.png'),
                _Tile('contact_support', 'assets/account/contact_icon.png'),
                _Tile('cancellation_policy',
                    'assets/account/cancellation_policy_icon.png'),
                _Tile('terms_conditions', 'assets/account/notification_icon.png'),
                _Tile('privacy_policy', 'assets/account/profile_icon.png'),
                _Tile('refund_policy', 'assets/account/notification_icon.png'),
              ],
            ),
            SliverToBoxAdapter(child: 8.verticalSpace),
            SliverToBoxAdapter(
              child: _LogoutButton(
                text: 'logout'.tr,
                onPressed: () async {
                  final ok = await showLogoutConfirmSheet(context);
                  if (!context.mounted) return;         // safety after await
                  if (ok == true) controller.logout();
                },
              ),
            ),
            SliverToBoxAdapter(child: 32.verticalSpace),
          ],
        ),
      ),
    );
  }
}

class _Header extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    final overlap = 80.h; // how far the card hangs below the red header

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Red header background + profile block
        Container(
          color: _bgTop,
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 155.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Brand row
              Row(
                children: [
                  Image.asset('assets/logo.png', height: 34.h),
                  const Spacer(),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.notifications_none, color: Colors.white, size: 26.sp),
                      Positioned(
                        right: -1.w,
                        top: -1.h,
                        child: Container(
                          width: 12.w, height: 12.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF9FB0), shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              8.verticalSpace,

              // Greeting
              Obx(() => Text(
                'good_morning'.trParams({'name': controller.driverName.value}),
                style: TextStyle(fontSize: 13.sp, color: Colors.white),
              )),
              16.verticalSpace,

              // Avatar + rating pill
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 34.r,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 32.r,
                        backgroundColor: const Color(0xFFFFE7E5),
                        child: Icon(Icons.person, size: 30.sp, color: Colors.white),
                      ),
                    ),
                    Positioned(bottom: -8.h, child: _RatingPill(value: controller.rating.value)),
                  ],
                ),
              ),
              22.verticalSpace,

              // Name
              Text(
                'Md Kamrul Hasan',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w700),
              ),


              // Subtitle + Verified
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ac Ambulance',
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(.85))),
                  8.horizontalSpace,
                  const _VerifiedChip(),
                ],
              ),


              // Vehicle
              Obx(() => Text(
                controller.vehicleTitle.value,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14.sp, letterSpacing: .2),
              )),
            ],
          ),
        ),

        // Floating Premium card (centered, overlapping)
        Positioned(
          left: 16.w,
          right: 16.w,
          bottom: -overlap,
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 340.w),
              child: const _PremiumCard(),
            ),
          ),
        ),
      ],
    );
  }
}






class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            4.verticalSpace,
            Text(title, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
            8.verticalSpace,
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: _divider),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < children.length; i++) ...[
                    children[i],
                    if (i != children.length - 1)
                      Divider(height: 1.h, thickness: 1, color: _divider),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _Tile extends GetView<AccountController> {
  const _Tile(this.keyName, this.iconPath, {this.trailing, super.key});

  final String keyName;
  final String iconPath;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    // Define conditional color based on keyName
    final bool isDelete = keyName == 'delete_account';

    return InkWell(
      onTap: () => controller.onTapItem(keyName),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Row(
          children: [
            Image.asset(iconPath, height: 28.h, width: 28.h),
            10.horizontalSpace,
            Expanded(
              child: Text(
                keyName.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDelete
                      ? const Color(0xFFEF3D33) // 🔴 Red color for delete
                      : const Color(0xFF1E293B), // default text color
                ),
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  size: 18.sp,
                  color: isDelete
                      ? const Color(0xFFEF3D33) // also red arrow if you want
                      : Colors.black45,
                ),
          ],
        ),
      ),
    );
  }
}


class _LogoutButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _LogoutButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // give left padding to align with other items (12.w in your case)
      padding: EdgeInsets.only(left: 16.w, top: 12.h, bottom: 12.h),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Image.asset(
          'assets/account/logout_icon.png',
          width: 26.w,
          height: 26.w,
        ),
        label: Text(
          text,
          style: TextStyle(
            color: const Color(0xFFFF3B30),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft, // ensure icon+text left-aligned
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          foregroundColor: const Color(0xFFFF3B30),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}



class _PremiumCard extends GetView<AccountController> {
  const _PremiumCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias, // keep rounded corners crisp
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ---------- ORANGE HEADER ----------
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFA000),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Obx(() {
              final expire =
              'expire_on'.trParams({'date': controller.planExpireDate.value});

              // styles used to compute crown size to span two lines
              final titleStyle = TextStyle(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              );
              final subStyle = TextStyle(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              );

              // icon size ≈ height of both lines + a small gap
              final double crownSize = (titleStyle.fontSize ?? 0) +
                  (subStyle.fontSize ?? 0) +
                  12.h;

              return Center( // center the whole row inside the header
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: crownSize,
                      width: crownSize, // keep it square
                      child: Image.asset(
                        'assets/account/white_crown.png',
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                    ),
                    12.horizontalSpace,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('premium_pilot'.tr, style: titleStyle),
                        2.verticalSpace,
                        Text(expire, style: subStyle),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),




          // thin divider between header and body
          Container(height: 1, color: const Color(0xFFEDEDED)),

          // ---------- MIDDLE: Trips text ----------
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
            child: Column(
              children: [
                Text(
                  'trips_completed'.tr,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    color: Colors.black,

                  ),
                  textAlign: TextAlign.center,
                ),
                6.verticalSpace,
                Obx(() => Text(
                  'trips_completed_value'.trParams({
                    'count': controller.trips.value.toString(),
                    'years': controller.years.value.toString(),
                  }),
                  style: TextStyle(
                    fontSize: 18.5.sp,

                    color: const Color(0xFF2A2F3A),
                    letterSpacing: .2,
                  ),
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ),

          // ---------- BOTTOM: two metric cells in bordered card ----------
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
              border: Border.all(color: _divider, width: 1),
            ),
            child: IntrinsicHeight( // ensures the vertical divider spans full height
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => _MetricCell(
                      title: 'acceptance_rate'.tr,
                      value: '${controller.acceptanceRate.value}%',
                    )),
                  ),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: _divider,
                  ),
                  Expanded(
                    child: Obx(() => _MetricCell(
                      title: 'cancellation_rate'.tr,
                      value: '${controller.cancellationRate.value}%',
                    )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({required this.title, required this.value, super.key});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black,

            ),
            textAlign: TextAlign.center,
          ),
          6.verticalSpace,
          Text(
            value,
            style: TextStyle(
              fontSize: 18.5.sp,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value.toStringAsFixed(2),
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700)),
          4.horizontalSpace,
          Icon(Icons.star, size: 12.sp, color: const Color(0xFF1A1A1A)),
        ],
      ),
    );
  }
}

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDBF5E9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        'Verified',
        style: TextStyle(
          color: const Color(0xFF29C17E),
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}


