# HeySanaModel - Manipur Tourism Places AI Recommendation Model

This project trains a machine learning model using **ML.NET** (C#) on a **Manipur Tourism Visited Places Dataset** and exports it into **ONNX** format for cross-platform inference (e.g. Flutter mobile & desktop applications).

The model takes a traveller profile (Age, Trip Duration, Group Type, Activity preference, and Budget) and automatically predicts the best **tourist destination in Manipur**!

---

## 📍 Manipur Tourist Destinations Covered

| Destination | Highlights | Ideal Traveller Profile |
| :--- | :--- | :--- |
| **Loktak Lake** | World's only floating lake, Sendra island, Phumdis, boating | Couples, Families (Relaxation & Boating) |
| **Dzukou Valley** | Iconic trekking trails, pristine rolling green hills, lilies, camping | Solo, Youth, Friends (Trekking & Adventure) |
| **Kangla Fort** | Ancient royal palace of Manipur, Sanamahi temple, heritage | Solo, Families (History, Culture & Architecture) |
| **Keibul Lamjao** | World's only floating national park, endangered Sangai deer | Families, Photographers, Wildlife enthusiasts |
| **Shirui Hills** | Ukhrul scenic peak, endemic Shirui Lily (*Lilium mackliniae*) | Friends, Couples, Trekkers (Scenic Mountain & Nature) |
| **Ima Keithel** | 500-year-old historic market operated exclusively by women | Culture lovers, Shoppers, Handloom & Local crafts |

---

## Architecture & Workflow

```text
[data/tourism_travellers.csv (Manipur Records)]
                   │
                   ▼
[ML.NET Training Pipeline (src/Program.cs)]
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
1. Train the model on the latest Manipur dataset.
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

You can test predictions right now using **Dart** or **.NET**:

### 1. Test via Dart CLI:
```bash
# Default sample test (Age 29, 3 Days, Couple, Boating, $250 -> Loktak Lake):
dart run example_dart/bin/predict.dart

# Custom Manipur tourist predictions:
# Trekking in Dzukou Valley:
dart run example_dart/bin/predict.dart 24 4 Solo Trekking 160

# Heritage visit to Kangla Fort:
dart run example_dart/bin/predict.dart 45 1 Family Historical 80

# Mountain adventure in Shirui Hills:
dart run example_dart/bin/predict.dart 28 5 Friends Adventure 420

# Shopping at Ima Keithel:
dart run example_dart/bin/predict.dart 40 1 Family Shopping 180
```

### 2. Test via .NET Directly:
```bash
dotnet run --project src/heysanamodel.csproj -- --predict 25 4 Solo Trekking 160
```

**Output:**
```text
==================================================
   HeySanaModel - Manipur Place Recommendation    
==================================================
👤 Tourist Profile:
   - Age:                25 years
   - Trip Duration:      4 days
   - Traveler Type:      Solo
   - Preferred Activity: Trekking
   - Budget:             $160 USD
--------------------------------------------------
📍 Recommended Place:   🌟 Dzukou Valley 🌟
==================================================
```

---

## Model Features & Architecture

* **Task:** Multiclass Classification
* **Algorithm:** SDCA Maximum Entropy (`SdcaMaximumEntropy`)
* **Accuracy:** 100.00% Micro/Macro Accuracy on test split
* **Target Label:** `VisitedPlace` (`Loktak Lake`, `Dzukou Valley`, `Kangla Fort`, `Keibul Lamjao`, `Shirui Hills`, `Ima Keithel`)
* **Input Features:**
  1. `Age` (float, e.g. `28.0`)
  2. `DurationDays` (float, e.g. `4.0`)
  3. `TravelerType` (One-hot encoded: `Solo`, `Friends`, `Family`, `Couple`)
  4. `PreferredActivity` (One-hot encoded: `Trekking`, `Boating`, `Cultural`, `Wildlife`, `Historical`, `Shopping`, `Camping`, `Nature`)
  5. `BudgetUSD` (float, e.g. `200.0`)

---

## How to Retrain Locally

```bash
dotnet run --project src/heysanamodel.csproj --configuration Release
```

---

## How to Use the Model in Your Flutter App (Raw GitHub Link)

Your Flutter app can download the latest model dynamically at startup from GitHub Raw over HTTP:

### 1. Add dependencies to your Flutter `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  path_provider: ^2.1.2
  onnxruntime: ^1.1.0
```

### 2. Live Model Download URL:

```text
https://raw.githubusercontent.com/Santa8232/heysanamodel/main/artifacts/model.onnx
```

Or from GitHub Releases:
```text
https://github.com/Santa8232/heysanamodel/releases/latest/download/model.onnx
```
