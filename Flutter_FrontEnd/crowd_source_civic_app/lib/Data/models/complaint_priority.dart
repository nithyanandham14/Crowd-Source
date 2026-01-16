// ignore_for_file: constant_identifier_names

enum ComplaintPriority {
  LOW,
  MEDIUM,
  HIGH;

  String get displayName {
    switch (this) {
      case ComplaintPriority.LOW:
        return 'Low';
      case ComplaintPriority.MEDIUM:
        return 'Medium';
      case ComplaintPriority.HIGH:
        return 'High';
    }
  }

  static ComplaintPriority fromString(String value) {
    switch (value.toUpperCase()) {
      case 'LOW':
        return ComplaintPriority.LOW;
      case 'MEDIUM':
        return ComplaintPriority.MEDIUM;
      case 'HIGH':
        return ComplaintPriority.HIGH;
      default:
        return ComplaintPriority.MEDIUM;
    }
  }
}
