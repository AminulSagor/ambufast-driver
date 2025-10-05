import 'package:get/get.dart';

class ReviewItem {
  final double rating; // 0..5
  final String title;
  final String body;
  final String avatarUrl;

  ReviewItem({
    required this.rating,
    required this.title,
    required this.body,
    required this.avatarUrl,
  });
}

class AllReviewController extends GetxController {
  // Sample data (replace with API)
  final reviews = <ReviewItem>[
    ReviewItem(
      rating: 4.0,
      title: 'good_ride_title'.tr,
      body: 'review_body_sample'.tr,
      avatarUrl: 'https://i.pravatar.cc/80?img=15',
    ),
    ReviewItem(
      rating: 5.0,
      title: 'great_ride_title'.tr,
      body: '',
      avatarUrl: 'https://i.pravatar.cc/80?img=16',
    ),
    ReviewItem(
      rating: 2.5,
      title: 'bad_ride_title'.tr,
      body: 'review_body_sample'.tr,
      avatarUrl: 'https://i.pravatar.cc/80?img=17',
    ),
    ReviewItem(
      rating: 4.0,
      title: 'good_ride_title'.tr,
      body: 'review_body_sample'.tr,
      avatarUrl: 'https://i.pravatar.cc/80?img=18',
    ),
  ].obs;
}
