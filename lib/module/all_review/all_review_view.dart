import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'all_review_controller.dart';

class AllReviewView extends GetView<AllReviewController> {
  const AllReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF7FBF8),
        foregroundColor: Colors.black87,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 18.sp),
          onPressed: Get.back, // or: () => Navigator.of(context).maybePop()
          tooltip: 'Back',
        ),
        title: Text(
          'all_review'.tr,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
      ),

      body: Obx(() {
        final items = controller.reviews;
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemBuilder: (context, i) {
            final r = items[i];
            return _ReviewTile(item: r);
          },
          separatorBuilder: (_, __) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(color: const Color(0xFFE5E7EB), height: 1.h),
          ),
          itemCount: items.length,
        );
      }),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ReviewItem item;
  const _ReviewTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Stars(rating: item.rating),
              SizedBox(height: 8.h),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
              ),
              if (item.body.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Text(
                  item.body,
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.35,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),

        SizedBox(width: 12.w),

        // Avatar on right
        CircleAvatar(
          radius: 32.r,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(item.avatarUrl),
        ),
      ],
    );
  }
}

class _Stars extends StatelessWidget {
  final double rating; // 0..5
  const _Stars({required this.rating});

  @override
  Widget build(BuildContext context) {
    final full = rating.floor();
    final hasHalf = (rating - full) >= 0.5;
    final total = 5;

    List<Widget> icons = [];
    for (int i = 0; i < full; i++) {
      icons.add(Icon(Icons.star_rounded, size: 16.sp, color: const Color(0xFF111827)));
    }
    if (hasHalf) {
      // Use star_border for the “not full” look to match mock (or Icons.star_half_rounded if preferred)
      icons.add(Icon(Icons.star_half_rounded, size: 16.sp, color: const Color(0xFF111827)));
    }
    while (icons.length < total) {
      icons.add(Icon(Icons.star_border_rounded, size: 16.sp, color: const Color(0xFF111827)));
    }

    return Row(children: icons);
  }
}
