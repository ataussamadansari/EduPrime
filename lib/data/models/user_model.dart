class UserModel {
  final int id;
  final String name;
  final String email;
  final String mobile;
  final String role;
  final String status;
  final String? headline;
  final String? bio;
  final String? gender;
  final String? dateOfBirth;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? avatarUrl;
  final String? themePreference;
  final String? lastLoginAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.role,
    required this.status,
    this.headline,
    this.bio,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.avatarUrl,
    this.themePreference,
    this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] is int
            ? json['id'] as int
            : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        // Null-safe: all required strings fallback to ''
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        mobile: json['mobile']?.toString() ?? '',
        role: json['role']?.toString() ?? 'student',
        status: json['status']?.toString() ?? 'active',
        // Optional fields
        headline: json['headline']?.toString(),
        bio: json['bio']?.toString(),
        gender: json['gender']?.toString(),
        dateOfBirth: json['date_of_birth']?.toString(),
        address: json['address']?.toString(),
        city: json['city']?.toString(),
        state: json['state']?.toString(),
        country: json['country']?.toString(),
        pincode: json['pincode']?.toString(),
        avatarUrl: json['avatar_url']?.toString(),
        themePreference: json['theme_preference']?.toString(),
        lastLoginAt: json['last_login_at']?.toString(),
      );

  UserModel copyWith({
    String? name,
    String? email,
    String? mobile,
    String? headline,
    String? bio,
    String? gender,
    String? dateOfBirth,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? avatarUrl,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        mobile: mobile ?? this.mobile,
        role: role,
        status: status,
        headline: headline ?? this.headline,
        bio: bio ?? this.bio,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        address: address ?? this.address,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        pincode: pincode ?? this.pincode,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        themePreference: themePreference,
        lastLoginAt: lastLoginAt,
      );
}
