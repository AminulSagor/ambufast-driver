class DrivingLicenseModel {
  final String number;
  final DateTime expiryDate;
  final String category; // e.g., "Professional"
  final String frontImage; // local asset for mock
  final String backImage; // local asset for mock
  final bool verified;

  const DrivingLicenseModel({
    required this.number,
    required this.expiryDate,
    required this.category,
    required this.frontImage,
    required this.backImage,
    required this.verified,
  });

  static DrivingLicenseModel mock() => DrivingLicenseModel(
        number: '7812 2139 0823 2365',
        expiryDate: DateTime(2032, 12, 12),
        category: 'Professional',
        frontImage: 'assets/mock_license.jpg', // provide any placeholder
        backImage: 'assets/mock_license.jpg', // provide any placeholder
        verified: true,
      );
}
