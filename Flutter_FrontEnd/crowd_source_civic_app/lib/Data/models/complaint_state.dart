// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum ComplaintState {
  OPEN,
  IN_PROGRESS,
  RESOLVED,
  REJECTED;

  String get displayName {
    switch (this) {
      case ComplaintState.OPEN:
        return 'Open';
      case ComplaintState.IN_PROGRESS:
        return 'In Progress';
      case ComplaintState.RESOLVED:
        return 'Resolved';
      case ComplaintState.REJECTED:
        return 'Rejected';
    }
  }

  Color get color {
    switch (this) {
      case ComplaintState.OPEN:
        return Colors.blue;
      case ComplaintState.IN_PROGRESS:
        return Colors.orange;
      case ComplaintState.RESOLVED:
        return Colors.green;
      case ComplaintState.REJECTED:
        return Colors.red;
    }
  }

  static ComplaintState fromString(String value) {
    switch (value.toUpperCase()) {
      case 'OPEN':
        return ComplaintState.OPEN;
      case 'IN_PROGRESS':
        return ComplaintState.IN_PROGRESS;
      case 'RESOLVED':
        return ComplaintState.RESOLVED;
      case 'REJECTED':
        return ComplaintState.REJECTED;
      default:
        return ComplaintState.OPEN;
    }
  }
}
