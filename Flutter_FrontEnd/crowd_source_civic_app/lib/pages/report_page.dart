// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:crowd_source_civic_app/services/api_service.dart';
import 'package:crowd_source_civic_app/Data/value_notifier.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:record/record.dart'; // record ^6.x changes
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _image;
  File? _voiceMsg;
  File? _video;
  Position? _currentPosition;
  bool _isSubmitting = false;
  bool _isRecording = false;

  final ImagePicker _picker = ImagePicker();
  late AudioRecorder _audioRecorder;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Gallery'),
              onTap: () {
                _getImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                _getImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickAudio() async {
    showModalBottomSheet(
      context: context,
      isDismissible: !_isRecording,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Wrap(
              children: [
                if (!_isRecording) ...[
                  ListTile(
                    leading: const Icon(Icons.mic, color: Colors.red),
                    title: const Text('Record Audio'),
                    onTap: () async {
                      await _startRecording(setModalState);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.audio_file),
                    title: const Text('Pick Audio File'),
                    onTap: () async {
                      await _pickAudioFile();
                      if (mounted) Navigator.of(context).pop();
                    },
                  ),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.mic, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text(
                          "Recording in progress...",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await _stopRecording();
                            if (mounted) Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.stop),
                          label: const Text("STOP RECORDING"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      setState(() {
        _voiceMsg = File(result.files.single.path!);
      });
    }
  }

  Future<void> _startRecording(StateSetter setModalState) async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final path = p.join(
          directory.path,
          'recording_${DateTime.now().millisecondsSinceEpoch}.m4a',
        );

        const config = RecordConfig(); // Default is m4a/aac on mobile
        await _audioRecorder.start(config, path: path);

        setState(() => _isRecording = true);
        setModalState(() {});
      } else {
        debugPrint("Recording permission denied");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required to record audio.'),
          ),
        );
      }
    } catch (e) {
      debugPrint("Recording error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error starting recording: $e')));
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        if (path != null) {
          _voiceMsg = File(path);
        }
      });
    } catch (e) {
      debugPrint("Stop recording error: $e");
    }
  }

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _video = File(pickedFile.path);
      });
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
        // Auto-fill address? (Would need geocoding package)
        _addressController.text =
            "Lat: ${position.latitude}, Lng: ${position.longitude}";
      });
    }
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all text fields.')));
      return;
    }

    setState(() => _isSubmitting = true);

    final error = await ApiService.submitIssue(
      reporter: ApiService.currentUser?.name ?? 'Anonymous',
      description: _descriptionController.text,
      address: _addressController.text,
      status: 'OPEN',
      title: _titleController.text,
      latitude: _currentPosition?.latitude ?? 0.0,
      longitude: _currentPosition?.longitude ?? 0.0,
      image: _image,
      voiceMsg: _voiceMsg,
      video: _video,
    );

    setState(() => _isSubmitting = false);

    if (error == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Issue Submitted Successfully!')),
        );
        // Switch back to Home tab
        bottomBarIndex.value = 0;
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 63, 133, 208),
        title: const Text(
          'Report',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                        "Issue Details",
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
                          labelText: 'Issue Title',
                          hintText: 'e.g., Pothole on Main St',
                          prefixIcon: Icon(Icons.title),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Provide details...',
                          prefixIcon: Icon(Icons.description_outlined),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          hintText: 'Enter or pick location',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Attachments",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF274E78),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 44) / 2,
                    child: _buildAttachmentCard(
                      Icons.add_photo_alternate_outlined,
                      "Photo",
                      _image != null,
                      _pickImage,
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 44) / 2,
                    child: _buildAttachmentCard(
                      Icons.mic_none_outlined,
                      "Audio",
                      _voiceMsg != null,
                      _pickAudio,
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 44) / 2,
                    child: _buildAttachmentCard(
                      Icons.videocam_outlined,
                      "Video",
                      _video != null,
                      _pickVideo,
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 44) / 2,
                    child: _buildAttachmentCard(
                      Icons.location_on_outlined,
                      "Location",
                      _currentPosition != null,
                      _getLocation,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildPreviewSection(),
              const SizedBox(height: 24),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text("SUBMIT REPORT"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    if (_image == null && _voiceMsg == null && _video == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Selected Attachments",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF274E78),
          ),
        ),
        const SizedBox(height: 8),
        if (_image != null)
          _buildPreviewItem(
            "Image",
            Icons.image_outlined,
            onRemove: () => setState(() => _image = null),
            previewWidget: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                _image!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        if (_voiceMsg != null)
          _buildPreviewItem(
            "Audio Message",
            Icons.mic_none_outlined,
            onRemove: () => setState(() => _voiceMsg = null),
          ),
        if (_video != null)
          _buildPreviewItem(
            "Video",
            Icons.videocam_outlined,
            onRemove: () => setState(() => _video = null),
          ),
      ],
    );
  }

  Widget _buildPreviewItem(
    String label,
    IconData icon, {
    required VoidCallback onRemove,
    Widget? previewWidget,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF3F85D0)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close, color: Colors.red),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            if (previewWidget != null) ...[
              const SizedBox(height: 8),
              previewWidget,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentCard(
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF3F85D0) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? const Color(0xFF3F85D0) : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              isSelected ? "Added" : label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF3F85D0) : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
