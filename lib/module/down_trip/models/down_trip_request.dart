class DownTripRequest {
  final String pickupAddress;
  final String dropoffAddress;
  final DateTime pickupDateTime;

  DownTripRequest({
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupDateTime,
  });

  DownTripRequest copyWith({
    String? pickupAddress,
    String? dropoffAddress,
    DateTime? pickupDateTime,
  }) {
    return DownTripRequest(
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropoffAddress: dropoffAddress ?? this.dropoffAddress,
      pickupDateTime: pickupDateTime ?? this.pickupDateTime,
    );
  }
}
