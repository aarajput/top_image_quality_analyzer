import 'dart:io';

/// Model class representing an analyzed image with its quality scores
class AnalyzedImage {
  /// The image file
  final File imageFile;

  /// Technical quality score (0-10)
  final double? technicalScore;

  /// Aesthetic quality score (0-10)
  final double? aestheticScore;

  /// Whether the image is currently being analyzed
  final bool isAnalyzing;

  /// Error message if analysis failed
  final String? error;

  AnalyzedImage({
    required this.imageFile,
    this.technicalScore,
    this.aestheticScore,
    this.isAnalyzing = false,
    this.error,
  });

  /// Create a copy with updated fields
  AnalyzedImage copyWith({
    File? imageFile,
    double? technicalScore,
    double? aestheticScore,
    bool? isAnalyzing,
    String? error,
  }) {
    return AnalyzedImage(
      imageFile: imageFile ?? this.imageFile,
      technicalScore: technicalScore ?? this.technicalScore,
      aestheticScore: aestheticScore ?? this.aestheticScore,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      error: error ?? this.error,
    );
  }

  /// Check if analysis is complete
  bool get isAnalyzed => technicalScore != null && aestheticScore != null;

  /// Get formatted technical score string
  String get technicalScoreText {
    if (error != null) return 'Error';
    if (isAnalyzing) return 'Analyzing...';
    if (technicalScore == null) return 'N/A';
    return technicalScore!.toStringAsFixed(2);
  }

  /// Get formatted aesthetic score string
  String get aestheticScoreText {
    if (error != null) return 'Error';
    if (isAnalyzing) return 'Analyzing...';
    if (aestheticScore == null) return 'N/A';
    return aestheticScore!.toStringAsFixed(2);
  }
}

