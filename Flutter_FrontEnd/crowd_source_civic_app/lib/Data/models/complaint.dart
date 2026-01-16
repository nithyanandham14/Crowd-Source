import 'complaint_state.dart';

class Complaint {
  final int id;
  final String title;
  final String description;
  final String location;
  final ComplaintState status;
  final DateTime createdAt;
  final String departmentName;

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    required this.createdAt,
    required this.departmentName,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      status: ComplaintState.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      departmentName: json['departmentName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'departmentName': departmentName,
    };
  }
}
