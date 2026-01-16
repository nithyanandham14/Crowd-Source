// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unused_field

import 'package:crowd_source_civic_app/Data/models/complaint_state.dart';
import 'package:crowd_source_civic_app/pages/login_page.dart';
import 'package:crowd_source_civic_app/services/api_service.dart';
import 'package:crowd_source_civic_app/services/token_service.dart';
import 'package:crowd_source_civic_app/Data/models/complaint.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool valueNotification = false;
  bool valueLocation = false;
  bool valuePublicProfile = false;

  late Future<List<Complaint>> _myComplaintsFuture;
  int _totalComplaints = 0;
  int _resolvedComplaints = 0;
  int _inProgressComplaints = 0;

  @override
  void initState() {
    super.initState();
    _loadMyComplaints();
  }

  void _loadMyComplaints() {
    _myComplaintsFuture = ApiService.getMyComplaints();
    _myComplaintsFuture.then((complaints) {
      setState(() {
        _totalComplaints = complaints.length;
        _resolvedComplaints = complaints
            .where((c) => c.status == ComplaintState.RESOLVED)
            .length;
        _inProgressComplaints = complaints
            .where((c) => c.status == ComplaintState.IN_PROGRESS)
            .length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ApiService.currentUser;
    final communityPoints =
        (_totalComplaints * 50) + (_resolvedComplaints * 100);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xFF3F85D0),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 32),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF3F85D0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      user?.name[0].toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F85D0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'Guest User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (user?.email != null)
                    Text(
                      user!.email!,
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        _totalComplaints.toString(),
                        'Reported',
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        _resolvedComplaints.toString(),
                        'Resolved',
                        Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 32),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Community Points",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                communityPoints.toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        Icons.trending_up,
                        color: Colors.green[700],
                        size: 32,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Achievements",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF274E78),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        if (_totalComplaints >= 1)
                          _buildAchievementCard(
                            "First Reporter",
                            "Reported 1st issue",
                            Icons.emoji_events,
                          ),
                        if (_resolvedComplaints >= 1)
                          _buildAchievementCard(
                            "Helper",
                            "$_resolvedComplaints Resolved",
                            Icons.handshake,
                          ),
                        if (_totalComplaints >= 5)
                          _buildAchievementCard(
                            "Active Citizen",
                            "$_totalComplaints Reports",
                            Icons.local_fire_department,
                          ),
                        if (communityPoints >= 100)
                          _buildAchievementCard(
                            "Point Master",
                            "$communityPoints Points",
                            Icons.military_tech,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF274E78),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingTile(
                    "Push Notifications",
                    Icons.notifications_outlined,
                    valueNotification,
                    (v) => setState(() => valueNotification = v),
                  ),
                  _buildSettingTile(
                    "Location Services",
                    Icons.location_on_outlined,
                    valueLocation,
                    (v) => setState(() => valueLocation = v),
                  ),
                  _buildSettingTile(
                    "Public Profile",
                    Icons.public,
                    valuePublicProfile,
                    (v) => setState(() => valuePublicProfile = v),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Colors.red[50],
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      "Sign Out",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      _showSignOutDialog();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, MaterialColor color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(String title, String subtitle, IconData icon) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.amber[700]),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: const Color(0xFF3F85D0)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF3F85D0),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Clear JWT token
              await TokenService.clearToken();
              await ApiService.logout();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: Size(100, 45),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
