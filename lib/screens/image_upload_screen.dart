import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_upload_service.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _statusMessage = "";

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _statusMessage = "Ready to upload";
          _uploadProgress = 0.0;
        });
      }
    } catch (e) {
      _showSnackBar("Error picking image: $e", isError: true);
    }
  }

  Future<void> _startUpload() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
      _statusMessage = "Compressing & Chunking...";
      _uploadProgress = 0.0;
    });

    try {
      final service = ImageUploadService();
      await service.processAndUpload(
        _selectedImage!,
        onProgress: (progress) {
          setState(() {
            _uploadProgress = progress;
            _statusMessage =
                "Uploading: ${(progress * 100).toStringAsFixed(0)}%";
          });
        },
      );

      setState(() {
        _statusMessage = "Upload Complete!";
        _uploadProgress = 1.0;
      });
      _showSnackBar("Image uploaded successfully!");

      // Return success to previous screen after short delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context, true);
        }
      });
    } catch (e) {
      setState(() => _statusMessage = "Upload Failed");
      _showSnackBar("Upload failed: $e", isError: true);
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Medical Imaging"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.contain)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined,
                              size: 64, color: Colors.black),
                          const SizedBox(height: 16),
                          Text(
                            "UPLOAD PHOTO",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 24),

            if (_isUploading || _uploadProgress > 0) ...[
              LinearProgressIndicator(
                value: _uploadProgress,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                color: Colors.black,
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
              const SizedBox(height: 8),
              Text(
                _statusMessage,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
            ],

            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    icon: Icons.camera_alt_outlined,
                    label: "Camera",
                    onPressed: _isUploading
                        ? null
                        : () => _pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    icon: Icons.photo_library_outlined,
                    label: "Gallery",
                    onPressed: _isUploading
                        ? null
                        : () => _pickImage(ImageSource.gallery),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Upload Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (_selectedImage != null && !_isUploading)
                    ? _startUpload
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: _isUploading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text(
                        "UPLOAD SECURELY",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.black, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      icon: Icon(icon, size: 20, color: Colors.black),
      label: Text(label.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
