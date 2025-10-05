// lib/modules/vehicles/vehicle_model.dart
class Vehicle {
  final String id;
  final String title;      // e.g., 'AC Ambulance'
  final String subtitle;   // e.g., 'Toyota | Dhaka Metro 12 5896'
  final String imageUrl;   // network or asset path
  final bool isActive;

  const Vehicle({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.isActive = false,
  });

  Vehicle copyWith({bool? isActive}) =>
      Vehicle(id: id, title: title, subtitle: subtitle, imageUrl: imageUrl, isActive: isActive ?? this.isActive);
}
