// Low-cost intercity card model
class PromoRoute {
  final String imageAsset; // banner image
  final String title;      // e.g. 'Naogaon to Dhaka'
  final String subtitle;   // e.g. '30% discount'
  final String dateText;   // e.g. '02 Jul, 10:00 PM'
  final String meta;       // e.g. '2hour after'

  const PromoRoute({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.dateText,
    required this.meta,
  });

  factory PromoRoute.fromJson(Map<String, dynamic> json) => PromoRoute(
    imageAsset: json['imageAsset'] as String,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    dateText: json['dateText'] as String,
    meta: json['meta'] as String,
  );

  Map<String, dynamic> toJson() => {
    'imageAsset': imageAsset,
    'title': title,
    'subtitle': subtitle,
    'dateText': dateText,
    'meta': meta,
  };
}
