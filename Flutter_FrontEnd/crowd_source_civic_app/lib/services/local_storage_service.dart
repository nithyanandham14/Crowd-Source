import 'package:crowd_source_civic_app/Data/models/issue.dart';
import 'package:crowd_source_civic_app/Data/models/user.dart';
import 'package:crowd_source_civic_app/Data/dummy/dummy_issues.dart';
import 'package:crowd_source_civic_app/Data/dummy/dummy_users.dart';
import 'package:crowd_source_civic_app/Data/models/dashboard_stats.dart';
import 'package:crowd_source_civic_app/Data/models/message.dart';
import 'package:crowd_source_civic_app/Data/dummy/dummy_messages.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  // In-memory storage
  List<Issue> _issues = [...dummyIssues];
  List<Message> _messages = [...dummyMessages];
  User? _currentUser;

  // Getters
  List<Issue> get allIssues => List.unmodifiable(_issues);
  List<Message> get allMessages => List.unmodifiable(_messages);
  User? get currentUser => _currentUser;

  // Get issues by user
  List<Issue> getIssuesByUser(String? userName) {
    if (userName == null) return [];
    return _issues.where((issue) => issue.reportedBy == userName).toList();
  }

  // Get user statistics
  DashboardStats getUserStats(String? userName) {
    if (userName == null) {
      return DashboardStats(total: 0, pending: 0, inProgress: 0, resolved: 0);
    }

    final userIssues = getIssuesByUser(userName);
    return DashboardStats(
      total: userIssues.length,
      pending: userIssues
          .where((i) => i.status == 'Pending' || i.status == 'OPEN')
          .length,
      inProgress: userIssues.where((i) => i.status == 'In Progress').length,
      resolved: userIssues.where((i) => i.status == 'Resolved').length,
    );
  }

  // Add new issue
  void addIssue(Issue issue) {
    _issues.insert(0, issue); // Add to beginning of list
  }

  // Update issue status
  void updateIssueStatus(String? id, String newStatus) {
    if (id == null) return;
    final index = _issues.indexWhere((issue) => issue.id == id);
    if (index != -1) {
      final oldIssue = _issues[index];
      _issues[index] = Issue(
        id: oldIssue.id,
        title: oldIssue.title,
        description: oldIssue.description,
        category: oldIssue.category,
        status: newStatus,
        location: oldIssue.location,
        reportedBy: oldIssue.reportedBy,
        reportedAt: oldIssue.reportedAt,
        imageUrl: oldIssue.imageUrl,
      );
    }
  }

  // Set current user
  void setCurrentUser(User user) {
    _currentUser = user;
  }

  // Clear current user (logout)
  void clearCurrentUser() {
    _currentUser = null;
  }

  // Initialize with dummy user for demo
  void initializeDemoUser() {
    _currentUser = dummyUser;
  }

  // Reset all data to defaults
  void reset() {
    _issues = [...dummyIssues];
    _messages = [...dummyMessages];
    _currentUser = null;
  }

  // Add new message
  void addMessage(Message message) {
    _messages.insert(0, message);
  }
}
