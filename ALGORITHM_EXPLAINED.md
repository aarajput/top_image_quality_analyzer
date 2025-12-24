# Algorithm Explanation: How Image Quality Assessment Works

## Table of Contents

1. [Overview](#overview)
2. [The NIMA Architecture](#the-nima-architecture)
3. [Metrics Measured](#metrics-measured)
4. [Image Preprocessing Pipeline](#image-preprocessing-pipeline)
5. [Model Inference Process](#model-inference-process)
6. [Score Calculation Algorithm](#score-calculation-algorithm)
7. [Ranking System](#ranking-system)
8. [Complete Algorithm Flow](#complete-algorithm-flow)
9. [Mathematical Details](#mathematical-details)
10. [Why This Approach Works](#why-this-approach-works)

---

## Overview

This app uses **NIMA (Neural Image Assessment)**, a deep learning approach developed by Google Research for predicting image quality. Unlike traditional methods that output a single quality score, NIMA predicts a **probability distribution** over quality ratings, making it more robust and aligned with human perception.

### Key Innovation

NIMA doesn't just say "this image has quality 7.5" — it says "there's a 25% chance humans would rate this 7, 20% would rate it 8, 15% would rate it 6..." and then calculates the expected value.

---

## The NIMA Architecture

### Foundation Models

Our app uses **two independent NIMA models**:

1. **Technical Quality Model**

   - Based on pre-trained convolutional neural network (CNN)
   - Fine-tuned on the TID2013 dataset (technical image distortions)
   - Evaluates objective image quality factors

2. **Aesthetic Quality Model**
   - Same CNN architecture
   - Fine-tuned on the AVA dataset (Aesthetic Visual Analysis)
   - Evaluates subjective aesthetic appeal

### Why Two Models?

Technical quality and aesthetic appeal are **orthogonal dimensions**:

- A technically perfect image can be aesthetically boring
- An aesthetically pleasing image might have technical flaws (intentional blur, grain, etc.)

**Example**:

```
Image A (Sharp landscape):
  Technical: 9.2 (very sharp, low noise)
  Aesthetic: 5.1 (boring composition)

Image B (Artistic portrait with soft focus):
  Technical: 6.8 (intentional softness)
  Aesthetic: 8.9 (beautiful composition, emotion)
```

---

## Metrics Measured

### Technical Quality Metrics

The **technical model** evaluates objective quality factors:

#### 1. **Sharpness**

- Edge definition
- Focus accuracy
- Blur detection
- Resolution effectiveness

#### 2. **Noise Level**

- ISO noise
- Compression artifacts
- Color banding
- Grain patterns

#### 3. **Exposure**

- Brightness distribution
- Clipping (overexposure/underexposure)
- Dynamic range utilization
- Histogram balance

#### 4. **Color Accuracy**

- White balance
- Color cast
- Saturation levels
- Color space consistency

#### 5. **Compression Quality**

- JPEG artifacts
- Blocking effects
- Ringing artifacts
- Detail preservation

#### 6. **Distortions**

- Lens aberrations
- Perspective distortion
- Chromatic aberration
- Vignetting

### Aesthetic Quality Metrics

The **aesthetic model** evaluates subjective appeal factors:

#### 1. **Composition**

- Rule of thirds
- Leading lines
- Balance and symmetry
- Visual weight distribution
- Negative space usage

#### 2. **Subject Matter**

- Interest level
- Emotional impact
- Storytelling
- Subject clarity

#### 3. **Color Harmony**

- Color palette coherence
- Complementary colors
- Color psychology
- Mood and atmosphere

#### 4. **Lighting Quality**

- Direction and quality of light
- Shadows and highlights
- Mood creation
- Three-dimensionality

#### 5. **Creativity**

- Uniqueness
- Artistic expression
- Visual interest
- Innovation

#### 6. **Emotional Response**

- Viewer engagement
- Memorability
- Aesthetic pleasure
- Emotional resonance

---

## Image Preprocessing Pipeline

Before inference, each image undergoes standardized preprocessing:

### Step 1: Image Loading

```
Input: Image file (any format: JPEG, PNG, HEIC, etc.)
Process: Decode to raw pixel data
Output: Raw image buffer
```

### Step 2: Resizing

```
Input: Image of any size (e.g., 4000×3000)
Process: Bilinear interpolation resize
Output: 224×224 pixel image

Why 224×224?
- Standard CNN input size
- Balance between detail and computation
- Matches pre-training dimensions
```

**Algorithm**:

```dart
// Bilinear interpolation preserves image quality
resized_image = resize(original_image,
  width: 224,
  height: 224,
  interpolation: BILINEAR
)
```

### Step 3: RGB Extraction

```
Input: Image with possible alpha channel (RGBA)
Process: Extract only Red, Green, Blue channels
Output: RGB image (3 channels)

Why remove alpha?
- Models trained on RGB data
- Alpha channel not relevant for quality
- Reduces input dimensions
```

### Step 4: Normalization

```
Input: Pixel values in range [0, 255]
Process: Divide each value by 255.0
Output: Float32 values in range [0.0, 1.0]

Why normalize?
- Neural networks work best with small values
- Prevents gradient explosion during training
- Matches model training preprocessing
```

**Mathematical Formula**:

```
normalized_pixel = original_pixel / 255.0

Example:
  R = 180 → 0.7059
  G = 200 → 0.7843
  B = 150 → 0.5882
```

### Step 5: Tensor Reshaping

```
Input: Flat array of 150,528 values (224×224×3)
Process: Reshape to 4D tensor
Output: [1, 224, 224, 3]
  - 1: Batch size (single image)
  - 224: Height in pixels
  - 224: Width in pixels
  - 3: RGB channels
```

**Data Layout**:

```
Flat: [R₀,G₀,B₀, R₁,G₁,B₁, ..., R₅₀₁₇₅,G₅₀₁₇₅,B₅₀₁₇₅]
                    ↓
4D: [[[  [R₀,G₀,B₀],   [R₁,G₁,B₁], ..., [R₂₂₃,G₂₂₃,B₂₂₃]  ],  ← Row 0
      [  [R₂₂₄,G₂₂₄,B₂₂₄], ...                             ],  ← Row 1
      ...
      [  [...                         [R₅₀₁₇₅,G₅₀₁₇₅,B₅₀₁₇₅]]  ]]] ← Row 223
```

---

## Model Inference Process

### Neural Network Architecture

Both models use a similar CNN architecture:

```
Input Image [224×224×3]
     ↓
[Convolutional Layers]
  • Feature extraction
  • Pattern recognition
  • Hierarchical learning
     ↓
[Pooling Layers]
  • Spatial dimension reduction
  • Translation invariance
     ↓
[Fully Connected Layers]
  • High-level reasoning
  • Score prediction
     ↓
[Softmax Layer]
  • Convert to probabilities
  • Sum to 1.0
     ↓
Output: [P₁, P₂, P₃, P₄, P₅, P₆, P₇, P₈, P₉, P₁₀]
```

### What the Network Learns

The CNN learns to detect **patterns** at multiple scales:

**Low-level features** (early layers):

- Edges
- Corners
- Textures
- Colors

**Mid-level features** (middle layers):

- Shapes
- Objects
- Patterns
- Structures

**High-level features** (deep layers):

- Compositions
- Scenes
- Concepts
- Quality indicators

### Inference Execution

```python
# Pseudocode
def run_inference(preprocessed_image):
    # Input: [1, 224, 224, 3] tensor

    # Forward pass through neural network
    feature_maps = extract_features(preprocessed_image)

    # Global average pooling
    global_features = average_pool(feature_maps)

    # Fully connected layers
    quality_logits = fully_connected(global_features)

    # Softmax to get probabilities
    probabilities = softmax(quality_logits)

    # Output: [P₁, P₂, ..., P₁₀]
    return probabilities
```

### Output Interpretation

The model outputs a **10-element probability distribution**:

```
Output tensor shape: [1, 10]

Example output:
[0.01, 0.02, 0.05, 0.10, 0.15, 0.25, 0.20, 0.12, 0.07, 0.03]
 ↑     ↑     ↑     ↑     ↑     ↑     ↑     ↑     ↑     ↑
 P₁    P₂    P₃    P₄    P₅    P₆    P₇    P₈    P₉    P₁₀

Interpretation:
- 1% probability of rating 1 (terrible)
- 2% probability of rating 2 (very poor)
- 5% probability of rating 3 (poor)
- 10% probability of rating 4 (below average)
- 15% probability of rating 5 (average)
- 25% probability of rating 6 (above average) ← Peak
- 20% probability of rating 7 (good)
- 12% probability of rating 8 (very good)
- 7% probability of rating 9 (excellent)
- 3% probability of rating 10 (perfect)

Note: Probabilities sum to 1.0 (100%)
```

---

## Score Calculation Algorithm

### Mean Opinion Score (MOS)

The final quality score is the **expected value** of the probability distribution:

### Mathematical Formula

```
MOS = Σ (Pᵢ × Rᵢ)  for i = 1 to 10

Where:
  Pᵢ = Probability of rating i
  Rᵢ = Rating value i
  MOS = Mean Opinion Score
```

### Step-by-Step Calculation

```
Given probabilities: [0.01, 0.02, 0.05, 0.10, 0.15, 0.25, 0.20, 0.12, 0.07, 0.03]

MOS = (0.01 × 1) + (0.02 × 2) + (0.05 × 3) + (0.10 × 4) + (0.15 × 5) +
      (0.25 × 6) + (0.20 × 7) + (0.12 × 8) + (0.07 × 9) + (0.03 × 10)

    = 0.01 + 0.04 + 0.15 + 0.40 + 0.75 + 1.50 + 1.40 + 0.96 + 0.63 + 0.30

    = 6.14

Final Score: 6.14 / 10
```

### Implementation

```dart
double calculateMOS(List<double> probabilities) {
  double score = 0.0;

  for (int i = 0; i < 10; i++) {
    // Rating values are 1-10 (i+1)
    // probabilities[i] corresponds to rating (i+1)
    score += probabilities[i] * (i + 1);
  }

  return score; // Returns value between 1.0 and 10.0
}
```

### Why Use Expected Value?

**Traditional Approach** (single prediction):

```
Model says: "Quality = 6"
Problem: What if humans disagree?
```

**NIMA Approach** (distribution):

```
Model says: "25% say 6, 20% say 7, 15% say 5..."
Expected value: 6.14
Advantage: Captures uncertainty and human variance
```

### Score Precision

Scores are displayed with **2 decimal places**:

```
Raw: 6.142857...
Displayed: 6.14

Why 2 decimals?
- Meaningful precision
- Easy to compare
- Professional appearance
```

---

## Ranking System

### Average Score Calculation

Each image receives **three scores**:

1. **Technical Score** (T): From technical model
2. **Aesthetic Score** (A): From aesthetic model
3. **Average Score** (S): Combined metric

```
S = (T + A) / 2

Example:
  Technical: 7.23
  Aesthetic: 6.45
  Average: (7.23 + 6.45) / 2 = 6.84
```

### Why Use Average?

The average gives **equal weight** to both dimensions:

```
Scenario 1: Technically perfect, aesthetically boring
  T = 9.5, A = 4.5 → S = 7.0

Scenario 2: Balanced quality
  T = 7.0, A = 7.0 → S = 7.0

Scenario 3: Artistic but technically flawed
  T = 5.5, A = 8.5 → S = 7.0
```

All three have the **same average**, but different characteristics. Users can see both individual scores to understand why.

### Ranking Algorithm

**Step 1: Filter**

```
eligible_images = images.where(
  image => image.has_technical_score AND image.has_aesthetic_score
)
```

**Step 2: Calculate Averages**

```
for each image in eligible_images:
  image.average_score = (image.technical + image.aesthetic) / 2
```

**Step 3: Sort**

```
sorted_images = eligible_images.sort_by(
  score => score.average_score,
  order: DESCENDING
)
```

**Step 4: Select Top 3**

```
best_3 = sorted_images.take(3)

Result:
  Rank 1: Highest average score  🥇
  Rank 2: Second highest         🥈
  Rank 3: Third highest          🥉
```

### Sorting Algorithm Details

**Algorithm**: TimSort (Dart's default)

- **Time Complexity**: O(n log n)
- **Space Complexity**: O(n)
- **Stability**: Yes (maintains order for equal values)

**Example**:

```
Unsorted:
  Image A: 6.84
  Image B: 8.12
  Image C: 5.67
  Image D: 7.45
  Image E: 8.12 (same as B)

After sorting (descending):
  1. Image B: 8.12  🥇
  2. Image E: 8.12  🥈 (stable: maintains original order)
  3. Image D: 7.45  🥉
  (Image A: 6.84)
  (Image C: 5.67)
```

### Tie-Breaking

When images have **equal average scores**:

- Maintains insertion order (stable sort)
- Both displayed with equal ranking visually
- First in list appears first in dialog

---

## Complete Algorithm Flow

### End-to-End Process

```
┌─────────────────────────────────────────────────────────────┐
│ STEP 1: IMAGE SELECTION                                     │
│ User selects/captures image → File object                   │
└────────────────────┬────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────┐
│ STEP 2: PREPROCESSING (Background Isolate)                  │
│                                                              │
│ 2a. Load image bytes                                        │
│     File → Uint8List                                        │
│                                                              │
│ 2b. Decode image                                            │
│     Uint8List → Image object                                │
│                                                              │
│ 2c. Resize to 224×224                                       │
│     Image(W×H) → Image(224×224)                             │
│     Method: Bilinear interpolation                          │
│                                                              │
│ 2d. Extract RGB and normalize                               │
│     for each pixel(x,y):                                    │
│       R = pixel.red / 255.0                                 │
│       G = pixel.green / 255.0                               │
│       B = pixel.blue / 255.0                                │
│     Result: Float32List[150,528]                            │
│                                                              │
│ 2e. Reshape to 4D tensor                                    │
│     [150528] → [1][224][224][3]                             │
└────────────────────┬────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────┐
│ STEP 3: TECHNICAL MODEL INFERENCE (Main Thread)             │
│                                                              │
│ 3a. Load model interpreter                                  │
│     technical_model.tflite → Interpreter                    │
│                                                              │
│ 3b. Forward pass through CNN                                │
│     Input: [1, 224, 224, 3]                                 │
│     Process: Convolution, pooling, activation layers        │
│     Output: [1, 10] probability distribution                │
│                                                              │
│ 3c. Calculate technical MOS                                 │
│     T = Σ(Pᵢ × i) for i=1 to 10                            │
│     Example: T = 7.23                                       │
└────────────────────┬────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────┐
│ STEP 4: AESTHETIC MODEL INFERENCE (Main Thread)             │
│                                                              │
│ 4a. Use same preprocessed data                              │
│     Input: [1, 224, 224, 3]                                 │
│                                                              │
│ 4b. Forward pass through aesthetic CNN                      │
│     Different weights than technical model                  │
│     Output: [1, 10] probability distribution                │
│                                                              │
│ 4c. Calculate aesthetic MOS                                 │
│     A = Σ(Pᵢ × i) for i=1 to 10                            │
│     Example: A = 6.45                                       │
└────────────────────┬────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────┐
│ STEP 5: SCORE AGGREGATION                                   │
│                                                              │
│ Calculate average score:                                    │
│   S = (T + A) / 2                                           │
│   Example: S = (7.23 + 6.45) / 2 = 6.84                    │
│                                                              │
│ Store all three scores:                                     │
│   - Technical: 7.23                                         │
│   - Aesthetic: 6.45                                         │
│   - Average: 6.84                                           │
└────────────────────┬────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────┐
│ STEP 6: DISPLAY RESULTS                                     │
│                                                              │
│ Update UI with formatted scores:                            │
│   🔧 Technical: 7.23                                        │
│   🎨 Aesthetic: 6.45                                        │
│   ⭐ Average: 6.84                                          │
└────────────────────┬────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────────┐
│ STEP 7: RANKING (When requested)                            │
│                                                              │
│ 7a. Filter analyzed images                                  │
│     Keep only images with both scores                       │
│                                                              │
│ 7b. Sort by average score                                   │
│     Order: Descending (highest first)                       │
│     Algorithm: TimSort O(n log n)                           │
│                                                              │
│ 7c. Select top 3                                            │
│     Rank 1: Best[0]   🥇                                    │
│     Rank 2: Best[1]   🥈                                    │
│     Rank 3: Best[2]   🥉                                    │
│                                                              │
│ 7d. Display in dialog                                       │
│     Show large previews with all scores                     │
└─────────────────────────────────────────────────────────────┘
```

---

## Mathematical Details

### Probability Distribution Properties

The output probabilities form a valid **discrete probability distribution**:

```
Properties:
1. Non-negative: Pᵢ ≥ 0 for all i
2. Normalized: Σ Pᵢ = 1.0
3. Discrete: 10 discrete ratings
4. Unimodal: Usually peaks at one rating
```

### Expected Value Calculation

The MOS is the **expected value** of a discrete random variable:

```
E[X] = Σ xᵢ · P(X = xᵢ)

Where:
  X = Random variable (quality rating)
  xᵢ = Possible values (1, 2, 3, ..., 10)
  P(X = xᵢ) = Probability of rating xᵢ
```

### Score Range

```
Minimum possible score: 1.0
  When P₁ = 1.0, all others = 0
  MOS = 1.0 × 1 = 1.0

Maximum possible score: 10.0
  When P₁₀ = 1.0, all others = 0
  MOS = 1.0 × 10 = 10.0

Practical range: 3.0 - 8.5
  Real images rarely reach extremes
  Most fall in the middle range
```

### Distribution Shape Analysis

```
Sharp peak (high confidence):
  [0, 0, 0.05, 0.10, 0.15, 0.55, 0.10, 0.05, 0, 0]
  Model is confident: likely rating 6
  MOS ≈ 5.85

Broad distribution (uncertain):
  [0.05, 0.08, 0.12, 0.15, 0.20, 0.15, 0.12, 0.08, 0.03, 0.02]
  Model uncertain: could be 4, 5, or 6
  MOS ≈ 4.67

Bimodal (conflicting signals):
  [0, 0, 0.05, 0.30, 0.10, 0.05, 0.10, 0.30, 0.05, 0.05]
  Some say 4, others say 8
  MOS ≈ 6.00
```

---

## Why This Approach Works

### Advantages of NIMA

#### 1. **Aligned with Human Perception**

- Humans disagree on quality ratings
- Distribution captures this variance
- Expected value represents consensus

#### 2. **Robust to Edge Cases**

```
Ambiguous image:
  Traditional: Forced to pick single score
  NIMA: Shows distribution of opinions
```

#### 3. **Separation of Concerns**

```
Technical + Aesthetic independence:
  - Technical excellence ≠ aesthetic appeal
  - Both dimensions captured separately
  - Users see complete picture
```

#### 4. **Confidence Indication**

```
Sharp peak = High confidence
Broad distribution = Uncertainty
User can interpret accordingly
```

### Scientific Validation

The NIMA approach is based on:

- Published research: "NIMA: Neural Image Assessment" (Google, 2018)
- Trained on large datasets (AVA: 250,000+ images)
- Validated against human ratings
- Outperforms traditional metrics (PSNR, SSIM)

### Comparison with Traditional Metrics

```
PSNR (Peak Signal-to-Noise Ratio):
  ✗ Only measures pixel differences
  ✗ Doesn't match human perception
  ✗ No aesthetic consideration

SSIM (Structural Similarity Index):
  ✗ Better than PSNR but still limited
  ✗ No learning from human ratings
  ✗ No aesthetic assessment

NIMA (Neural Image Assessment):
  ✓ Learned from human ratings
  ✓ Captures perceptual quality
  ✓ Separate technical/aesthetic models
  ✓ Probability distribution output
  ✓ State-of-the-art accuracy
```

---

## Summary

### The Complete Algorithm in One Sentence

**"Preprocess the image to 224×224 RGB normalized tensor, pass it through two trained neural networks that output probability distributions over 1-10 ratings, calculate expected values (MOS) for technical and aesthetic scores, average them, and rank images by this combined metric."**

### Key Takeaways

1. **Two Models**: Technical quality (objective) + Aesthetic appeal (subjective)

2. **Preprocessing**: Resize → RGB → Normalize → Reshape

3. **Inference**: CNN forward pass → Probability distribution [P₁...P₁₀]

4. **Scoring**: MOS = Σ(Pᵢ × i) → Value between 1-10

5. **Ranking**: Average = (Technical + Aesthetic) / 2 → Sort descending

6. **Display**: Show top 3 with medals 🥇🥈🥉

### Performance Characteristics

```
Time Complexity:
  - Preprocessing: O(W × H) ≈ 1 second
  - Inference: O(1) ≈ 1 second per model
  - Scoring: O(10) = O(1) ≈ instant
  - Ranking: O(n log n) ≈ instant for n=10
  - Total per image: ~2-3 seconds

Space Complexity:
  - Model size: 5 MB each (10 MB total)
  - Image tensor: 224×224×3×4 bytes = 602 KB
  - Total: ~11 MB
```

---

## References

1. **NIMA Paper**: "NIMA: Neural Image Assessment" by Talebi & Milanfar (Google Research, 2018)

   - [arXiv:1709.05424](https://arxiv.org/abs/1709.05424)

2. **AVA Dataset**: "AVA: A Large-Scale Database for Aesthetic Visual Analysis"

   - 250,000+ images with aesthetic ratings

3. **TID2013 Dataset**: Tampere Image Database 2013

   - Technical quality assessment benchmark

4. **Implementation**: TensorFlow Lite models by Sophie Berger
   - [GitHub Repository](https://github.com/SophieMBerger/TensorFlow-Lite-implementation-of-Google-NIMA)

---

**This algorithm represents the state-of-the-art in automated image quality assessment, combining deep learning, human perception modeling, and practical engineering to deliver accurate, interpretable quality scores.**
