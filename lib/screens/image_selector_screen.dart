import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/analyzed_image.dart';
import '../services/tflite_service.dart';
import '../utils/image_preprocessor.dart';

/// Main screen for selecting/capturing images and displaying analysis results
class ImageSelectorScreen extends StatefulWidget {
  final TFLiteService tfliteService;

  const ImageSelectorScreen({
    super.key,
    required this.tfliteService,
  });

  @override
  State<ImageSelectorScreen> createState() => _ImageSelectorScreenState();
}

class _ImageSelectorScreenState extends State<ImageSelectorScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<AnalyzedImage> _images = [];
  static const int maxImages = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Image Selector'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildBody(),
      floatingActionButton: _images.length < maxImages
          ? FloatingActionButton.extended(
              onPressed: _showImageSourceDialog,
              icon: const Icon(Icons.add_photo_alternate),
              label: Text('Add Images (${_images.length}/$maxImages)'),
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_images.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'No images selected',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tap the button below to add images',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _showImageSourceDialog,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Select or Capture Images'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return _buildImageCard(_images[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard(AnalyzedImage analyzedImage, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image display
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.file(
                    analyzedImage.imageFile,
                    fit: BoxFit.cover,
                  ),
                ),
                // Delete button
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => _removeImage(index),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      padding: const EdgeInsets.all(4),
                    ),
                  ),
                ),
                // Loading overlay
                if (analyzedImage.isAnalyzing)
                  Container(
                    color: Colors.black45,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Scores display
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.build, size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    const Text(
                      'Technical: ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      analyzedImage.technicalScoreText,
                      style: TextStyle(
                        fontSize: 12,
                        color: analyzedImage.error != null
                            ? Colors.red
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.palette, size: 16, color: Colors.purple),
                    const SizedBox(width: 4),
                    const Text(
                      'Aesthetic: ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      analyzedImage.aestheticScoreText,
                      style: TextStyle(
                        fontSize: 12,
                        color: analyzedImage.error != null
                            ? Colors.red
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Show dialog to choose between camera and gallery
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImages();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _captureImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Pick multiple images from gallery
  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles.isEmpty) return;

      // Calculate how many images we can add
      final int availableSlots = maxImages - _images.length;
      final List<XFile> filesToAdd = pickedFiles.take(availableSlots).toList();

      if (pickedFiles.length > availableSlots) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Only $availableSlots images can be added (limit: $maxImages)',
              ),
            ),
          );
        }
      }

      for (final file in filesToAdd) {
        await _addAndAnalyzeImage(File(file.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking images: $e')),
        );
      }
    }
  }

  /// Capture image from camera
  Future<void> _captureImage() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

      if (photo == null) return;

      await _addAndAnalyzeImage(File(photo.path));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error capturing image: $e')),
        );
      }
    }
  }

  /// Add image and analyze it using both models
  Future<void> _addAndAnalyzeImage(File imageFile) async {
    // Add image to list with analyzing state
    final analyzedImage = AnalyzedImage(
      imageFile: imageFile,
      isAnalyzing: true,
    );

    setState(() {
      _images.add(analyzedImage);
    });

    final index = _images.length - 1;

    try {
      // Preprocess image in background using compute
      final preprocessedData = await compute(
        _preprocessImageInBackground,
        imageFile.path,
      );

      // Run inference on main isolate (TFLite interpreters cannot be passed between isolates)
      final technicalScore = await widget.tfliteService.runTechnicalInference(
        preprocessedData,
      );
      final aestheticScore = await widget.tfliteService.runAestheticInference(
        preprocessedData,
      );

      // Update with results
      if (mounted) {
        setState(() {
          _images[index] = analyzedImage.copyWith(
            technicalScore: technicalScore,
            aestheticScore: aestheticScore,
            isAnalyzing: false,
          );
        });
      }
    } catch (e) {
      // Update with error
      if (mounted) {
        setState(() {
          _images[index] = analyzedImage.copyWith(
            isAnalyzing: false,
            error: e.toString(),
          );
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analysis error: $e')),
        );
      }
    }
  }

  /// Remove image from list
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }
}

/// Background function to preprocess image
/// Runs in separate isolate via compute()
/// TFLite inference must run on the main isolate
Future<Float32List> _preprocessImageInBackground(String imagePath) async {
  final imageFile = File(imagePath);
  return await ImagePreprocessor.preprocessImage(imageFile);
}

