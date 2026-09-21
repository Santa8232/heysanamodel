# Summary: HeySanaModel (Tourism AI Helper)

Welcome! This document explains what **HeySanaModel** is, what it does, and how it works in very simple words.

---

## 1. What is this project?

Imagine you run a travel company. When a tourist comes to you, you want to recommend the best travel package for them (like **Basic**, **Standard**, or **Premium**).

This project creates a **smart AI helper (Machine Learning model)** that looks at tourist information (like their age, budget, trip length, and favorite activity) and automatically guesses which travel package fits them best!

---

## 2. How does it work? (The 3 Easy Steps)

```text
[1. You update tourist data in CSV] 
       ⬇
[2. GitHub automatically trains the AI] 
       ⬇
[3. Your mobile app uses the AI directly over the internet!]
```

### Step 1: The Tourist Data
You keep a simple table (a CSV file called `tourism_travellers.csv`) with info about past tourists:
- How old they are
- How many days they stay
- How much money they want to spend
- What package they chose

### Step 2: Automatic AI Training
Whenever you add new tourist info to the file and send it to GitHub, GitHub automatically starts a robot (GitHub Actions). This robot teaches the AI model using your new information.

### Step 3: Your Phone App Gets Smart Automatically
After the AI is trained, it is saved on GitHub as a single file named `model.onnx`.
Your mobile app (built with Flutter) downloads this file from the internet when the app opens. You **never** have to manually copy files into your phone app!

---

## 3. What is inside this folder?

- 📁 **`data/`**: Contains `tourism_travellers.csv`, where all your tourist examples are saved.
- 📁 **`src/`**: Contains the C# computer code that teaches the AI.
- 📁 **`artifacts/`**: Contains the finished AI model file (`model.onnx`).
- 📁 **`.github/`**: Contains instructions for GitHub to run the automatic training robot.
- 📁 **`example_dart/`**: Contains sample code showing how a Flutter/Dart app can load and test the AI model.
- 📄 **`README.md`**: Technical guide for developers.
- 📄 **`summary.md`**: This simple guide for everyone!

---

## 4. How do you use it?

1. **Add new data**: Open `data/tourism_travellers.csv` and add new tourist records.
2. **Push to GitHub**: Save and send your changes to GitHub.
3. **Enjoy automatic updates**: GitHub trains the AI model automatically, and your Flutter mobile app gets updated instantly!
