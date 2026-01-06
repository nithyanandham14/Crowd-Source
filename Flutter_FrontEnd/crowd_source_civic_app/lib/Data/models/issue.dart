class Issue {
  final String? id;
  final String title;
  final String description;
  final String? category;
  final String status;
  final String location;
  final String? reportedBy;
  final DateTime? reportedAt;
  final String? imageUrl;
  final String? voiceMsgUrl;
  final String? videoUrl;

  Issue({
    this.id,
    required this.title,
    required this.description,
    this.category,
    required this.status,
    required this.location,
    this.reportedBy,
    this.reportedAt,
    this.imageUrl,
    this.voiceMsgUrl,
    this.videoUrl,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['issuesNo']?.toString() ?? json['id']?.toString(),
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      category: json['category'],
      status: json['status'] ?? 'OPEN',
      location: json['address'] ?? json['location'] ?? 'Unknown Location',
      reportedBy: json['reporter'] ?? json['reportedBy'],
      reportedAt: json['stdate'] != null
          ? DateTime.tryParse(json['stdate'])
          : (json['reportedAt'] != null
                ? DateTime.tryParse(json['reportedAt'])
                : null),
      imageUrl: json['imagePath'] ?? json['imageUrl'],
      voiceMsgUrl: json['voiceMsgPath'] ?? json['voiceMsgUrl'],
      videoUrl: json['videoPath'] ?? json['videoUrl'],
    );
  }
}
