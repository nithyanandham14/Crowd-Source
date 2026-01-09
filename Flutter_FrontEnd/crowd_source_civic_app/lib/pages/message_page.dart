import 'package:crowd_source_civic_app/Data/models/message.dart';
import 'package:crowd_source_civic_app/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Status Updates',
    'Community',
    'Notifications',
  ];

  List<Message> get _allMessages => LocalStorageService().allMessages;

  List<Message> get _filteredMessages {
    if (_selectedFilter == 'All') return _allMessages;
    if (_selectedFilter == 'Status Updates') {
      return _allMessages.where((m) => m.type == 'status_update').toList();
    }
    if (_selectedFilter == 'Community') {
      return _allMessages.where((m) => m.type == 'community').toList();
    }
    if (_selectedFilter == 'Notifications') {
      return _allMessages.where((m) => m.type == 'notification').toList();
    }
    return _allMessages;
  }

  int get _unreadCount => _allMessages.where((m) => !m.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 63, 133, 208),
        title: const Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          if (_unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$_unreadCount new',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Chips
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        selectedColor: const Color(0xFF3F85D0),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Divider(height: 1),
            // Message List
            Expanded(
              child: _filteredMessages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mail_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No messages',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredMessages.length,
                      itemBuilder: (context, index) {
                        final message = _filteredMessages[index];
                        return _buildMessageCard(message);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard(Message message) {
    IconData icon;
    Color iconColor;

    switch (message.type) {
      case 'status_update':
        icon = Icons.info_outline;
        iconColor = Colors.blue;
        break;
      case 'community':
        icon = Icons.groups_outlined;
        iconColor = Colors.green;
        break;
      case 'notification':
        icon = Icons.notifications_outlined;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.message_outlined;
        iconColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: message.isRead ? 0 : 2,
      color: message.isRead ? Colors.white : Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: message.isRead ? Colors.grey[200]! : const Color(0xFF3F85D0),
          width: message.isRead ? 1 : 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Mark as read and show details
          _showMessageDetails(message);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            message.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: message.isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              color: const Color(0xFF274E78),
                            ),
                          ),
                        ),
                        if (!message.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    if (message.issueTitle != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '📋 ${message.issueTitle}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    if (message.newStatus != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildStatusChip(message.oldStatus ?? 'Unknown'),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          _buildStatusChip(message.newStatus!),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(message.timestamp),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    MaterialColor color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'in progress':
        color = Colors.blue;
        break;
      case 'resolved':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          color: color.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(timestamp);
    }
  }

  void _showMessageDetails(Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.description),
            if (message.issueTitle != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Related Issue:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(message.issueTitle!),
            ],
            const SizedBox(height: 16),
            Text(
              'Received: ${DateFormat('MMM d, y - h:mm a').format(message.timestamp)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
