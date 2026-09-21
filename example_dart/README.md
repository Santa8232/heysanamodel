# HeySanaModel - Dart & Flutter Manipur Tourism Client

This directory contains Dart & Flutter client scripts for testing, evaluating, and integrating the **HeySanaModel** Manipur tourism place and curated trip combo recommendation system.

---

## 📂 Included Scripts

| Script | Purpose | Requirements |
| :--- | :--- | :--- |
| **`bin/predict.dart`** | **Instant Prediction CLI** — Accepts custom tourist profile parameters and predicts Manipur destinations with matching Curated Trip Plan Combos | Pure Dart SDK |
| **`bin/test_trip_plans.dart`** | **Trip Plan Dataset Validator** — Parses and validates `data/trip_plans.json` with a typed Dart `TripPlan` model class | Pure Dart SDK |
| **`bin/main.dart`** | **Flutter ONNX Runtime Reference** — Demonstrates downloading the model over HTTP and running on-device inference using `package:onnxruntime` | Flutter SDK |

---

## ⚡ 1. Instant Prediction CLI (`bin/predict.dart`)

This script lets you test predictions immediately from your terminal with customizable arguments for all 8 tourist dimensions.

### Usage:
```bash
dart run example_dart/bin/predict.dart <Age> <Days> <Type> <Activity> <Budget> [Season] [Fitness] [Stay]
```

### Parameter Options:
- **`Age`**: Age in years (e.g., `24`, `30`, `45`)
- **`Days`**: Trip duration in days (e.g., `1`, `3`, `5`)
- **`Type`**: `Solo` \| `Friends` \| `Family` \| `Couple`
- **`Activity`**: `Trekking` \| `Boating` \| `Wildlife` \| `Cultural` \| `Historical` \| `Shopping` \| `Adventure` \| `Nature` \| `Pottery` \| `Caving` \| `Waterfalls` \| `Gardens`
- **`Budget`**: Budget in USD (e.g., `50`, `160`, `220`, `420`)
- **`Season`** *(Optional)*: `Winter` \| `Spring` \| `Summer` \| `Autumn`
- **`Fitness`** *(Optional)*: `Relaxed` \| `Moderate` \| `Active`
- **`Stay`** *(Optional)*: `Resort` \| `Homestay` \| `Hotel` \| `Camping` \| `Farmstay`

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

# 5. Andro Cultural Village (Pottery / Relaxed / Homestay / Autumn):
dart run example_dart/bin/predict.dart 30 1 Solo Pottery 50 Autumn Relaxed Homestay

# 6. Tamenglong Caves & Cascades (Caving / Active / Camping / Winter):
dart run example_dart/bin/predict.dart 27 3 Solo Caving 220 Winter Active Camping

# 7. Sadu Chiru Waterfalls (Waterfalls / Moderate / Resort / Spring):
dart run example_dart/bin/predict.dart 35 2 Family Waterfalls 130 Spring Moderate Resort

# 8. Kakching Rose Gardens (Gardens / Relaxed / Farmstay / Winter):
dart run example_dart/bin/predict.dart 48 2 Family Gardens 120 Winter Relaxed Farmstay
```

### Sample Prediction Output:
```text
==================================================
   HeySanaModel - Manipur Place Recommendation    
==================================================
👤 Tourist Profile:
   - Age & Group:        30 yrs (Solo)
   - Duration:           1 Day(s)
   - Preferred Activity: Pottery
   - Travel Season:      Autumn
   - Fitness & Stay:     Relaxed pace | Homestay
   - Estimated Budget:   $50 USD (~₹4,250 INR)
--------------------------------------------------
📍 Recommended Place:   🌟 Andro Cultural Village 🌟
📊 Match Confidence:    18.2% Match
🏛️ District & Location: Imphal East District
✨ Place Highlights:    Centuries-old wheel-less coil pottery, sacred perpetual fire (Mei Houba), Santhei eco park brook
🗓️ Best Time to Visit:  September to May (Pleasant weather for craft workshops)
🍲 Local Food to Try:   Traditional fermented brews, Sekmai smoked snacks, organic hill vegetables
--------------------------------------------------
🗺️ Matching Trip Plan:  🎁 Andro Pottery & Countryside Craft Trail
   - Tagline:            Ancient Coil Pottery, Sacred Flame & Brookside Eco Park
   - Plan Duration:      1 Day(s)
   - Estimated Budget:   ₹1,800 - ₹2,800
   - Curated Stay:       🏡 Andro Village Clay Pottery Homestay
   - Dining Pick:        🍽️  Chakluk Indigenous Kitchen, Forage Organic Café
   - Package Highlights: Handmade coil pottery masterclass, witnessing ancient sacred fire, peaceful stroll by Santhei brook
==================================================
```

---

## 🧪 2. Trip Plan Validator (`bin/test_trip_plans.dart`)

Validates the full set of 8 curated combo packages from `data/trip_plans.json` using a strongly-typed Dart model:

```bash
dart run example_dart/bin/test_trip_plans.dart
```

---

## 📱 3. Flutter ONNX Runtime Integration (`bin/main.dart`)

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
