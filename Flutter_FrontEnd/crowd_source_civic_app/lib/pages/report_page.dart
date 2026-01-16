// ignore_for_file: use_build_context_synchronously, unused_field, deprecated_member_use

import 'package:crowd_source_civic_app/Data/models/complaint_priority.dart';
import 'package:crowd_source_civic_app/Data/models/complaint_request.dart';
import 'package:crowd_source_civic_app/Data/models/department.dart';
import 'package:crowd_source_civic_app/services/api_service.dart';
import 'package:crowd_source_civic_app/Data/value_notifier.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Position? _currentPosition;
  bool _isSubmitting = false;
  bool _isLoadingDepartments = true;

  // New fields for Spring Boot  backend
  ComplaintPriority _selectedPriority = ComplaintPriority.MEDIUM;
  Department? _selectedDepartment;
  List<Department> _departments = [];

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadDepartments() async {
    setState(() => _isLoadingDepartments = true);

    final departments = await ApiService.getDepartments();

    setState(() {
      _departments = departments;
      _isLoadingDepartments = false;
      // Auto-select first department if available
      if (_departments.isNotEmpty) {
        _selectedDepartment = _departments.first;
      }
    });

    if (_departments.isEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No departments available. Please contact admin to create departments.',
          ),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      setState(() {
        _currentPosition = position;
        // Auto-fill address
        _addressController.text =
            "Lat: ${position.latitude}, Lng: ${position.longitude}";
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location captured successfully!')),
        );
      }
    }
  }

  Future<void> _submit() async {
    // Validation
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter issue title')));
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a description')),
      );
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter location/address')),
      );
      return;
    }

    if (_selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a department')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Create complaint request
    final complaintRequest = ComplaintRequest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _addressController.text.trim(),
      priority: _selectedPriority,
      departmentId: _selectedDepartment!.id,
    );

    final complaint = await ApiService.createComplaint(complaintRequest);

    setState(() => _isSubmitting = false);

    if (complaint != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Complaint submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _titleController.clear();
        _descriptionController.clear();
        _addressController.clear();
        setState(() {
          _currentPosition = null;
          _selectedPriority = ComplaintPriority.MEDIUM;
        });

        // Switch back to Home tab
        bottomBarIndex.value = 0;
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit complaint. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 63, 133, 208),
        title: const Text(
          'Report Complaint',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: _isLoadingDepartments
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Complaint Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF274E78),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                labelText: 'Complaint Title *',
                                hintText: 'e.g., Pothole on Main St',
                                prefixIcon: Icon(Icons.title),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _descriptionController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: 'Description *',
                                hintText: 'Provide detailed information...',
                                prefixIcon: Icon(Icons.description_outlined),
                                alignLabelWithHint: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                labelText: 'Location/Address *',
                                hintText: 'Enter or pick location',
                                prefixIcon: const Icon(Icons.location_city),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.my_location),
                                  tooltip: 'Get Current Location',
                                  onPressed: _getLocation,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Classification",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF274E78),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Department Dropdown
                            DropdownButtonFormField<Department>(
                              value: _selectedDepartment,
                              decoration: const InputDecoration(
                                labelText: 'Department *',
                                prefixIcon: Icon(Icons.account_balance),
                                border: OutlineInputBorder(),
                              ),
                              items: _departments.map((dept) {
                                return DropdownMenuItem<Department>(
                                  value: dept,
                                  child: Text(dept.name),
                                );
                              }).toList(),
                              onChanged: (Department? value) {
                                setState(() {
                                  _selectedDepartment = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a department';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Priority Selector
                            const Text(
                              "Priority *",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SegmentedButton<ComplaintPriority>(
                              segments: [
                                ButtonSegment(
                                  value: ComplaintPriority.LOW,
                                  label: Text(
                                    ComplaintPriority.LOW.displayName,
                                  ),
                                  icon: const Icon(
                                    Icons.flag_outlined,
                                    size: 18,
                                  ),
                                ),
                                ButtonSegment(
                                  value: ComplaintPriority.MEDIUM,
                                  label: Text(
                                    ComplaintPriority.MEDIUM.displayName,
                                  ),
                                  icon: const Icon(Icons.flag, size: 18),
                                ),
                                ButtonSegment(
                                  value: ComplaintPriority.HIGH,
                                  label: Text(
                                    ComplaintPriority.HIGH.displayName,
                                  ),
                                  icon: const Icon(Icons.flag, size: 18),
                                ),
                              ],
                              selected: {_selectedPriority},
                              onSelectionChanged:
                                  (Set<ComplaintPriority> selection) {
                                    setState(() {
                                      _selectedPriority = selection.first;
                                    });
                                  },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _isSubmitting
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              "SUBMIT COMPLAINT",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    const SizedBox(height: 8),
                    const Text(
                      '* Required fields',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
