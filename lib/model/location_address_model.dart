// lib/combine_service/models/location_address.dart
class LocationAddress {
  final String subLocality; // e.g. "Gulshan 1"
  final String city;        // e.g. "Dhaka"
  final String country;     // e.g. "Bangladesh"

  const LocationAddress({
    required this.subLocality,
    required this.city,
    required this.country,
  });

  String get formatted {
    final parts = [
      if (subLocality.isNotEmpty) subLocality,
      if (city.isNotEmpty) city,
      if (country.isNotEmpty) country,
    ];
    return parts.join(', ');
  }

  @override
  String toString() => formatted;
}
