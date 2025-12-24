# Metrics & Ranking Summary

Quick reference guide for understanding how images are scored and ranked.

---

## 📊 Metrics Measured

### Technical Quality Metrics (Objective)

| Metric | What It Measures | Score Impact |
|--------|------------------|--------------|
| **Sharpness** | Focus quality, edge definition | High = Sharp, Low = Blurry |
| **Noise** | ISO noise, grain, artifacts | High = Clean, Low = Noisy |
| **Exposure** | Brightness, dynamic range | High = Well-exposed, Low = Over/under |
| **Color Accuracy** | White balance, color cast | High = Natural, Low = Color issues |
| **Compression** | JPEG artifacts, blocking | High = Clean, Low = Compressed |
| **Distortion** | Lens aberrations, perspective | High = Clean, Low = Distorted |

### Aesthetic Quality Metrics (Subjective)

| Metric | What It Measures | Score Impact |
|--------|------------------|--------------|
| **Composition** | Rule of thirds, balance, framing | High = Well-composed, Low = Poor layout |
| **Subject Matter** | Interest level, storytelling | High = Engaging, Low = Boring |
| **Color Harmony** | Color palette coherence | High = Harmonious, Low = Clashing |
| **Lighting** | Quality and direction of light | High = Beautiful light, Low = Flat/harsh |
| **Creativity** | Uniqueness, artistic expression | High = Creative, Low = Generic |
| **Emotion** | Viewer engagement, impact | High = Moving, Low = Unmemorable |

---

## 🎯 Score Ranges

```
┌─────────────────────────────────────────────────┐
│ Score │ Rating      │ Description              │
├─────────────────────────────────────────────────┤
│ 9-10  │ Excellent   │ Professional quality     │
│ 8-9   │ Very Good   │ High quality            │
│ 7-8   │ Good        │ Above average           │
│ 6-7   │ Decent      │ Acceptable quality      │
│ 5-6   │ Average     │ Typical snapshot        │
│ 4-5   │ Below Avg   │ Noticeable issues       │
│ 3-4   │ Poor        │ Significant problems    │
│ 1-3   │ Very Poor   │ Severe quality issues   │
└─────────────────────────────────────────────────┘
```

### Score Interpretation

**Technical Score:**
```
9.0+  → Magazine-quality sharpness and exposure
7-9   → Good amateur/semi-pro work
5-7   → Acceptable for casual use
<5    → Technical issues visible
```

**Aesthetic Score:**
```
9.0+  → Award-worthy composition and impact
7-9   → Visually pleasing and well-composed
5-7   → Decent but unremarkable
<5    → Composition/appeal issues
```

**Average Score:**
```
8.0+  → Excellent image, keep and share
7-8   → Good image, worth keeping
6-7   → Acceptable, situational use
<6    → Consider retaking or editing
```

---

## 🔢 Scoring Algorithm

### Step 1: Probability Distribution

Each model outputs probabilities for ratings 1-10:

```
Example Output:
Rating:  1    2    3    4    5    6    7    8    9   10
Prob:  0.01 0.02 0.05 0.10 0.15 0.25 0.20 0.12 0.07 0.03
                                  ↑
                            Peak at rating 6
```

### Step 2: Calculate Expected Value (MOS)

```
MOS = Σ (Probability[i] × Rating[i])

= (0.01×1) + (0.02×2) + (0.05×3) + (0.10×4) + (0.15×5) +
  (0.25×6) + (0.20×7) + (0.12×8) + (0.07×9) + (0.03×10)

= 0.01 + 0.04 + 0.15 + 0.40 + 0.75 + 1.50 + 1.40 + 0.96 + 0.63 + 0.30

= 6.14
```

### Step 3: Calculate Average

```
Technical Score (T): 7.23
Aesthetic Score (A): 6.45

Average Score (S) = (T + A) / 2
                  = (7.23 + 6.45) / 2
                  = 6.84
```

---

## 🏆 Ranking System

### How Images Are Ranked

```
Step 1: Filter
  ✓ Keep only fully analyzed images
  ✗ Skip images still processing
  ✗ Skip images with errors

Step 2: Calculate Average
  For each image:
    Average = (Technical + Aesthetic) / 2

Step 3: Sort Descending
  Order by average score (highest first)

Step 4: Select Top 3
  🥇 Rank 1: Highest score
  🥈 Rank 2: Second highest
  🥉 Rank 3: Third highest
```

### Example Ranking

```
┌──────────┬───────────┬───────────┬─────────┬──────┐
│ Image    │ Technical │ Aesthetic │ Average │ Rank │
├──────────┼───────────┼───────────┼─────────┼──────┤
│ Photo A  │   7.23    │   6.45    │  6.84   │  4th │
│ Photo B  │   8.56    │   7.89    │  8.23   │  🥇  │
│ Photo C  │   5.67    │   6.12    │  5.90   │  5th │
│ Photo D  │   7.45    │   7.23    │  7.34   │  🥉  │
│ Photo E  │   8.12    │   7.56    │  7.84   │  🥈  │
└──────────┴───────────┴───────────┴─────────┴──────┘

Best 3 Dialog Shows:
  1. Photo B (8.23) 🥇
  2. Photo E (7.84) 🥈
  3. Photo D (7.34) 🥉
```

---

## 🎨 Visual Score Display

### Main Grid View

```
┌─────────────────────┐
│                     │
│   [Image Preview]   │
│                     │
├─────────────────────┤
│ 🔧 Technical: 7.23 │  ← Objective quality
│ 🎨 Aesthetic: 6.45 │  ← Subjective appeal
│ ⭐ Average: 6.84   │  ← Combined score
└─────────────────────┘
```

### Best 3 Dialog

```
┌─────────────────────────────────┐
│ ⭐ Top 3 Best Images            │
├─────────────────────────────────┤
│                                 │
│ 🥇 Rank #1        ⭐ 8.23      │
│ ┌─────────────────────────────┐│
│ │                             ││
│ │     [Large Preview]         ││
│ │                             ││
│ └─────────────────────────────┘│
│ 🔧 Technical: 8.56              │
│ 🎨 Aesthetic: 7.89              │
│                                 │
│ 🥈 Rank #2        ⭐ 7.84      │
│ [...]                           │
│                                 │
│ 🥉 Rank #3        ⭐ 7.34      │
│ [...]                           │
└─────────────────────────────────┘
```

---

## 📈 Score Patterns

### High Technical, Low Aesthetic
```
Technical: 9.2  Aesthetic: 4.8  Average: 7.0

Typical characteristics:
• Perfectly sharp and exposed
• No noise or artifacts
• But: Boring composition
• But: Uninteresting subject
• Example: Test chart photo
```

### Low Technical, High Aesthetic
```
Technical: 5.5  Aesthetic: 8.8  Average: 7.2

Typical characteristics:
• Intentional soft focus
• Artistic grain
• But: Beautiful composition
• But: Emotional impact
• Example: Vintage-style portrait
```

### Balanced Quality
```
Technical: 7.8  Aesthetic: 7.6  Average: 7.7

Typical characteristics:
• Good sharpness
• Clean exposure
• Nice composition
• Engaging subject
• Example: Well-executed snapshot
```

### Both High
```
Technical: 9.1  Aesthetic: 8.9  Average: 9.0

Typical characteristics:
• Professional execution
• Excellent composition
• Proper technique
• Visual impact
• Example: Award-winning photo
```

---

## 🔍 Understanding Your Scores

### When Technical > Aesthetic (+2 or more)

**What it means:**
- Image is technically well-executed
- But composition/appeal is lacking

**How to improve:**
- Study composition rules
- Find better angles
- Wait for better light
- Choose more interesting subjects

### When Aesthetic > Technical (+2 or more)

**What it means:**
- Good eye for composition
- But technical execution needs work

**How to improve:**
- Use tripod for sharper images
- Learn exposure techniques
- Shoot in better light
- Use lower ISO

### When Both Are Low (<6)

**What it means:**
- Multiple issues present
- Needs significant improvement

**How to improve:**
- Review basic photography principles
- Check camera settings
- Practice more
- Study example images

### When Both Are High (>8)

**What it means:**
- Excellent work!
- Portfolio-worthy

**What to do:**
- Share it
- Print it
- Add to portfolio
- Analyze what worked

---

## 💡 Tips for Better Scores

### Boost Technical Score
1. **Use good light** - Avoid extreme shadows/highlights
2. **Focus carefully** - Ensure sharp focus on subject
3. **Steady camera** - Use tripod or fast shutter speed
4. **Low ISO** - Reduce noise
5. **Proper exposure** - Not too bright or dark
6. **Shoot RAW** - More editing flexibility

### Boost Aesthetic Score
1. **Rule of thirds** - Place subject off-center
2. **Leading lines** - Guide viewer's eye
3. **Frame subject** - Use natural frames
4. **Clean background** - Avoid distractions
5. **Golden hour** - Shoot during sunrise/sunset
6. **Tell a story** - Make it meaningful

### Boost Both
1. **Plan your shot** - Scout location first
2. **Study examples** - Learn from great photos
3. **Practice regularly** - More shots = better skills
4. **Get feedback** - Learn from critiques
5. **Experiment** - Try different techniques
6. **Edit thoughtfully** - Enhance, don't over-process

---

## 🎓 Example Scenarios

### Scenario 1: Landscape Photo

```
Input: Mountain landscape at golden hour

Expected scores:
  Technical: 7-9 (wide depth of field, good exposure)
  Aesthetic: 6-9 (depends on composition)
  
Tips to maximize:
  • Use tripod for sharpness
  • Include foreground interest
  • Wait for dramatic clouds
  • Use graduated ND filter
```

### Scenario 2: Portrait Photo

```
Input: Close-up portrait with shallow depth

Expected scores:
  Technical: 6-8 (some softness acceptable)
  Aesthetic: 7-9 (emotional connection)
  
Tips to maximize:
  • Catch light in eyes
  • Use soft, diffused lighting
  • Focus on eyes
  • Natural expression
```

### Scenario 3: Street Photography

```
Input: Candid street scene

Expected scores:
  Technical: 5-7 (fast shooting, varied conditions)
  Aesthetic: 6-9 (storytelling matters)
  
Tips to maximize:
  • Anticipate moments
  • Include context
  • Look for geometry
  • Capture emotion
```

### Scenario 4: Product Photo

```
Input: Clean product shot on white background

Expected scores:
  Technical: 8-10 (precision required)
  Aesthetic: 5-7 (clean but simple)
  
Tips to maximize:
  • Even lighting
  • Perfect focus
  • No shadows/reflections
  • Neutral white balance
```

---

## 🚀 Using Rankings to Improve

### Analyze Your Top 3

Ask yourself:
1. **What do they have in common?**
   - Lighting style?
   - Composition technique?
   - Subject type?

2. **What makes them different from lower-ranked?**
   - Better focus?
   - Better framing?
   - Better moment?

3. **Can you replicate the success?**
   - Identify the winning formula
   - Apply to future shots

### Compare Similar Images

Select images of same subject:
- Why did one score higher?
- What specific differences exist?
- Learn from the comparison

### Track Progress Over Time

- Save your scores
- Retake similar shots later
- Compare improvements
- Celebrate growth!

---

## 📚 Quick Reference Card

```
╔═══════════════════════════════════════════════════╗
║              SCORE QUICK REFERENCE                ║
╠═══════════════════════════════════════════════════╣
║ Technical Measures:                               ║
║   • Sharpness, Noise, Exposure                   ║
║   • Color, Compression, Distortion               ║
║                                                   ║
║ Aesthetic Measures:                               ║
║   • Composition, Subject, Colors                 ║
║   • Lighting, Creativity, Emotion                ║
║                                                   ║
║ Formula:                                          ║
║   MOS = Σ(probability[i] × rating[i])           ║
║   Average = (Technical + Aesthetic) / 2          ║
║                                                   ║
║ Ranking:                                          ║
║   Sort by Average (descending)                   ║
║   Show top 3 with medals                         ║
║                                                   ║
║ Score Ranges:                                     ║
║   9-10: Excellent    │ 5-6: Average              ║
║   8-9:  Very Good    │ 4-5: Below Avg            ║
║   7-8:  Good         │ 3-4: Poor                 ║
║   6-7:  Decent       │ 1-3: Very Poor            ║
╚═══════════════════════════════════════════════════╝
```

---

**For complete technical details, see [ALGORITHM_EXPLAINED.md](ALGORITHM_EXPLAINED.md)**

