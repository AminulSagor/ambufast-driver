// lib/widgets/upcoming_trip_card_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/trip_model.dart';

enum TripCardStatus { upcoming, past, cancelled }

class UpcomingTripCardWidget extends StatelessWidget {
  final Trip trip;
  final TripCardStatus status;
  final void Function(Trip)? onTap;

  /// OPTIONAL OVERRIDES (safe defaults if omitted)
  final String? title;        // defaults to trip.dateText
  final String? statusBadge;  // defaults from [status]

  // assets
  static const _mapFallback   = 'assets/map.png';
  static const _iconLocation  = 'assets/icon/home_page_icon/map_not_filled.png';
  static const _iconFlag      = 'assets/icon/home_page_icon/flag.png';

  // colors (base text)
  static const _textDark = Color(0xFF2D2F39);

  const UpcomingTripCardWidget({
    super.key,
    required this.trip,
    required this.status,
    this.onTap,
    this.title,
    this.statusBadge,
  });

  // Map status -> label + colors (translated when keys exist)
  ({String label, Color bg, Color fg}) _pillForStatus() {
    switch (status) {
      case TripCardStatus.upcoming:
        return (
        label: 'tk_upcoming_badge'.tr.isNotEmpty ? 'tk_upcoming_badge'.tr : 'Upcoming',
        bg: const Color(0xFFEFF2FF),
        fg: const Color(0xFF3D63FF),
        );
      case TripCardStatus.past:
        return (
        label: 'tk_complete'.tr.isNotEmpty ? 'tk_complete'.tr : 'Completed',
        bg: const Color(0xFFE8F7EA),
        fg: const Color(0xFF0B8A2D),
        );
      case TripCardStatus.cancelled:
        return (
        label: 'tk_cancel'.tr.isNotEmpty ? 'tk_cancel'.tr : 'Cancelled',
        bg: const Color(0xFFFFE6E8),
        fg: const Color(0xFFB00020),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pill = _pillForStatus();
    final pillText = statusBadge ?? pill.label;
    final titleText = title ?? trip.dateText;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      child: Material(
        color: const Color(0xFFF7F8F8),
        elevation: 1.5,
        shadowColor: Colors.black12,
        child: InkWell(
          onTap: onTap == null ? null : () => onTap!(trip),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left image: flat rectangle (no radius)
                SizedBox(
                  width: 120.w,
                  child: Image.asset(
                    (trip.mapAsset?.isNotEmpty == true ? trip.mapAsset! : _mapFallback),
                    fit: BoxFit.cover,
                    semanticLabel: 'map',
                  ),
                ),

                SizedBox(width: 8.w),

                // Right content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h, right: 8.w, bottom: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 20.sp, height: 1.25, color: _textDark),
                        ),
                        SizedBox(height: 8.h),

                        _IconTextRow(iconAsset: _iconLocation, text: trip.address),
                        SizedBox(height: 5.h),

                        if ((trip.clinicName ?? '').isNotEmpty)
                          _IconTextRow(iconAsset: _iconFlag, text: trip.clinicName!),

                        SizedBox(height: 10.h),

                        Row(
                          children: [
                            Text(
                              trip.priceText,
                              style: TextStyle(fontSize: 16.sp, color: _textDark),
                            ),
                            const Spacer(),
                            _PillBadge(text: pillText, bg: pill.bg, fg: pill.fg),
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
        Image.asset(iconAsset, width: 20.w, height: 20.w),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14.sp, height: 1.35, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const _PillBadge({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12.r)),
      child: Text(text, style: TextStyle(fontSize: 16.sp, color: fg)),
    );
  }
}
