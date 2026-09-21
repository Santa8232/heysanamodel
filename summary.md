# Summary: HeySanaModel (Manipur Tourism AI Helper)

Welcome! This document explains what **HeySanaModel** is, what it does, and how it works in very simple words.

---

## 1. What is this project?

Imagine a visitor wants to travel to Manipur. They have a certain budget, a duration, travel group, preferred activity, season, fitness pace, and stay preference.

**HeySanaModel** is a smart AI helper that analyzes all 8 dimensions of their traveller profile and automatically recommends the perfect **place to visit in Manipur**:
- 🌊 **Loktak Lake** (Boating, floating phumdis & sendra island)
- 🌿 **Dzukou Valley** (Trekking, camping & scenic rolling valleys)
- 🏰 **Kangla Fort** (Ancient historical palace & Sanamahi temple)
- 🦌 **Keibul Lamjao** (Floating national park & endangered Sangai deer)
- 🌸 **Shirui Hills** (Ukhrul mountain trekking & rare Shirui lilies)
- 🛍️ **Ima Keithel** (World-famous 500-year-old all-women market)

It also gives them rich tourist details: **District/Location**, **Highlights**, **Best Season to Visit**, **Authentic Local Food to Try**, **Match Confidence %**, and **Cost converted to Indian Rupees (INR)**!

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

# 3. Test Keibul Lamjao (Wildlife, Winter, Moderate, Homestay):
dart run example_dart/bin/predict.dart 35 2 Family Wildlife 220 Winter Moderate Homestay
```
