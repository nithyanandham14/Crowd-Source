class Message {
  final String id;
  final String title;
  final String description;
  final String type; // 'status_update', 'community', 'notification'
  final DateTime timestamp;
  final String? issueId;
  final String? issueTitle;
  final String? oldStatus;
  final String? newStatus;
  final bool isRead;

  Message({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.issueId,
    this.issueTitle,
    this.oldStatus,
    this.newStatus,
    this.isRead = false,
  });

  Message copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    DateTime? timestamp,
    String? issueId,
    String? issueTitle,
    String? oldStatus,
    String? newStatus,
    bool? isRead,
  }) {
    return Message(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      issueId: issueId ?? this.issueId,
      issueTitle: issueTitle ?? this.issueTitle,
      oldStatus: oldStatus ?? this.oldStatus,
      newStatus: newStatus ?? this.newStatus,
      isRead: isRead ?? this.isRead,
    );
  }
}
