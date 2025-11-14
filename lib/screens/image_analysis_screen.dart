import 'dart:io';
import 'package.flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pashu_swasthya/models/breed.dart';
import 'package:pashu_swasthya/services/breed_service.dart';
import 'package.permission_handler/permission_handler.dart';

enum AnalysisType { disease, breed }

class ImageAnalysisScreen extends StatefulWidget {
  final AnalysisType analysisType;
  const ImageAnalysisScreen({super.key, required this.analysisType});

  @override
  State<ImageAnalysisScreen> createState() => _ImageAnalysisScreenState();
}

class _ImageAnalysisScreenState extends State<ImageAnalysisScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final BreedService _breedService = BreedService();

  String? _analysisResult;
  Breed? _identifiedBreed;

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is required')),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    await _requestCameraPermission();
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _analysisResult = null; // Reset previous result
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture or upload image first')),
      );
      return;
    }

    if (widget.analysisType == AnalysisType.disease) {
      setState(() {
        _analysisResult =
            "Possible infection detected. Recommend consulting a vet.";
      });
    } else {
      final identifiedBreed = await _breedService.identifyBreed(_image!.path);
      setState(() {
        _identifiedBreed = identifiedBreed;
      });
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Analysis complete')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.analysisType == AnalysisType.disease
              ? 'Disease Diagnosis'
              : 'Breed Identification',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? const Icon(Icons.image, size: 120, color: Colors.grey)
                : Image.file(_image!, height: 250, fit: BoxFit.cover),
            const SizedBox(height: 30),
            Text(
              widget.analysisType == AnalysisType.disease
                  ? 'Upload or capture your cattle’s photo for health analysis'
                  : 'Upload or capture your cattle’s photo for breed identification',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _analyzeImage,
              icon: const Icon(Icons.analytics),
              label: const Text('Analyze'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_analysisResult != null)
              Text(
                _analysisResult!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            if (_identifiedBreed != null) _buildBreedInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildBreedInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Identified Breed: ${_identifiedBreed!.name}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _identifiedBreed!.description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
