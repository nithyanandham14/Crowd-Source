import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:crowd_source_civic_app/Data/models/issue.dart';
import 'package:crowd_source_civic_app/Data/models/user.dart';
import 'package:crowd_source_civic_app/Data/models/message.dart';
import 'package:crowd_source_civic_app/services/local_storage_service.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator to access localhost
  // Use 127.0.0.1 for Desktop/Web to avoid localhost resolution issues
  static String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api';
    }
    return 'http://127.0.0.1:8080/api';
  }

  // Dummy data mode - set to true to use local data instead of API
  static bool useDummyData = false;

  static User? get currentUser =>
      useDummyData ? LocalStorageService().currentUser : _apiCurrentUser;
  static User? _apiCurrentUser;

  // Store credentials for Basic Auth
  static String? _authHeader;

  static Future<User?> login(String identifier, String password) async {
    if (useDummyData) {
      // Dummy login: accept demo@test.com / password or any credentials
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay

      if ((identifier == 'demo@test.com' || identifier == 'test@test.com') &&
          password == 'password') {
        LocalStorageService().initializeDemoUser();
        return LocalStorageService().currentUser;
      }
      // For any other credentials, create a new dummy user
      final dummyUser = User(
        id: 'USER_${DateTime.now().millisecondsSinceEpoch}',
        name: identifier.contains('@') ? identifier.split('@')[0] : identifier,
        email: identifier.contains('@') ? identifier : null,
        mobileNumber: !identifier.contains('@') ? identifier : null,
      );
      LocalStorageService().setCurrentUser(dummyUser);
      return dummyUser;
    }

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/user/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'identifier': identifier, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        _apiCurrentUser = User.fromJson(userData);

        // Store credentials for subsequent requests
        final credentials = '$identifier:$password';
        _authHeader = 'Basic ${base64Encode(utf8.encode(credentials))}';

        return _apiCurrentUser;
      } else {
        debugPrint('Login failed (${response.statusCode}): ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Login Error: $e');
      if (e.toString().contains('Failed host lookup')) {
        debugPrint(
          'TIP: Check if your server is running and reachable at $baseUrl',
        );
      }
      return null;
    }
  }

  static Future<String?> signup({
    required String userName,
    required String password,
    required String confirmPassword,
    required String mobileNumber,
  }) async {
    if (useDummyData) {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay

      // Simulate successful signup
      final newUser = User(
        id: 'USER_${DateTime.now().millisecondsSinceEpoch}',
        name: userName,
        mobileNumber: mobileNumber,
      );
      LocalStorageService().setCurrentUser(newUser);
      return null; // Success
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userName': userName,
          'password': password,
          'confirmPassword': confirmPassword,
          'mobileNumber': mobileNumber,
        }),
      );

      if (response.statusCode == 200) {
        return null; // Success, no error message
      } else {
        return response.body; // Return error message
      }
    } catch (e) {
      return 'Signup Error: $e';
    }
  }

  static Future<List<Issue>> getAllIssues() async {
    if (useDummyData) {
      await Future.delayed(
        const Duration(milliseconds: 300),
      ); // Simulate network delay
      return LocalStorageService().allIssues;
    }

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/issues/all'),
            headers: _authHeader != null ? {'Authorization': _authHeader!} : {},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Issue.fromJson(json)).toList();
      } else {
        debugPrint(
          'Failed to fetch issues (${response.statusCode}): ${response.body}',
        );
        return [];
      }
    } catch (e) {
      debugPrint('Fetch Issues Error: $e');
      return [];
    }
  }

  static Future<String?> submitIssue({
    required String reporter,
    required String description,
    required String address,
    required String status,
    required String title,
    required double latitude,
    required double longitude,
    File? image,
    File? voiceMsg,
    File? video, // Note: Backend asks for 'video', param name
  }) async {
    if (useDummyData) {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay

      // Create new issue and add to local storage
      final newIssue = Issue(
        id: 'ISSUE_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: description,
        status: status,
        location: address,
        reportedBy: reporter,
        reportedAt: DateTime.now(),
        imageUrl: image?.path,
        voiceMsgUrl: voiceMsg?.path,
        videoUrl: video?.path,
      );

      LocalStorageService().addIssue(newIssue);

      // Add notification message
      LocalStorageService().addMessage(
        Message(
          id: 'MSG_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Issue Submitted',
          description:
              'Your report "$title" has been successfully submitted and is under review.',
          type: 'status_update',
          timestamp: DateTime.now(),
          issueId: newIssue.id,
          issueTitle: title,
          isRead: false,
        ),
      );

      return null; // Success
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/issues/submit'),
      );

      // Add Auth header if available
      if (_authHeader != null) {
        request.headers['Authorization'] = _authHeader!;
      }

      request.fields['reporter'] = reporter;
      request.fields['description'] = description;
      request.fields['address'] = address;
      request.fields['status'] = status;
      request.fields['title'] = title;
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();

      // Add files if they exist
      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        request.files.add(
          http.MultipartFile.fromString(
            'image',
            base64String,
            filename: 'image.jpg',
          ),
        );
      } else {
        request.files.add(
          http.MultipartFile.fromString('image', '', filename: 'empty.jpg'),
        );
      }

      if (voiceMsg != null) {
        final bytes = await voiceMsg.readAsBytes();
        final base64String = base64Encode(bytes);
        request.files.add(
          http.MultipartFile.fromString(
            'voiceMsg',
            base64String,
            filename: 'voice.m4a',
          ),
        );
      } else {
        request.files.add(
          http.MultipartFile.fromString('voiceMsg', '', filename: 'empty.m4a'),
        );
      }

      if (video != null) {
        final bytes = await video.readAsBytes();
        final base64String = base64Encode(bytes);
        request.files.add(
          http.MultipartFile.fromString(
            'video',
            base64String,
            filename: 'video.mp4',
          ),
        );
      } else {
        request.files.add(
          http.MultipartFile.fromString('video', '', filename: 'empty.mp4'),
        );
      }

      final response = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return null; // Success
      } else {
        return 'Submission failed (${response.statusCode}): $responseBody';
      }
    } catch (e) {
      return 'Submit Error: $e';
    }
  }
}
