import '../models/issue.dart';

final List<Issue> dummyIssues = [
  Issue(
    id: "ISSUE001",
    title: "Pothole on Main Road",
    description: "Large pothole causing traffic congestion.",
    category: "Road",
    status: "Pending",
    location: "Anna Nagar, Chennai",
    reportedBy: "Prasanth M",
    reportedAt: DateTime(2025, 9, 10),
  ),
  Issue(
    id: "ISSUE002",
    title: "Garbage Overflow",
    description: "Garbage not collected for 3 days.",
    category: "Sanitation",
    status: "In Progress",
    location: "T Nagar, Chennai",
    reportedBy: "Ravi Kumar",
    reportedAt: DateTime(2025, 9, 11),
  ),
  Issue(
    id: "ISSUE003",
    title: "Street Light Not Working",
    description: "Street light not working at night.",
    category: "Electricity",
    status: "Resolved",
    location: "Velachery, Chennai",
    reportedBy: "Anitha",
    reportedAt: DateTime(2025, 9, 9),
  ),
];
