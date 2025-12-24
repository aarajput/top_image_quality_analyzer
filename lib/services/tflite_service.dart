import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Service class for managing TensorFlow Lite models
/// Handles loading models and running inference for image quality assessment
class TFLiteService {
  // Private interpreters for the two models
  Interpreter? _aestheticInterpreter;
  Interpreter? _technicalInterpreter;

  // Model paths
  static const String _aestheticModelPath = 'assets/models/aesthetic_model.tflite';
  static const String _technicalModelPath = 'assets/models/technical_model.tflite';

  // Model input/output specifications
  static const int inputSize = 224; // 224x224 image input
  static const int outputSize = 10; // 10-class probability distribution

  /// Initialize and load both TensorFlow Lite models
  /// Should be called once during app startup
  Future<void> loadModels() async {
    try {
      // Load aesthetic model
      _aestheticInterpreter = await Interpreter.fromAsset(_aestheticModelPath);
      print('Aesthetic model loaded successfully');

      // Load technical model
      _technicalInterpreter = await Interpreter.fromAsset(_technicalModelPath);
      print('Technical model loaded successfully');
    } catch (e) {
      print('Error loading models: $e');
      rethrow;
    }
  }

  /// Run inference on preprocessed image data using the aesthetic model
  /// 
  /// [imageData] - Normalized float32 array of shape [1, 224, 224, 3]
  /// Returns the computed mean opinion score (MOS) for aesthetic quality
  Future<double> runAestheticInference(Float32List imageData) async {
    if (_aestheticInterpreter == null) {
      throw Exception('Aesthetic model not loaded');
    }

    try {
      // Reshape input data to [1, 224, 224, 3]
      final input = _reshapeInputData(imageData);

      // Prepare output tensor: [1, 10]
      final output = List.generate(1, (_) => List.filled(outputSize, 0.0));

      // Run inference
      _aestheticInterpreter!.run(input, output);

      // Extract probability distribution
      final probabilities = output[0];

      // Calculate mean opinion score (MOS)
      // score = sum(probability[i] * (i + 1)) for i in 0..9
      double score = 0.0;
      for (int i = 0; i < outputSize; i++) {
        score += probabilities[i] * (i + 1);
      }

      return score;
    } catch (e) {
      print('Error running aesthetic inference: $e');
      rethrow;
    }
  }

  /// Run inference on preprocessed image data using the technical model
  /// 
  /// [imageData] - Normalized float32 array of shape [1, 224, 224, 3]
  /// Returns the computed mean opinion score (MOS) for technical quality
  Future<double> runTechnicalInference(Float32List imageData) async {
    if (_technicalInterpreter == null) {
      throw Exception('Technical model not loaded');
    }

    try {
      // Reshape input data to [1, 224, 224, 3]
      final input = _reshapeInputData(imageData);

      // Prepare output tensor: [1, 10]
      final output = List.generate(1, (_) => List.filled(outputSize, 0.0));

      // Run inference
      _technicalInterpreter!.run(input, output);

      // Extract probability distribution
      final probabilities = output[0];

      // Calculate mean opinion score (MOS)
      // score = sum(probability[i] * (i + 1)) for i in 0..9
      double score = 0.0;
      for (int i = 0; i < outputSize; i++) {
        score += probabilities[i] * (i + 1);
      }

      return score;
    } catch (e) {
      print('Error running technical inference: $e');
      rethrow;
    }
  }

  /// Reshape flat Float32List to 4D tensor [1, 224, 224, 3]
  List<List<List<List<double>>>> _reshapeInputData(Float32List data) {
    final batch = <List<List<List<double>>>>[];
    final imageRows = <List<List<double>>>[];

    int pixelIndex = 0;
    for (int y = 0; y < inputSize; y++) {
      final row = <List<double>>[];
      for (int x = 0; x < inputSize; x++) {
        final pixel = <double>[
          data[pixelIndex++], // R
          data[pixelIndex++], // G
          data[pixelIndex++], // B
        ];
        row.add(pixel);
      }
      imageRows.add(row);
    }
    batch.add(imageRows);

    return batch;
  }

  /// Clean up and release model resources
  void dispose() {
    _aestheticInterpreter?.close();
    _technicalInterpreter?.close();
    _aestheticInterpreter = null;
    _technicalInterpreter = null;
  }

  /// Check if models are loaded and ready
  bool get isReady => _aestheticInterpreter != null && _technicalInterpreter != null;
}

