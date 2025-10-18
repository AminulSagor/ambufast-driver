class PaymentHistoryItem {
  final String planName;
  final String gateway; // e.g. bKash
  final DateTime paidAt;
  final double amount;

  PaymentHistoryItem({
    required this.planName,
    required this.gateway,
    required this.paidAt,
    required this.amount,
  });
}
