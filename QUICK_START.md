# Quick Start Guide

## 🚀 Running the App

```bash
# Navigate to project directory
cd /Users/ali/Projects/Flutter/best_image_selector

# Get dependencies (if not already done)
flutter pub get

# Run on connected device/emulator
flutter run

# Or run on specific device
flutter run -d <device-id>
```

## 📱 Using the App

### Step 1: Launch
- App starts with "Loading AI models..." screen
- Wait 2-3 seconds for models to load

### Step 2: Add Images
- Tap the **"Add Images"** floating button
- Choose source:
  - **Gallery**: Select multiple images (hold to multi-select)
  - **Camera**: Take a new photo

### Step 3: View Results
- Each image shows two scores:
  - 🔧 **Technical**: Image quality (sharpness, noise, etc.)
  - 🎨 **Aesthetic**: Visual appeal
- Scores range from 1.00 to 10.00
- Higher = better quality

### Step 4: Manage Images
- Tap **X** button to remove an image
- Add more images (up to 10 total)

## 🎯 What the Scores Mean

### Technical Score (1-10)
- **8-10**: Excellent technical quality
- **6-8**: Good quality
- **4-6**: Average quality
- **1-4**: Poor quality

Evaluates:
- Sharpness
- Noise levels
- Exposure
- Color accuracy
- Artifacts

### Aesthetic Score (1-10)
- **8-10**: Very aesthetically pleasing
- **6-8**: Pleasant to look at
- **4-6**: Neutral aesthetic
- **1-4**: Unappealing

Evaluates:
- Composition
- Color harmony
- Subject matter
- Visual appeal
- Artistic quality

## 🔧 Troubleshooting

### Models Not Loading
**Error**: "Failed to load models"
**Solution**: 
1. Ensure model files exist in `assets/models/`
2. Run `flutter clean && flutter pub get`
3. Tap "Retry" button

### Camera Not Working
**Error**: "Error capturing image"
**Solution**:
- Grant camera permissions in device settings
- Restart the app

### Image Selection Fails
**Error**: "Error picking images"
**Solution**:
- Grant photo library permissions
- Check if storage is accessible

### Analysis Takes Too Long
**Normal**: 1-3 seconds per image
**If longer**:
- Close other apps
- Try on a more powerful device
- Reduce image count

## 📊 Performance Tips

1. **Optimal Image Count**: 5-7 images for best performance
2. **Image Size**: Larger images take longer to preprocess
3. **Device**: Newer devices process faster
4. **Background Apps**: Close unnecessary apps

## 🎨 Best Practices

### For Best Results:
- Use well-lit photos
- Avoid blurry images
- Try various subjects (landscapes, portraits, objects)
- Compare similar images to see score differences

### Testing the Models:
1. Take a sharp, well-composed photo → Expect high scores
2. Take a blurry photo → Expect low technical score
3. Take a poorly composed photo → Expect low aesthetic score
4. Compare professional photos vs. casual snapshots

## 📸 Example Use Cases

### Photography Portfolio
- Analyze your photos
- Identify best shots
- Improve technical skills

### Social Media
- Choose best images to post
- Ensure quality before sharing
- Compare filter effects

### Photo Cleanup
- Find low-quality images
- Decide which photos to keep/delete
- Organize by quality

## 🐛 Known Limitations

1. **Maximum 10 images** per session
2. **CPU-only inference** (no GPU acceleration)
3. **Sequential processing** (one image at a time)
4. **Model size**: ~5MB each (10MB total)

## 💡 Tips

- **First run**: May take longer as models load
- **Subsequent runs**: Faster as models are cached
- **Memory**: Clear images if app slows down
- **Comparison**: Analyze similar images together

## 📞 Need Help?

Check these files:
- `README.md` - Full documentation
- `IMPLEMENTATION_SUMMARY.md` - Technical details
- `lib/` - Source code with comments

## 🎉 Enjoy!

Start analyzing your images and discover which ones are truly the best!

