class TripRequest {
  final DateTime? when; // null => "Pickup now"
  final String contactFor; // e.g., 'For me'
  final String ambulanceType;
  final String tripType;
  final String category;
  final String from;
  final String to;
  final double distanceKm;
  final int etaMins;
  final double fare;

  const TripRequest({
    required this.when,
    required this.contactFor,
    required this.ambulanceType,
    required this.tripType,
    required this.category,
    required this.from,
    required this.to,
    required this.distanceKm,
    required this.etaMins,
    required this.fare,
  });
}
