import '../models/message.dart';

final List<Message> dummyMessages = [
  Message(
    id: 'MSG001',
    title: 'Issue Status Updated',
    description:
        'Your reported issue "Pothole on Main Road" status changed from Pending to In Progress',
    type: 'status_update',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    issueId: 'ISSUE001',
    issueTitle: 'Pothole on Main Road',
    oldStatus: 'Pending',
    newStatus: 'In Progress',
    isRead: false,
  ),
  Message(
    id: 'MSG002',
    title: 'Issue Resolved',
    description:
        'Your reported issue "Street Light Not Working" has been resolved by the authorities',
    type: 'status_update',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    issueId: 'ISSUE003',
    issueTitle: 'Street Light Not Working',
    oldStatus: 'In Progress',
    newStatus: 'Resolved',
    isRead: true,
  ),
  Message(
    id: 'MSG003',
    title: 'Community Update',
    description:
        '15 new issues reported in your area this week. Help by upvoting important issues!',
    type: 'community',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    isRead: false,
  ),
  Message(
    id: 'MSG004',
    title: 'Achievement Unlocked!',
    description:
        'Congratulations! You\'ve earned the "Civic Champion" badge for reporting 10 issues.',
    type: 'notification',
    timestamp: DateTime.now().subtract(const Duration(days: 3)),
    isRead: true,
  ),
  Message(
    id: 'MSG005',
    title: 'Issue Review Request',
    description:
        'The authorities would like more details about your report "Garbage Overflow"',
    type: 'status_update',
    timestamp: DateTime.now().subtract(const Duration(days: 4)),
    issueId: 'ISSUE002',
    issueTitle: 'Garbage Overflow',
    isRead: false,
  ),
  Message(
    id: 'MSG006',
    title: 'Weekly Report',
    description:
        'Your contributions helped resolve 3 issues this week. Thank you for making a difference!',
    type: 'community',
    timestamp: DateTime.now().subtract(const Duration(days: 7)),
    isRead: true,
  ),
];
