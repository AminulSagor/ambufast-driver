// lib/models/booking.dart

enum BookingStatus { upcoming, completed, cancelled, scheduled }

class Booking {
  final String id;
  final DateTime time;
  final String from;
  final String to;
  final double fare;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.time,
    required this.from,
    required this.to,
    required this.fare,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> j) => Booking(
    id: j['id'] as String,
    time: DateTime.parse(j['time'] as String),
    from: j['from'] as String,
    to: j['to'] as String,
    fare: (j['fare'] as num).toDouble(),
    status: BookingStatus.values[j['status'] as int],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'time': time.toIso8601String(),
    'from': from,
    'to': to,
    'fare': fare,
    'status': status.index,
  };

  // --- ID-based equality + hashCode ---
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Booking && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
