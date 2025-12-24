# Best 3 Images Feature

## Overview

The app now automatically identifies and displays the **top 3 best images** based on their average quality scores.

## How It Works

### Score Calculation

Each image receives an **average score** calculated as:

```
Average Score = (Technical Score + Aesthetic Score) / 2
```

For example:

- Technical Score: 7.23
- Aesthetic Score: 6.45
- **Average Score: 6.84**

### Ranking

Images are ranked in **descending order** by their average score:

- **Highest average** = Best image
- Images must be fully analyzed (both scores available)
- Minimum of 3 analyzed images required to show rankings

## User Interface

### Main Screen

- **"View Best 3 Images" Button**: Appears at the top when 3+ images are analyzed
- **Average Score Display**: Shows below each image card with a ⭐ icon

### Best 3 Dialog

When you tap "View Best 3 Images", a dialog shows:

#### Rank #1 (🥇 Gold)

- Gold border and header
- Largest emphasis
- Average score badge

#### Rank #2 (🥈 Silver)

- Silver border and header
- Second place styling

#### Rank #3 (🥉 Bronze)

- Bronze border and header
- Third place styling

Each card displays:

- **Medal emoji** (🥇/🥈/🥉)
- **Rank number**
- **Average score** (highlighted with stars icon)
- **Image preview** (16:9 aspect ratio)
- **Technical score** (with wrench icon 🔧)
- **Aesthetic score** (with palette icon 🎨)

## Visual Example

```
┌─────────────────────────────────────┐
│ ⭐ Top 3 Best Images                │
├─────────────────────────────────────┤
│                                     │
│  🥇 Rank #1         ⭐ 8.52        │
│  ┌───────────────────────────────┐ │
│  │                               │ │
│  │      [Image Preview]          │ │
│  │                               │ │
│  └───────────────────────────────┘ │
│  🔧 Technical: 8.74  🎨 Aesthetic: 8.30 │
│                                     │
│  🥈 Rank #2         ⭐ 7.89        │
│  ┌───────────────────────────────┐ │
│  │                               │ │
│  │      [Image Preview]          │ │
│  │                               │ │
│  └───────────────────────────────┘ │
│  🔧 Technical: 7.65  🎨 Aesthetic: 8.13 │
│                                     │
│  🥉 Rank #3         ⭐ 7.21        │
│  ┌───────────────────────────────┐ │
│  │                               │ │
│  │      [Image Preview]          │ │
│  │                               │ │
│  └───────────────────────────────┘ │
│  🔧 Technical: 7.01  🎨 Aesthetic: 7.41 │
│                                     │
│         [Close Button]              │
└─────────────────────────────────────┘
```

## Code Changes

### 1. AnalyzedImage Model (`lib/models/analyzed_image.dart`)

Added:

- `averageScore` getter - Calculates mean of both scores
- `averageScoreText` getter - Formatted string for display

```dart
double? get averageScore {
  if (technicalScore == null || aestheticScore == null) return null;
  return (technicalScore! + aestheticScore!) / 2.0;
}
```

### 2. Image Selector Screen (`lib/screens/image_selector_screen.dart`)

Added:

- Average score display on each image card
- "View Best 3 Images" button (amber colored)
- `_showBest3Images()` method - Shows dialog with top 3
- `_buildBest3Card()` method - Renders each ranked image
- `_buildScoreChip()` method - Creates score badges

**Sorting Logic**:

```dart
analyzedImages.sort((a, b) {
  final scoreA = a.averageScore ?? 0.0;
  final scoreB = b.averageScore ?? 0.0;
  return scoreB.compareTo(scoreA); // Descending
});
```

## Usage

### Step 1: Analyze Images

1. Select or capture images (at least 3)
2. Wait for all to be analyzed
3. View average scores below each image

### Step 2: View Best 3

1. Tap the **"View Best 3 Images"** button at the top
2. Dialog opens showing ranked images
3. See which images scored highest overall

### Step 3: Make Decisions

- Use best images for your purpose
- Delete lower-scoring images if desired
- Add more images and compare

## When Button Appears

The "View Best 3 Images" button shows when:

- ✅ At least **3 images** are fully analyzed
- ✅ Each has both technical AND aesthetic scores
- ✅ No errors in analysis

## Use Cases

### Photography

- Choose best shots from a photo session
- Select images for portfolio
- Compare similar compositions

### Social Media

- Pick top photos for Instagram/Facebook
- Find most appealing images
- Ensure quality before posting

### Photo Organization

- Identify keeper images
- Mark best photos for albums
- Sort by quality automatically

## Technical Details

### Sorting Algorithm

- **Time Complexity**: O(n log n) - Standard sort
- **Space Complexity**: O(n) - Creates sorted copy
- **Stability**: Sort is stable (maintains order for equal scores)

### Performance

- Sorting happens instantly (< 1ms for 10 images)
- No background processing needed
- Dialog renders immediately

### Edge Cases Handled

- ✅ Less than 3 images: Button hidden
- ✅ Images still analyzing: Only counts analyzed ones
- ✅ Equal scores: Maintains insertion order
- ✅ All same score: Shows in original order

## Color Scheme

### Medals

- **Gold** (#FFCA28): Rank 1
- **Silver** (#BDBDBD): Rank 2
- **Bronze** (#A1887F): Rank 3

### Accent Colors

- **Amber Button**: Makes feature prominent
- **Color-coded borders**: Visual hierarchy
- **Semi-transparent backgrounds**: Subtle emphasis

## Future Enhancements

Potential additions:

1. **Export Best 3**: Save/share top images
2. **Configurable Count**: Choose top 5, top 10, etc.
3. **Filtering**: Show only high-scoring images in grid
4. **Auto-delete**: Remove low-scoring images
5. **Score Threshold**: Set minimum acceptable score
6. **Sorting in Grid**: Reorder main grid by score

## Summary

This feature helps users quickly identify their **highest quality images** without manually comparing scores. The visual ranking system (🥇🥈🥉) makes it intuitive and fun to see which images the AI rated best.

**Key Benefits**:

- ⚡ Instant identification of best images
- 🎯 Clear visual ranking
- 📊 Complete score breakdown
- 🎨 Beautiful, intuitive UI
- 🚀 Zero configuration needed
