import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;

/// Utility class for preprocessing images before TensorFlow Lite inference
class ImagePreprocessor {
  /// Required input size for the NIMA models
  static const int targetSize = 224;

  /// Preprocess an image file for TensorFlow Lite inference
  /// 
  /// Steps:
  /// 1. Decode image from file
  /// 2. Resize to 224x224
  /// 3. Convert to RGB (remove alpha channel if present)
  /// 4. Normalize pixel values to float32 in range [0, 1]
  /// 
  /// [imageFile] - The image file to preprocess
  /// Returns a Float32List containing normalized pixel data of shape [1, 224, 224, 3]
  static Future<Float32List> preprocessImage(File imageFile) async {
    try {
      // Read image bytes from file
      final bytes = await imageFile.readAsBytes();

      // Decode image
      img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize to 224x224 using bilinear interpolation
      img.Image resized = img.copyResize(
        image,
        width: targetSize,
        height: targetSize,
        interpolation: img.Interpolation.linear,
      );

      // Convert to Float32List with normalization
      // Expected format: [height, width, channels] -> [224, 224, 3]
      final convertedBytes = Float32List(1 * targetSize * targetSize * 3);
      int pixelIndex = 0;

      // Iterate through each pixel
      for (int y = 0; y < targetSize; y++) {
        for (int x = 0; x < targetSize; x++) {
          // Get pixel at (x, y)
          final pixel = resized.getPixel(x, y);

          // Extract RGB values and normalize to [0, 1]
          // The image package returns values in 0-255 range
          convertedBytes[pixelIndex++] = pixel.r / 255.0;
          convertedBytes[pixelIndex++] = pixel.g / 255.0;
          convertedBytes[pixelIndex++] = pixel.b / 255.0;
        }
      }

      return convertedBytes;
    } catch (e) {
      print('Error preprocessing image: $e');
      rethrow;
    }
  }

  /// Get image dimensions without full preprocessing (for display purposes)
  static Future<Map<String, int>> getImageDimensions(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      
      if (image == null) {
        return {'width': 0, 'height': 0};
      }

      return {
        'width': image.width,
        'height': image.height,
      };
    } catch (e) {
      print('Error getting image dimensions: $e');
      return {'width': 0, 'height': 0};
    }
  }
}

