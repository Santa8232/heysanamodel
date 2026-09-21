# Summary: HeySanaModel (Manipur Tourism AI Helper)

Welcome! This document explains what **HeySanaModel** is, what it does, and how it works in very simple words.

---

## 1. What is this project?

Imagine a visitor wants to travel to Manipur. They have a certain budget, a duration, travel group, preferred activity, season, fitness pace, and stay preference.

**HeySanaModel** is a smart AI helper that analyzes all 8 dimensions of their traveller profile and automatically recommends the perfect **place to visit in Manipur** along with matching **Curated Trip Plan Combos**:
- 🌊 **Loktak Lake** (Boating, floating phumdis & sendra island)
- 🌿 **Dzukou Valley** (Trekking, camping & scenic rolling valleys)
- 🏰 **Kangla Fort** (Ancient historical palace & Sanamahi temple)
- 🦌 **Keibul Lamjao** (Floating national park & endangered Sangai deer)
- 🌸 **Shirui Hills** (Ukhrul mountain trekking & rare Shirui lilies)
- 🛍️ **Ima Keithel** (World-famous 500-year-old all-women market)
- 🏺 **Andro Cultural Village** (Ancient coil pottery & sacred perpetual flame)
- 🦇 **Tamenglong Caves & Cascades** (Tharon limestone cave, Barak falls & hornbills)
- 💦 **Sadu Chiru Waterfalls** (Triple-tier cascades & cooling mountain spray)
- 🌹 **Kakching & Southern Valleys** (Uyok Ching hilltop rose gardens & heritage)

It also gives them:
- **District/Location**, **Highlights**, **Best Season**, and **Local Food to Try**!
- 🗺️ **Matching Curated Trip Plan Combo**: Recommended package title, tagline, suggested homestay, dining spots, and package budget in INR!

---

## 2. How does it work? (The 3 Easy Steps)

```text
[1. You update Manipur tourist records in CSV with 8 features] 
                               ⬇
[2. GitHub automatically trains the AI model via GitHub Actions] 
                               ⬇
[3. Your Flutter mobile app downloads and runs the AI on device!]
```

### Step 1: The Multi-Feature Tourist Data
You keep a simple table (`data/tourism_travellers.csv`) with records of past visitors:
- **Age**: e.g., 26
- **Duration**: Days of stay (e.g., 4)
- **Group Type**: `Solo`, `Friends`, `Family`, `Couple`
- **Preferred Activity**: `Trekking`, `Boating`, `Wildlife`, `Shopping`, `Historical`, `Adventure`
- **Budget**: in USD (e.g., $200)
- **Season**: `Winter`, `Spring`, `Summer`, `Autumn`
- **Fitness Level**: `Relaxed`, `Moderate`, `Active`
- **Stay Preference**: `Resort`, `Homestay`, `Hotel`, `Camping`
- **Visited Place**: The actual Manipur destination!

### Step 2: Automatic AI Training
Whenever you push changes to GitHub, GitHub Actions automatically trains the AI model and updates both `model.onnx` and `model.zip`.

### Step 3: Mobile Apps Predict Instantly
The trained model is published to GitHub Releases and GitHub Raw. Your mobile app (Flutter / Android / iOS) downloads the model and makes instant offline recommendations without needing a backend server!

---

## 3. What is inside this folder?

- 📁 **`data/`**: Contains `tourism_travellers.csv` with 8-feature Manipur tourist visit records.
- 📁 **`src/`**: Contains C# ML.NET code that trains the model and generates predictions.
- 📁 **`artifacts/`**: Contains the exported models (`model.onnx` and `model.zip`).
- 📁 **`.github/`**: Workflow instructions for GitHub to automatically retrain the AI on every push.
- 📁 **`example_dart/`**: Ready-to-run Dart CLI script to test predictions with custom parameters.
- 📄 **`README.md`**: Complete technical guide for developers.
- 📄 **`summary.md`**: This friendly guide!

---

## 4. How do you test it?

Run any of these test commands in your terminal:

```bash
# 1. Test Dzukou Valley (Trekking, Summer, Active, Camping):
dart run example_dart/bin/predict.dart 24 4 Solo Trekking 160 Summer Active Camping

# 2. Test Loktak Lake (Boating, Winter, Relaxed, Resort):
dart run example_dart/bin/predict.dart 32 3 Couple Boating 270 Winter Relaxed Resort

# 3. Test Andro Cultural Village (Pottery, Autumn, Relaxed, Homestay):
dart run example_dart/bin/predict.dart 30 1 Solo Pottery 50 Autumn Relaxed Homestay

# 4. Test Tamenglong Rainforest (Caving, Winter, Active, Camping):
dart run example_dart/bin/predict.dart 27 3 Solo Caving 220 Winter Active Camping

# 5. Test Sadu Chiru Waterfalls (Waterfalls, Spring, Moderate, Resort):
dart run example_dart/bin/predict.dart 35 2 Family Waterfalls 130 Spring Moderate Resort
```

