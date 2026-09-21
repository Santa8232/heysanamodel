# HeySanaModel - Manipur Tourism Places AI Recommendation Model

This project trains a machine learning model using **ML.NET** (C#) on a **Manipur Tourism Visited Places Dataset** and exports it into **ONNX** format for cross-platform inference (e.g. Flutter mobile & desktop applications).

The model takes a comprehensive traveller profile (Age, Duration, Group Type, Activity, Budget, Season, Fitness Level, and Stay Preference) and automatically predicts the best **tourist destination in Manipur** alongside rich travel recommendations!

---

## 📍 Manipur Tourist Destinations Covered

| Destination | District | Highlights | Best Season | Local Delicacies |
| :--- | :--- | :--- | :--- | :--- |
| **Loktak Lake** | Bishnupur | World's only floating lake, Sendra island view, floating phumdi homestays, sunset boating | Oct – Mar | Nga Thongba (Fish curry), Singju, Bora |
| **Dzukou Valley** | Senapati / Border | Trekking, rolling green valleys, rare Dzukou lily, Helipad campsite, natural caves | Jun – Sep / Oct – Dec | Campfire noodles, smoked pork, organic valley tea |
| **Kangla Fort** | Imphal West | Ancient royal palace of Manipur, sacred Sanamahi temple, Govindaji ruins, Kangla Sha | Oct – Apr | Chak-hao Kheer (Black rice pudding), Eromba, Paknam |
| **Keibul Lamjao** | Bishnupur | World's only floating national park, home to the endangered Sangai deer | Nov – Apr | Ooti (yellow peas), Kangshoi (vegetable stew) |
| **Shirui Hills** | Ukhrul | Shirui Kashong peak trek, sanctuary of the endemic Shirui Lily (*Lilium mackliniae*) | May – Jun | Tangkhul smoked pork with bamboo shoot, berry wine |
| **Ima Keithel** | Imphal West | 500-year-old historic market run exclusively by 5,000+ women vendors, handloom & crafts | Year-round | Singju, Yongchak (Tree bean) dishes, fresh fruit |

---

## Architecture & Workflow

```text
[data/tourism_travellers.csv (8 Multi-Feature Columns)]
                   │
                   ▼
[ML.NET Multi-Feature Pipeline (src/Program.cs)]
                   │
       ┌───────────┴───────────┐
       ▼                       ▼
artifacts/model.zip     artifacts/model.onnx
(ML.NET Native Model)   (Cross-Platform ONNX Model)
                               │
                               ▼
   [GitHub Actions CI/CD / Flutter Mobile App / Dart CLI]
```

When you push updates to GitHub, **GitHub Actions** (`.github/workflows/train.yml`) will automatically:
1. Train the model on the latest Manipur dataset with all 8 features.
2. Export the trained model as `model.onnx` (for Flutter) and `model.zip` (for .NET).
3. Commit `model.onnx` back to your repository so your Flutter app can fetch the latest model live from GitHub Raw!
4. Automatically publish `model.onnx` and `model.zip` to **GitHub Releases** for direct asset downloads.

---

## 📦 GitHub Releases & Direct Model Downloads

Pre-trained model artifacts are published directly to **[GitHub Releases](https://github.com/Santa8232/heysanamodel/releases)**:

| Model Asset | Format | Purpose | Direct Download Link |
| :--- | :--- | :--- | :--- |
| **`model.onnx`** | ONNX | Flutter, Android, iOS, Desktop inference | [Download Latest `model.onnx`](https://github.com/Santa8232/heysanamodel/releases/latest/download/model.onnx) |
| **`model.zip`** | ML.NET ZIP | .NET 8 / C# native model for backend services | [Download Latest `model.zip`](https://github.com/Santa8232/heysanamodel/releases/latest/download/model.zip) |

---

## 🔮 How to Test Predictions Instantly

You can test predictions using **Dart CLI** or **.NET**:

### 1. Test via Dart CLI:
```bash
# Default multi-feature test (Age 26, 4 Days, Friends, Trekking, $200, Summer, Active, Camping):
dart run example_dart/bin/predict.dart

# Custom predictions using all 8 features:
# Format: dart run example_dart/bin/predict.dart <Age> <Days> <Type> <Activity> <Budget> [Season] [Fitness] [Stay]

# 1. Trekking in Dzukou Valley:
dart run example_dart/bin/predict.dart 24 4 Solo Trekking 160 Summer Active Camping

# 2. Serene Boating in Loktak Lake:
dart run example_dart/bin/predict.dart 32 3 Couple Boating 270 Winter Relaxed Resort

# 3. Royal Heritage at Kangla Fort:
dart run example_dart/bin/predict.dart 45 1 Family Historical 80 Winter Relaxed Hotel

# 4. Mountain Adventure in Shirui Hills (Ukhrul):
dart run example_dart/bin/predict.dart 28 5 Friends Adventure 420 Spring Active Homestay

# 5. Wildlife Safari at Keibul Lamjao (Sangai Deer):
dart run example_dart/bin/predict.dart 35 2 Family Wildlife 220 Winter Moderate Homestay

# 6. Handloom Shopping at Ima Keithel:
dart run example_dart/bin/predict.dart 40 1 Family Shopping 180 Winter Relaxed Hotel
```

### 2. Test via .NET Directly:
```bash
dotnet run --project src/heysanamodel.csproj --configuration Release -- --predict 26 4 Friends Trekking 200 Summer Active Camping
```

**Enriched Sample Output:**
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

## 🧠 Model Features & Architecture

* **Task:** Multiclass Classification
* **Algorithm:** SDCA Maximum Entropy (`SdcaMaximumEntropy`)
* **Evaluation:** Micro Accuracy: ~85.7%, Macro Accuracy: ~80.0%, Log Loss: 0.335
* **Target Label:** `VisitedPlace` (`Loktak Lake`, `Dzukou Valley`, `Kangla Fort`, `Keibul Lamjao`, `Shirui Hills`, `Ima Keithel`)
* **8 Multi-Feature Inputs:**
  1. `Age` *(float, e.g. 26)*
  2. `DurationDays` *(float, e.g. 4)*
  3. `TravelerType` *(One-hot: `Solo`, `Friends`, `Family`, `Couple`)*
  4. `PreferredActivity` *(One-hot: `Trekking`, `Boating`, `Wildlife`, `Cultural`, `Historical`, `Shopping`, `Adventure`, `Nature`)*
  5. `BudgetUSD` *(float, e.g. 200)*
  6. `Season` *(One-hot: `Winter`, `Spring`, `Summer`, `Autumn`)*
  7. `FitnessLevel` *(One-hot: `Relaxed`, `Moderate`, `Active`)*
  8. `StayPreference` *(One-hot: `Resort`, `Homestay`, `Hotel`, `Camping`)*

---

## 🛠️ How to Retrain Locally

```bash
dotnet run --project src/heysanamodel.csproj --configuration Release
```

---

## 📱 Using the Model in Your Flutter App

Your Flutter app can download the latest model dynamically at startup from GitHub Raw or GitHub Releases:

### 1. Add dependencies to Flutter `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  path_provider: ^2.1.2
  onnxruntime: ^1.1.0
```

### 2. Live Model Download URLs:
- **Raw GitHub Link:**
  ```text
  https://raw.githubusercontent.com/Santa8232/heysanamodel/main/artifacts/model.onnx
  ```
- **GitHub Release Link:**
  ```text
  https://github.com/Santa8232/heysanamodel/releases/latest/download/model.onnx
  ```
