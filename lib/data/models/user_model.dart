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
        id: json['id'],
        name: json['name'],
        email: json['email'],
        mobile: json['mobile'],
        role: json['role'],
        status: json['status'],
        headline: json['headline'],
        bio: json['bio'],
        gender: json['gender'],
        dateOfBirth: json['date_of_birth'],
        address: json['address'],
        city: json['city'],
        state: json['state'],
        country: json['country'],
        pincode: json['pincode'],
        avatarUrl: json['avatar_url'],
        themePreference: json['theme_preference'],
        lastLoginAt: json['last_login_at'],
      );
}
