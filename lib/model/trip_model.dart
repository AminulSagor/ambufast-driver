// lib/model/trip_model.dart
class Trip {
  final String dateText;       // "Today, 10:00 PM"
  final String address;        // "Gulshan 1, Dhaka, Bangladesh"
  final String priceText;      // "580.00 BDT"
  final String? clinicName;    // "Urgent care clinic (101 Elm ST)"
  final String? mapAsset;      // custom map image if needed

  // Optional overrides (rarely needed)
  final String? title;         // defaults to dateText in the widget
  final String? statusBadge;   // defaults from status in the widget

  const Trip({
    required this.dateText,
    required this.address,
    required this.priceText,
    this.clinicName,
    this.mapAsset,
    this.title,
    this.statusBadge,
  });

  Trip copyWith({
    String? dateText,
    String? address,
    String? priceText,
    String? clinicName,
    String? mapAsset,
    String? title,
    String? statusBadge,
  }) {
    return Trip(
      dateText: dateText ?? this.dateText,
      address: address ?? this.address,
      priceText: priceText ?? this.priceText,
      clinicName: clinicName ?? this.clinicName,
      mapAsset: mapAsset ?? this.mapAsset,
      title: title ?? this.title,
      statusBadge: statusBadge ?? this.statusBadge,
    );
  }
}
