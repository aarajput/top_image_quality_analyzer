# Best Image Selector

A Flutter app that analyzes image quality using TensorFlow Lite NIMA (Neural Image Assessment) models. The app allows users to select or capture up to 10 images and provides both technical and aesthetic quality scores for each image.

## Features

- 📸 **Image Selection**: Pick multiple images from gallery or capture from camera
- 🤖 **AI-Powered Analysis**: Uses two TensorFlow Lite models for quality assessment
  - Technical Quality Model: Evaluates technical aspects (sharpness, noise, etc.)
  - Aesthetic Quality Model: Evaluates aesthetic appeal
- 📊 **Real-time Scoring**: Displays scores from 1-10 for each image
- 🥇 **Best 3 Ranking**: Automatically identifies and displays top 3 images by average score
- 🎨 **Modern UI**: Clean, intuitive interface with grid layout
- ⚡ **Performance**: Background image preprocessing for smooth UX

## Algorithm & Metrics

This app uses **NIMA (Neural Image Assessment)**, a state-of-the-art deep learning approach that predicts image quality as humans perceive it. 

### Quick Overview

**Two Independent Models:**
1. **Technical Model** - Measures objective quality (sharpness, noise, exposure, color accuracy)
2. **Aesthetic Model** - Measures subjective appeal (composition, lighting, creativity, emotion)

**How Scoring Works:**
- Each model outputs a probability distribution over ratings 1-10
- Final score = Expected value (Mean Opinion Score)
- Formula: `MOS = Σ(probability[i] × (i + 1))` for i = 0 to 9
- Images ranked by average of both scores

**Why This Works:**
- Trained on 250,000+ images with human ratings
- Captures variance in human perception
- Separate technical/aesthetic dimensions
- More accurate than traditional metrics (PSNR, SSIM)

📖 **[Read Full Algorithm Explanation →](ALGORITHM_EXPLAINED.md)**  
Detailed documentation covering metrics, preprocessing, inference, scoring, and ranking.

## Models

The app uses NIMA-based TensorFlow Lite models:

1. **aesthetic_model.tflite** - Evaluates aesthetic quality
2. **technical_model.tflite** - Evaluates technical quality

Both models:
- Accept 224x224 RGB images
- Output a 10-class probability distribution (scores 1-10)
- Calculate Mean Opinion Score (MOS) using: `score = Σ(probability[i] × (i + 1))`

## Project Structure

```
lib/
├── main.dart                          # App entry point and initialization
├── models/
│   └── analyzed_image.dart           # Data model for images with scores
├── screens/
│   └── image_selector_screen.dart    # Main UI screen
├── services/
│   └── tflite_service.dart           # TensorFlow Lite model management
└── utils/
    └── image_preprocessor.dart       # Image preprocessing utilities

assets/
└── models/
    ├── aesthetic_model.tflite
    └── technical_model.tflite
```

## Dependencies

- `tflite_flutter: ^0.10.4` - TensorFlow Lite runtime
- `image_picker: ^1.0.7` - Image selection from gallery/camera
- `image: ^4.1.7` - Image manipulation and preprocessing

## How It Works

### 1. Model Loading
On app startup, both TensorFlow Lite models are loaded into memory:
```dart
await tfliteService.loadModels();
```

### 2. Image Preprocessing
Each selected image is preprocessed:
- Decoded from file
- Resized to 224×224 pixels
- Converted to RGB (alpha channel removed)
- Normalized to float32 values in range [0, 1]

### 3. Inference
Both models run inference on the preprocessed image:
```dart
final technicalScore = await tfliteService.runTechnicalInference(preprocessedData);
final aestheticScore = await tfliteService.runAestheticInference(preprocessedData);
```

### 4. Score Calculation
The output is a 10-element probability distribution. The final score is calculated as:
```dart
double score = 0.0;
for (int i = 0; i < 10; i++) {
  score += probabilities[i] * (i + 1);
}
```

### 5. Ranking (Best 3 Feature)
Images are ranked by their **average score**:
```dart
averageScore = (technicalScore + aestheticScore) / 2
```
The app automatically identifies the top 3 images:
- 🥇 **Rank 1**: Highest average score
- 🥈 **Rank 2**: Second highest
- 🥉 **Rank 3**: Third highest

## Running the App

### Prerequisites
- Flutter SDK (3.10.4 or higher)
- Android Studio / Xcode for mobile development
- TensorFlow Lite models in `assets/models/`

### Installation

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Platform-Specific Setup

#### iOS
Add to `ios/Podfile`:
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
```

#### Android
No additional setup required. The app uses Gradle Kotlin DSL and supports API level 21+.

## Usage

1. **Launch the app** - Models load automatically on startup
2. **Tap "Select or Capture Images"** button
3. **Choose source**:
   - Gallery: Select multiple images (up to 10)
   - Camera: Capture a new photo
4. **View results** - Scores appear below each image:
   - 🔧 Technical score
   - 🎨 Aesthetic score
   - ⭐ Average score
5. **View Best 3** - Tap the "View Best 3 Images" button to see top-ranked images
6. **Remove images** - Tap the X button on any image

## Technical Details

### Image Preprocessing
- Input format: Any standard image format (JPEG, PNG, etc.)
- Processing: Bilinear interpolation for resizing
- Output: Float32List of shape [224, 224, 3]
- Normalization: Pixel values divided by 255.0

### Model Inference
- Input tensor: [1, 224, 224, 3] (batch, height, width, channels)
- Output tensor: [1, 10] (batch, classes)
- Execution: Sequential (preprocessing in isolate, inference on main thread)

### Performance Optimizations
- Image preprocessing runs in background isolate
- Models loaded once at startup
- Efficient memory management with proper disposal

## Limitations

- Maximum 10 images per session
- Models must be compatible with TensorFlow Lite
- Inference runs on CPU (no GPU acceleration in this version)

## Documentation

- **[README.md](README.md)** - This file, project overview and quick start
- **[ALGORITHM_EXPLAINED.md](ALGORITHM_EXPLAINED.md)** - Detailed algorithm, metrics, and ranking explanation
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Technical implementation details
- **[BEST_3_FEATURE.md](BEST_3_FEATURE.md)** - Best 3 images ranking feature guide
- **[QUICK_START.md](QUICK_START.md)** - User guide and troubleshooting
- **[PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)** - High-level project structure

## Credits

Models sourced from:
- [TensorFlow Lite NIMA Implementation](https://github.com/SophieMBerger/TensorFlow-Lite-implementation-of-Google-NIMA)

Based on Google's NIMA (Neural Image Assessment) research:
- Paper: "NIMA: Neural Image Assessment" by Talebi & Milanfar (Google Research, 2018)
- [arXiv:1709.05424](https://arxiv.org/abs/1709.05424)

## License

This project is for educational and demonstration purposes.
