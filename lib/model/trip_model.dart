class Trip {
  final String title;          // Optional display title if needed elsewhere
  final String dateText;       // e.g. "Today, 10:00 PM"
  final String address;        // e.g. "Gulshan 1, Dhaka, Bangladesh"
  final String priceText;      // e.g. "580.00 BDT"
  final String statusBadge;    // i18n key, e.g. 'home_upcoming'
  final String? clinicName;    // e.g. "Urgent care clinic (101 Elm ST)"
  final String? mapAsset;      // allow per-item custom map image if needed

  const Trip({
    required this.title,
    required this.dateText,
    required this.address,
    required this.priceText,
    required this.statusBadge,
    this.clinicName,
    this.mapAsset,
  });

  Trip copyWith({
    String? title,
    String? dateText,
    String? address,
    String? priceText,
    String? statusBadge,
    String? clinicName,
    String? mapAsset,
  }) {
    return Trip(
      title: title ?? this.title,
      dateText: dateText ?? this.dateText,
      address: address ?? this.address,
      priceText: priceText ?? this.priceText,
      statusBadge: statusBadge ?? this.statusBadge,
      clinicName: clinicName ?? this.clinicName,
      mapAsset: mapAsset ?? this.mapAsset,
    );
  }
}
