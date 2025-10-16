import 'package:ambufast_driver/model/user_info.dart';

class TripTrackState {
  final String pickupAddress;
  final String dropAddress;
  final double dueAmount;
  final int etaMinutes; // to pickup
  final int destinationEtaMinutes; // to destination after trip start   <-- NEW
  final UserInfo user;

  const TripTrackState({
    required this.pickupAddress,
    required this.dropAddress,
    required this.dueAmount,
    required this.etaMinutes,
    required this.destinationEtaMinutes, // NEW
    required this.user,
  });
}
