# Summary: HeySanaModel (Manipur Tourism AI Helper)

Welcome! This document explains what **HeySanaModel** is, what it does, and how it works in very simple words.

---

## 1. What is this project?

Imagine a visitor wants to travel to Manipur. They have a certain budget, a specific number of days, and activities they enjoy (like trekking, boating, heritage, shopping, or wildlife).

**HeySanaModel** is a smart AI helper that analyzes their traveller profile and automatically recommends the perfect **place to visit in Manipur**:
- 🌊 **Loktak Lake** (Boating, floating phumdis & relaxation)
- 🌿 **Dzukou Valley** (Trekking, camping & scenic valleys)
- 🏰 **Kangla Fort** (Ancient historical palace & Sanamahi temple)
- 🦌 **Keibul Lamjao** (Floating national park & endangered Sangai deer)
- 🌸 **Shirui Hills** (Ukhrul mountain trekking & rare Shirui lilies)
- 🛍️ **Ima Keithel** (World-famous 500-year-old all-women market)

---

## 2. How does it work? (The 3 Easy Steps)

```text
[1. You update Manipur tourist records in CSV] 
                       ⬇
[2. GitHub automatically trains the AI model] 
                       ⬇
[3. Your mobile app uses the AI directly over the internet!]
```

### Step 1: The Tourist Data
You keep a simple table (a CSV file called `tourism_travellers.csv`) with records of past visitors:
- Their age
- How many days they stay
- Whether they travel Solo, with Friends, Family, or as a Couple
- Their preferred activity (Trekking, Boating, Wildlife, Shopping, etc.)
- Their budget
- The place they visited in Manipur

### Step 2: Automatic AI Training
Whenever you add new traveller records and push them to GitHub, GitHub Actions automatically trains the AI model and updates both `model.onnx` and `model.zip`.

### Step 3: Your Mobile App Recommends Places Instantly
The trained model is published on GitHub Releases and GitHub Raw. Your mobile app (built with Flutter or Android) downloads the latest model and predicts tourist destinations on-device without needing any backend server!

---

## 3. What is inside this folder?

- 📁 **`data/`**: Contains `tourism_travellers.csv` with Manipur tourist visit records.
- 📁 **`src/`**: Contains the C# computer code that teaches the AI.
- 📁 **`artifacts/`**: Contains the finished AI model files (`model.onnx` and `model.zip`).
- 📁 **`.github/`**: Instructions for GitHub to run the automatic training robot.
- 📁 **`example_dart/`**: Contains pure Dart test scripts to download the model and predict places.
- 📄 **`README.md`**: Technical guide for developers.
- 📄 **`summary.md`**: This simple guide for everyone!

---

## 4. How do you test it?

Run this in your terminal:
```bash
dart run example_dart/bin/predict.dart 24 4 Solo Trekking 160
```
It will instantly recommend **Dzukou Valley**!
