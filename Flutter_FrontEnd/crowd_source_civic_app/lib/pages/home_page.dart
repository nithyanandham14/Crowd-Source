import 'package:crowd_source_civic_app/Data/models/issue.dart';
import 'package:crowd_source_civic_app/services/api_service.dart';
import 'package:crowd_source_civic_app/pages/issue_detail_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Issue>> _issuesFuture;

  @override
  void initState() {
    super.initState();
    _issuesFuture = ApiService.getAllIssues();
  }

  Future<void> _refreshIssues() async {
    setState(() {
      _issuesFuture = ApiService.getAllIssues();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 63, 133, 208),
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshIssues,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Issue>>(
          future: _issuesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No issues reported yet.'));
            }

            final issues = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshIssues,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: issues.length,
                itemBuilder: (context, index) {
                  final issue = issues[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IssueDetailPage(issue: issue),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    issue.title.isNotEmpty
                                        ? issue.title
                                        : "No Title",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF274E78),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        issue.status == 'OPEN' ||
                                            issue.status == 'Pending'
                                        ? Colors.green[100]
                                        : issue.status == 'In Progress'
                                        ? Colors.blue[100]
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    issue.status,
                                    style: TextStyle(
                                      color:
                                          issue.status == 'OPEN' ||
                                              issue.status == 'Pending'
                                          ? Colors.green[800]
                                          : issue.status == 'In Progress'
                                          ? Colors.blue[800]
                                          : Colors.grey[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              issue.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            if (issue.location.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      issue.location,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
