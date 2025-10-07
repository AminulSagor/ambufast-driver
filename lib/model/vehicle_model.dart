// lib/modules/vehicles/vehicle_model.dart
class Vehicle {
  final String? id;         // can be null if API missing it
  final String title;
  final String subtitle;
  final String? imageUrl;   // can be null if no photo
  final bool isActive;

  const Vehicle({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.isActive = false,
  });

  Vehicle copyWith({bool? isActive}) => Vehicle(
    id: id,
    title: title,
    subtitle: subtitle,
    imageUrl: imageUrl,
    isActive: isActive ?? this.isActive,
  );
}
