import 'package:meta/meta.dart';

@immutable
class AdditionalService {
  final num? price;
  final String serviceId;
  final String serviceName;

  const AdditionalService({
    required this.serviceId,
    required this.serviceName,
    this.price,
  });

  factory AdditionalService.fromJson(Map<String, dynamic> j) => AdditionalService(
    price: j['price'],
    serviceId: (j['serviceId'] ?? '').toString(),
    serviceName: (j['serviceName'] ?? '').toString(),
  );
}

@immutable
class VehicleServiceItem {
  final String id;
  final String category;
  final String name;
  final String? thumbnail;
  final String? details;
  final List<AdditionalService> additionalServices;
  final String status;

  const VehicleServiceItem({
    required this.id,
    required this.category,
    required this.name,
    required this.additionalServices,
    required this.status,
    this.thumbnail,
    this.details,
  });

  factory VehicleServiceItem.fromJson(Map<String, dynamic> j) => VehicleServiceItem(
    id: (j['id'] ?? '').toString(),
    category: (j['category'] ?? '').toString(),
    name: (j['name'] ?? '').toString(),
    thumbnail: j['thumbnail']?.toString(),
    details: j['details']?.toString(),
    status: (j['status'] ?? '').toString(),
    additionalServices: (j['additionalServices'] as List? ?? [])
        .map((e) => AdditionalService.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
