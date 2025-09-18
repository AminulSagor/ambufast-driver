import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/trip_model.dart';

class UpcomingTripCardWidget extends StatelessWidget {
  final Trip trip;
  final void Function(Trip)? onTap;

  // assets
  static const _mapFallback = 'assets/map.png';
  static const _iconLocation = 'assets/icon/home_page_icon/map_not_filled.png';
  static const _iconFlag     = 'assets/icon/home_page_icon/flag.png';

  // spacings
  static const _gapS = 5.0;
  static const _gapM = 8.0;
  static const _gapL = 10.0;

  // colors
  static const _textDark = Color(0xFF2D2F39);
  static const _pillBg   = Color(0xFFEFF2FF);
  static const _pillText = Color(0xFF3D63FF);

  const UpcomingTripCardWidget({
    super.key,
    required this.trip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Material(
        color: const Color(0xFFF7F8F8),
        elevation: 1.5,
        shadowColor: Colors.black12,
        // rectangle card (no border radius)
        child: InkWell(
          onTap: onTap == null ? null : () => onTap!(trip),
          child: IntrinsicHeight( // let the left image match the full height of the right content
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // IMAGE: touches left + top + bottom of the card
                SizedBox(
                  width: 120,
                  child: Image.asset(
                    trip.mapAsset?.isNotEmpty == true ? trip.mapAsset! : _mapFallback,
                    fit: BoxFit.cover,
                    // no border radius on the image (card is rectangular)
                  ),
                ),

                const SizedBox(width: _gapM),

                // RIGHT CONTENT
                Expanded(
                  child: Padding(
                    // vertical padding removed so image and content align to top/bottom
                    padding: const EdgeInsets.only(top: _gapM, right: _gapM, bottom: _gapM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.dateText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            height: 1.25,
                            color: _textDark,
                          ),
                        ),
                        const SizedBox(height: _gapM),

                        _IconTextRow(iconAsset: _iconLocation, text: trip.address),
                        const SizedBox(height: _gapS),

                        if ((trip.clinicName ?? '').isNotEmpty)
                          _IconTextRow(iconAsset: _iconFlag, text: trip.clinicName!),

                        const SizedBox(height: _gapL),

                        Row(
                          children: [
                            Text(
                              trip.priceText,
                              style: const TextStyle(fontSize: 16, color: _textDark),
                            ),
                            const Spacer(),
                            const _PillBadge(text: 'Upcoming'), // or trip.statusBadge.tr
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconTextRow extends StatelessWidget {
  final String iconAsset;
  final String text;

  const _IconTextRow({required this.iconAsset, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(iconAsset, width: 20, height: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              height: 1.35,

              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String text;
  const _PillBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: UpcomingTripCardWidget._pillBg,
        borderRadius: BorderRadius.circular(12), // only the pill is rounded
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: UpcomingTripCardWidget._pillText,
        ),
      ),
    );
  }
}
