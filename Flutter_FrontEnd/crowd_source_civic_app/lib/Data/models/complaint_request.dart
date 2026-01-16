import 'complaint_priority.dart';

class ComplaintRequest {
  final String title;
  final String description;
  final String location;
  final ComplaintPriority priority;
  final int departmentId;

  ComplaintRequest({
    required this.title,
    required this.description,
    required this.location,
    required this.priority,
    required this.departmentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'priority': priority.name,
      'departmentId': departmentId,
    };
  }
}
