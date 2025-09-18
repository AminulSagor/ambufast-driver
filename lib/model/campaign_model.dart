// Campaign grid card model
class Campaign {
  final String imageAsset; // banner image
  final String titleKey;   // i18n key
  final String subtitle;   // e.g. '30% discount'

  const Campaign(this.imageAsset, this.titleKey, this.subtitle);

  factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(
    json['imageAsset'] as String,
    json['titleKey'] as String,
    json['subtitle'] as String,
  );

  Map<String, dynamic> toJson() => {
    'imageAsset': imageAsset,
    'titleKey': titleKey,
    'subtitle': subtitle,
  };
}
