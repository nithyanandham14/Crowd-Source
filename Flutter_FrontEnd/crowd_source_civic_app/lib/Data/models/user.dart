class User {
  final String? id;
  final String name;
  final String? email;
  final String? role;
  final String? location;
  final String? mobileNumber;

  User({
    this.id,
    required this.name,
    this.email,
    this.role,
    this.location,
    this.mobileNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      name: json['name'] as String? ?? 'Unknown User',
      email: json['email'] as String?,
      role: json['role'] as String?,
      location: json['location'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
    );
  }
}
