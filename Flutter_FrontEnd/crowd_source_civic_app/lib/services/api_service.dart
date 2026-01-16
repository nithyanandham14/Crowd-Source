import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:crowd_source_civic_app/Data/models/auth_response.dart';
import 'package:crowd_source_civic_app/Data/models/complaint.dart';
import 'package:crowd_source_civic_app/Data/models/complaint_request.dart';
import 'package:crowd_source_civic_app/Data/models/department.dart';
import 'package:crowd_source_civic_app/Data/models/user.dart';
import 'package:crowd_source_civic_app/services/token_service.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator to access localhost
  // Use 127.0.0.1 for Desktop/Web to avoid localhost resolution issues
  static String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api';
    }
    return 'http://127.0.0.1:8080/api';
  }

  // Current user info (cached after login)
  static User? currentUser;

  // Helper method to get authorization headers
  static Future<Map<String, String>> _getHeaders({
    bool needsAuth = false,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (needsAuth) {
      final authHeader = await TokenService.getAuthHeader();
      if (authHeader != null) {
        headers['Authorization'] = authHeader;
      }
    }

    return headers;
  }

  // ==================== Authentication ====================

  /// Login with email and password
  /// Endpoint: POST /api/auth/login
  /// Returns User on success, null on failure
  static Future<User?> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: await _getHeaders(),
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(jsonDecode(response.body));

        // Store JWT token
        await TokenService.saveToken(authResponse.token, authResponse.type);

        // Fetch user details (we need to get the current user info)
        // Note: Spring Boot doesn't return user info in login response
        // You may need to call a separate endpoint or decode JWT
        // For now, we'll create a basic user object
        currentUser = User(
          id: null, // Will be populated when we fetch user details
          name: email.split('@')[0], // Temporary
          email: email,
        );

        debugPrint('Login successful! Token stored.');
        return currentUser;
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

  /// Register a new user
  /// Endpoint: POST /api/users/register
  /// Returns error message on failure, null on success
  static Future<String?> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: await _getHeaders(),
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        debugPrint('Signup successful!');
        return null; // Success, no error message
      } else {
        final errorBody = response.body;
        debugPrint('Signup failed (${response.statusCode}): $errorBody');
        return errorBody.isNotEmpty
            ? errorBody
            : 'Signup failed. Please try again.';
      }
    } catch (e) {
      debugPrint('Signup Error: $e');
      return 'Signup Error: $e';
    }
  }

  /// Logout - clear token
  static Future<void> logout() async {
    await TokenService.clearToken();
    currentUser = null;
    debugPrint('Logged out successfully');
  }

  // ==================== User Management ====================

  /// Get user by ID
  /// Endpoint: GET /api/users/{id}
  static Future<User?> getUserById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/users/$id'),
            headers: await _getHeaders(needsAuth: true),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        debugPrint(
          'Get user failed (${response.statusCode}): ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('Get User Error: $e');
      return null;
    }
  }

  /// Get all users
  /// Endpoint: GET /api/users
  static Future<List<User>> getAllUsers() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/users'),
            headers: await _getHeaders(needsAuth: true),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        debugPrint(
          'Failed to fetch users (${response.statusCode}): ${response.body}',
        );
        return [];
      }
    } catch (e) {
      debugPrint('Fetch Users Error: $e');
      return [];
    }
  }

  // ==================== Complaint Management ====================

  /// Create a new complaint
  /// Endpoint: POST /api/complaints
  static Future<Complaint?> createComplaint(ComplaintRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/complaints'),
            headers: await _getHeaders(needsAuth: true),
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final complaintData = jsonDecode(response.body);
        debugPrint('Complaint created successfully!');
        return Complaint.fromJson(complaintData);
      } else {
        debugPrint(
          'Create complaint failed (${response.statusCode}): ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('Create Complaint Error: $e');
      return null;
    }
  }

  /// Get all complaints
  /// Endpoint: GET /api/complaints
  static Future<List<Complaint>> getAllComplaints() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/complaints'),
            headers: await _getHeaders(needsAuth: false),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Complaint.fromJson(json)).toList();
      } else {
        debugPrint(
          'Failed to fetch complaints (${response.statusCode}): ${response.body}',
        );
        return [];
      }
    } catch (e) {
      debugPrint('Fetch Complaints Error: $e');
      return [];
    }
  }

  /// Get complaints for the current authenticated user
  /// Endpoint: GET /api/complaints/my
  static Future<List<Complaint>> getMyComplaints() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/complaints/my'),
            headers: await _getHeaders(needsAuth: true),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Complaint.fromJson(json)).toList();
      } else {
        debugPrint(
          'Failed to fetch my complaints (${response.statusCode}): ${response.body}',
        );
        return [];
      }
    } catch (e) {
      debugPrint('Fetch My Complaints Error: $e');
      return [];
    }
  }

  /// Update complaint status
  /// Endpoint: PUT /api/complaints/{id}/status
  static Future<Complaint?> updateComplaintStatus(
    int complaintId,
    String newStatus,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/complaints/$complaintId/status'),
            headers: await _getHeaders(needsAuth: true),
            body: jsonEncode({'status': newStatus}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final complaintData = jsonDecode(response.body);
        debugPrint('Complaint status updated successfully!');
        return Complaint.fromJson(complaintData);
      } else {
        debugPrint(
          'Update status failed (${response.statusCode}): ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('Update Complaint Status Error: $e');
      return null;
    }
  }

  // ==================== Department Management ====================

  /// Get all departments
  /// Endpoint: GET /api/departments
  static Future<List<Department>> getDepartments() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/departments'),
            headers: await _getHeaders(needsAuth: false),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Department.fromJson(json)).toList();
      } else {
        debugPrint(
          'Failed to fetch departments (${response.statusCode}): ${response.body}',
        );
        return [];
      }
    } catch (e) {
      debugPrint('Fetch Departments Error: $e');
      return [];
    }
  }

  /// Create a new department
  /// Endpoint: POST /api/departments
  static Future<Department?> createDepartment(
    String name,
    String? description,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/departments'),
            headers: await _getHeaders(needsAuth: true),
            body: jsonEncode({'name': name, 'description': description}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final departmentData = jsonDecode(response.body);
        debugPrint('Department created successfully!');
        return Department.fromJson(departmentData);
      } else {
        debugPrint(
          'Create department failed (${response.statusCode}): ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('Create Department Error: $e');
      return null;
    }
  }
}
