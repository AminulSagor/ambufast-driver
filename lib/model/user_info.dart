import 'dart:convert';

class UserInfo {
  final String avatarUrl;
  final String name;
  final double rating;
  final double ratingCount;
  final String phone;

  const UserInfo({
    required this.avatarUrl,
    required this.name,
    required this.rating,
    required this.ratingCount,
    required this.phone,
  });

  UserInfo copyWith({
    String? avatarUrl,
    String? name,
    double? rating,
    double? ratingCount,
    String? vehicleDetails,
    String? phone,
  }) {
    return UserInfo(
      avatarUrl: avatarUrl ?? this.avatarUrl,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'avatarUrl': avatarUrl,
      'name': name,
      'rating': rating,
      'ratingCount': ratingCount,
      'phone': phone,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      avatarUrl: map['avatarUrl'] ?? '',
      name: map['name'] ?? '',
      rating: map['rating'] ?? 0,
      ratingCount: map['ratingCount'] ?? 0,
      phone: map['phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfo.fromJson(String source) =>
      UserInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Driver(name: $name, rating: $rating, ratingCount: $ratingCount,  phone: $phone)';
  }

  @override
  bool operator ==(covariant UserInfo other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.rating == rating &&
        other.ratingCount == ratingCount &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        rating.hashCode ^
        ratingCount.hashCode ^
        phone.hashCode;
  }
}
