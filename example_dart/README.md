# HeySanaModel - Dart & Flutter Manipur Tourism Client

This directory contains Dart & Flutter client scripts for testing, evaluating, and integrating the **HeySanaModel** Manipur tourism place recommendation system.

---

## 📂 Included Scripts

| Script | Purpose | Requirements |
| :--- | :--- | :--- |
| **`bin/predict.dart`** | **Instant Prediction CLI** — Accepts custom tourist profile parameters and predicts Manipur destinations with rich details | Pure Dart SDK |
| **`bin/main.dart`** | **Flutter ONNX Runtime Reference** — Demonstrates downloading the model over HTTP and running on-device inference using `package:onnxruntime` | Flutter SDK |

---

## ⚡ 1. Instant Prediction CLI (`bin/predict.dart`)

This script lets you test predictions immediately from your terminal with customizable arguments for all 8 tourist dimensions.

### Usage:
```bash
dart run example_dart/bin/predict.dart <Age> <Days> <Type> <Activity> <Budget> [Season] [Fitness] [Stay]
```

### Parameter Options:
- **`Age`**: Age in years (e.g., `24`, `32`, `45`)
- **`Days`**: Trip duration in days (e.g., `1`, `3`, `5`)
- **`Type`**: `Solo` \| `Friends` \| `Family` \| `Couple`
- **`Activity`**: `Trekking` \| `Boating` \| `Wildlife` \| `Cultural` \| `Historical` \| `Shopping` \| `Adventure` \| `Nature`
- **`Budget`**: Budget in USD (e.g., `160`, `220`, `420`)
- **`Season`** *(Optional)*: `Winter` \| `Spring` \| `Summer` \| `Autumn`
- **`Fitness`** *(Optional)*: `Relaxed` \| `Moderate` \| `Active`
- **`Stay`** *(Optional)*: `Resort` \| `Homestay` \| `Hotel` \| `Camping`

### Example Test Commands:

```bash
# 1. Dzukou Valley (Trekking / Active / Camping / Summer):
dart run example_dart/bin/predict.dart 24 4 Solo Trekking 160 Summer Active Camping

# 2. Loktak Lake (Boating / Relaxed / Resort / Winter):
dart run example_dart/bin/predict.dart 32 3 Couple Boating 270 Winter Relaxed Resort

# 3. Kangla Fort (Historical / Relaxed / Hotel / Winter):
dart run example_dart/bin/predict.dart 45 1 Family Historical 80 Winter Relaxed Hotel

# 4. Shirui Hills (Mountain Adventure / Active / Homestay / Spring):
dart run example_dart/bin/predict.dart 28 5 Friends Adventure 420 Spring Active Homestay

# 5. Keibul Lamjao (Sangai Wildlife / Moderate / Homestay / Winter):
dart run example_dart/bin/predict.dart 35 2 Family Wildlife 220 Winter Moderate Homestay

# 6. Ima Keithel (Handloom Shopping / Relaxed / Hotel / Winter):
dart run example_dart/bin/predict.dart 40 1 Family Shopping 180 Winter Relaxed Hotel
```

### Sample Prediction Output:
```text
==================================================
   HeySanaModel - Manipur Place Recommendation    
==================================================
👤 Tourist Profile:
   - Age & Group:        26 yrs (Friends)
   - Duration:           4 Days
   - Preferred Activity: Trekking
   - Travel Season:      Summer
   - Fitness & Stay:     Active pace | Camping
   - Estimated Budget:   $200 USD (~₹17,000 INR)
--------------------------------------------------
📍 Recommended Place:   🌟 Dzukou Valley 🌟
📊 Match Confidence:    34.5% Match
🏛️ District & Location: Senapati District / Border
✨ Highlights:          Trekking, rolling green valleys, rare Dzukou lily, Helipad campsite, natural caves
🗓️ Best Time to Visit:  June to September (Flowering season) & October to December
🍲 Local Food to Try:   Campfire noodles, smoked pork, fresh organic valley tea
==================================================
```

---

## 📱 2. Flutter ONNX Runtime Integration (`bin/main.dart`)

To embed the pre-trained `model.onnx` directly into your Flutter app for real-time, offline on-device inference:

### 1. Add Dependencies to `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  path_provider: ^2.1.2
  onnxruntime: ^1.1.0
```

### 2. Fetch the Latest ONNX Model:
Your app can download the latest model binary at startup:
- **Raw GitHub Link:**
  ```text
  https://raw.githubusercontent.com/Santa8232/heysanamodel/main/artifacts/model.onnx
  ```
- **GitHub Release Link:**
  ```text
  https://github.com/Santa8232/heysanamodel/releases/latest/download/model.onnx
  ```

### 3. Run Inference:
```dart
import 'package:onnxruntime/onnxruntime.dart';

// Initialize ONNX environment
OrtEnv.instance.init();
final sessionOptions = OrtSessionOptions();
final session = OrtSession.fromFile(modelFile, sessionOptions);

// Prepare input tensor and evaluate
final outputs = session.run(runOptions, inputs);
```
