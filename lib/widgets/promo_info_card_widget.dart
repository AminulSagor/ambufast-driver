import 'package:flutter/material.dart';

enum PromoCardKind { intercity, campaign }

class PromoInfoCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subtitle;
  final String? bottomLeft;   // only used for intercity
  final String? bottomRight;  // only used for intercity
  final VoidCallback? onTap;
  final PromoCardKind kind;
  final double? width;

  const PromoInfoCard({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    this.bottomLeft,
    this.bottomRight,
    this.onTap,
    this.kind = PromoCardKind.campaign,
    this.width,
  });

  // ✅ Use factories instead of redirecting constructors
  factory PromoInfoCard.intercity({
    Key? key,
    required String imageAsset,
    required String title,
    required String subtitle,
    String? bottomLeft,
    String? bottomRight,
    VoidCallback? onTap,
    double? width,
  }) {
    return PromoInfoCard(
      key: key,
      imageAsset: imageAsset,
      title: title,
      subtitle: subtitle,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
      onTap: onTap,
      kind: PromoCardKind.intercity,
      width: width,
    );
  }

  factory PromoInfoCard.campaign({
    Key? key,
    required String imageAsset,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    double? width,
  }) {
    return PromoInfoCard(
      key: key,
      imageAsset: imageAsset,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      kind: PromoCardKind.campaign,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageHeight = kind == PromoCardKind.intercity ? 76.0 : 100.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.asset(
                imageAsset,
                height: imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                  if (kind == PromoCardKind.intercity &&
                      ((bottomLeft ?? '').isNotEmpty || (bottomRight ?? '').isNotEmpty))
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          if ((bottomLeft ?? '').isNotEmpty)
                            Text(bottomLeft!,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                )),
                          if ((bottomLeft ?? '').isNotEmpty && (bottomRight ?? '').isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: SizedBox(
                                height: 14,
                                child: VerticalDivider(
                                  width: 1,
                                  thickness: 1,
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                          if ((bottomRight ?? '').isNotEmpty)
                            Text(bottomRight!,
                                style: const TextStyle(
                                  color: Color(0xFFED4C3A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                )),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
