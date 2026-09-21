# HeySanaModel - Manipur Tourism Places & Trip Plan Combos AI Recommendation Model

This project trains a machine learning model using **ML.NET** (C#) on a **Manipur Tourism Visited Places Dataset** and exports it into **ONNX** format for cross-platform inference (e.g. Flutter mobile & desktop applications).

The model takes a comprehensive traveller profile (Age, Duration, Group Type, Activity, Budget, Season, Fitness Level, and Stay Preference) and automatically predicts the best **tourist destination in Manipur**, paired with a matching **Curated Trip Plan Combo Package** complete with homestay stays, authentic regional dining, and itinerary highlights!

---

## 📍 Manipur Tourist Destinations Covered (10 Destinations)

| Destination | District | Highlights | Best Season | Local Delicacies |
| :--- | :--- | :--- | :--- | :--- |
| **Loktak Lake** | Bishnupur | World's only floating lake, Sendra island view, floating phumdi homestays, sunset boating | Oct – Mar | Nga Thongba (Fish curry), Singju, Bora |
| **Dzukou Valley** | Senapati / Border | Trekking, rolling green valleys, rare Dzukou lily, Helipad campsite, natural caves | Jun – Sep / Oct – Dec | Campfire noodles, smoked pork, organic valley tea |
| **Kangla Fort** | Imphal West | Ancient royal palace of Manipur, sacred Sanamahi temple, Govindaji ruins, Kangla Sha | Oct – Apr | Chak-hao Kheer (Black rice pudding), Eromba, Paknam |
| **Keibul Lamjao** | Bishnupur | World's only floating national park, home to the endangered Sangai deer | Nov – Apr | Ooti (yellow peas), Kangshoi (vegetable stew) |
| **Shirui Hills** | Ukhrul | Shirui Kashong peak trek, sanctuary of the endemic Shirui Lily (*Lilium mackliniae*) | May – Jun | Tangkhul smoked pork with bamboo shoot, berry wine |
| **Ima Keithel** | Imphal West | 500-year-old historic market run exclusively by 5,000+ women vendors, handloom & crafts | Year-round | Singju, Yongchak (Tree bean) dishes, fresh fruit |
| **Andro Cultural Village** | Imphal East | Centuries-old wheel-less coil pottery, sacred perpetual flame (*Mei Houba*), Santhei eco park | Sep – May | Traditional fermented brews, Sekmai smoked snacks |
| **Tamenglong Caves & Cascades** | Tamenglong | Tharon 655m limestone cave, Barak 7 waterfalls, Zeilad lake sanctuary, hornbills | Oct – Apr | Rongmei smoked pork, roasted oranges, wild mountain honey |
| **Sadu Chiru Waterfalls** | Kangpokpi | Spectacular triple-tier cascade, secluded forest amphitheater, refreshing spray pool | Sep – Apr | Forest fruit skewers, hot paknam, herbal hill tea |
| **Kakching & Southern Valleys** | Kakching | Uyok Ching hilltop rose gardens, valley panoramas, 15th-century Vishnu temple | Oct – May | Kakching roasted corn, fresh fish curry, sweet rice snacks |

---

## 🗺️ Curated Trip Plan Combos (8 Packages)

Every AI recommendation pairs the tourist profile with a matching Curated Trip Plan Combo:

| ID | Trip Plan Title | Duration | Difficulty | Budget (INR) | Curated Stay | Top Dining Pick |
|:--:|:---|:---:|:---:|:---:|:---|:---|
| **1** | **The Mystic Loktak Floating Escape** | 2 Days | Easy | ₹5,500 - ₹7,500 | Sendra Floating Cottages & Resort | Moirang Fresh Fish & Loktak Eatery |
| **2** | **Royal Imphal & Living Cultural Legacy** | 1 Day | Easy | ₹2,000 - ₹3,500 | Sanaleibak Heritage Boutique Stay | Luxmi Kitchen, Chakluk Meitei Kitchen |
| **3** | **Shirui Peak & Tangkhul Highlands Trek** | 3 Days | Moderate | ₹7,000 - ₹9,500 | Shirui Peak Pineview Homestay | Ukhrul Hilltop Smoked Meat House |
| **4** | **Dzukou Valley & Northern Mystique Expedition** | 2 Days | Challenging | ₹4,500 - ₹6,500 | Dzukou Trekker's Base Camp Stay | Café 24 Lounge, The Asian Kitchen |
| **5** | **Andro Pottery & Countryside Craft Trail** | 1 Day | Easy | ₹1,800 - ₹2,800 | Andro Village Clay Pottery Homestay | Chakluk Indigenous Kitchen, Forage Café |
| **6** | **Wild Tamenglong Rainforest & Caves Safari** | 3 Days | Moderate–Challenging | ₹8,000 - ₹11,000 | Tamenglong Rainforest Hornbill Cottage | Ukhrul Smoked Meat House |
| **7** | **Southern Valleys & Waterfalls Odyssey** | 2 Days | Easy | ₹4,200 - ₹6,000 | Kakching Serene Valley Farmstay | Meitei Ningol Kitchen, Sendra Lakeview |
| **8** | **The Grand Manipur Discovery Circuit** | 5 Days | Moderate | ₹15,000 - ₹22,000 | Sendra Floating Cottages & Resort | Luxmi Kitchen, Forage Bistro, Classic Dining |

---

## Architecture & Workflow

```text
[data/tourism_travellers.csv (80 Records, 10 Destinations)]
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

# 5. Coil Pottery Workshop in Andro Village:
dart run example_dart/bin/predict.dart 30 1 Solo Pottery 50 Autumn Relaxed Homestay

# 6. Rainforest Caving Safari in Tamenglong:
dart run example_dart/bin/predict.dart 27 3 Solo Caving 220 Winter Active Camping

# 7. Waterfall Retreat at Sadu Chiru:
dart run example_dart/bin/predict.dart 35 2 Family Waterfalls 130 Spring Moderate Resort

# 8. Hilltop Rose Gardens in Kakching:
dart run example_dart/bin/predict.dart 48 2 Family Gardens 120 Winter Relaxed Farmstay
```

### 2. Test via .NET Directly:
```bash
dotnet run --project src/heysanamodel.csproj --configuration Release -- --predict 30 1 Solo Pottery 50 Autumn Relaxed Homestay
```

**Enriched Sample Output:**
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

## 🧠 Model Features & Architecture

* **Task:** Multiclass Classification
* **Algorithm:** SDCA Maximum Entropy (`SdcaMaximumEntropy`)
* **Target Label:** `VisitedPlace` (10 destinations: `Loktak Lake`, `Dzukou Valley`, `Kangla Fort`, `Keibul Lamjao`, `Shirui Hills`, `Ima Keithel`, `Andro Cultural Village`, `Tamenglong Caves & Cascades`, `Sadu Chiru Waterfalls`, `Kakching & Southern Valleys`)
* **8 Multi-Feature Inputs:**
  1. `Age` *(float, e.g. 26)*
  2. `DurationDays` *(float, e.g. 4)*
  3. `TravelerType` *(One-hot: `Solo`, `Friends`, `Family`, `Couple`)*
  4. `PreferredActivity` *(One-hot: `Trekking`, `Boating`, `Wildlife`, `Cultural`, `Historical`, `Shopping`, `Adventure`, `Nature`, `Pottery`, `Caving`, `Waterfalls`, `Gardens`)*
  5. `BudgetUSD` *(float, e.g. 200)*
  6. `Season` *(One-hot: `Winter`, `Spring`, `Summer`, `Autumn`)*
  7. `FitnessLevel` *(One-hot: `Relaxed`, `Moderate`, `Active`)*
  8. `StayPreference` *(One-hot: `Resort`, `Homestay`, `Hotel`, `Camping`, `Farmstay`)*

---

## 📁 Repository Datasets (`data/`)

| File | Format | Contents |
|:---|:---|:---|
| **`heysana.xlsx`** | Excel | Master spreadsheet containing all 6 interconnected sheets |
| **`tourism_travellers.csv`** | CSV | 80 balanced visitor records across 10 destinations |
| **`places.json`** | JSON | 30 Manipur destinations with GPS coordinates, hours, fees, categories |
| **`homestays.json`** | JSON | 10 verified homestays with prices, ratings, amenities, and contact info |
| **`restaurants.json`** | JSON | 12 authentic dining spots with cuisines, specialties, and hours |
| **`trip_plans.json`** | JSON | 8 curated trip combo packages linking places, stays, and dining |

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
