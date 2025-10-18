class EarningEntry {
  final DateTime date;
  final double amount;
  final String referenceId;
  final int drivingMinutes; // optional, for total driving hours

  EarningEntry({
    required this.date,
    required this.amount,
    required this.referenceId,
    this.drivingMinutes = 0,
  });
}
