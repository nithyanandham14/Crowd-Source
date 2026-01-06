// ignore_for_file: deprecated_member_use

import 'package:crowd_source_civic_app/pages/login_page.dart';
import 'package:crowd_source_civic_app/services/api_service.dart';
import 'package:crowd_source_civic_app/services/local_storage_service.dart';
import 'package:crowd_source_civic_app/Data/models/dashboard_stats.dart';
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

  DashboardStats get _userStats {
    final user = ApiService.currentUser;
    return LocalStorageService().getUserStats(user?.name);
  }

  @override
  Widget build(BuildContext context) {
    final user = ApiService.currentUser;
    final stats = _userStats;
    final totalIssues = stats.total;
    final resolvedIssues = stats.resolved;
    final communityPoints = (totalIssues * 50) + (resolvedIssues * 100);

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 32),
              decoration: const BoxDecoration(
                color: Color(0xFF3F85D0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
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
                  if (user?.mobileNumber != null && user?.email == null)
                    Text(
                      user!.mobileNumber!,
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white.withOpacity(0.8),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user?.location ?? 'Salem, Tamil Nadu',
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        totalIssues.toString(),
                        'Reported',
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        resolvedIssues.toString(),
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
                        if (totalIssues >= 1)
                          _buildAchievementCard(
                            "First Reporter",
                            "Reported 1st issue",
                            Icons.emoji_events,
                          ),
                        if (resolvedIssues >= 1)
                          _buildAchievementCard(
                            "Helper",
                            "$resolvedIssues Resolved",
                            Icons.handshake,
                          ),
                        if (totalIssues >= 5)
                          _buildAchievementCard(
                            "Active Citizen",
                            "$totalIssues Reports",
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
        activeThumbColor: const Color(0xFF3F85D0),
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
            onPressed: () {
              LocalStorageService().clearCurrentUser();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
