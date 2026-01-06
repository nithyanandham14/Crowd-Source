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
      id: (json['userId'] ?? json['id'] ?? json['UserId'])?.toString(),
      name: json['userName'] ?? json['name'] ?? 'Unknown User',
      email: json['email'],
      role: json['role'] ?? 'USER',
      location: json['location'] ?? json['address'],
      mobileNumber: json['mobileNumber'],
    );
  }
}
