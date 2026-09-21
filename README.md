# HeySanaModel - Tourism Traveller ML Project

This project trains a machine learning model using **ML.NET** (C#) on a **Tourism Traveller Dataset** and exports it into **ONNX** format for cross-platform inference (e.g. Flutter mobile & desktop applications).

---

## Architecture & Workflow

```text
[data/tourism_travellers.csv]
       │
       ▼
[ML.NET Training Pipeline (src/Program.cs)]
       │
       ├──► artifacts/model.zip   (ML.NET Native Model)
       └──► artifacts/model.onnx  (Cross-Platform ONNX Model)
              │
              ▼
[GitHub Actions CI/CD / Flutter Client Application]
```

When you push updates to GitHub, **GitHub Actions** (`.github/workflows/train.yml`) will automatically:
1. Train the model on the latest dataset.
2. Export the trained model as `model.onnx` (for Flutter) and `model.zip` (for .NET).
3. Commit `model.onnx` back to your repository so your Flutter app can fetch the latest model live from GitHub Raw!

---

## Project Structure

```text
heysanamodel/
├── .github/
│   └── workflows/
│       └── train.yml            <-- Automated training workflow on GitHub Actions
├── data/
│   └── tourism_travellers.csv   <-- Dataset CSV file (Age, Budget, Activity, etc.)
├── src/
│   ├── heysanamodel.csproj      <-- C# project file (.NET 8 + ML.NET packages)
│   ├── TravellerData.cs         <-- C# input data schema
│   ├── TravellerPrediction.cs   <-- C# prediction result class
│   └── Program.cs               <-- Main ML.NET training & ONNX export pipeline
├── artifacts/
│   ├── model.onnx               <-- Trained ONNX model (for Flutter client inference)
│   └── model.zip                <-- Native ML.NET model
├── example_dart/                <-- Dart / Flutter ONNX client tester
│   ├── bin/main.dart            <-- Sample inference runner & GitHub Raw downloader
│   ├── pubspec.yaml             <-- Dependencies (onnxruntime, http, path)
│   └── README.md                <-- Client test instructions
├── .gitignore                   <-- Ignored build outputs (bin, obj, .dart_tool)
├── summary.md                   <-- High-level overview for non-technical users
└── README.md                    <-- This developer guide
```

---

## How to Build / Train the Model Locally

You can train and export the ONNX model locally on your machine at any time using the .NET 8 SDK.

### 1. Prerequisites
* **.NET 8 SDK**:
  ```bash
  # Check if installed
  dotnet --version
  ```
  *(If installed via `dotnet-install.sh`, use `~/.dotnet/dotnet`)*

### 2. Run Training & Export
From the repository root:

```bash
# Using global dotnet:
dotnet run --project src/heysanamodel.csproj --configuration Release

# Or using local ~/.dotnet installation:
~/.dotnet/dotnet run --project src/heysanamodel.csproj --configuration Release
```

**Output:**
* `artifacts/model.onnx` (ONNX model file for Flutter)
* `artifacts/model.zip` (ML.NET model file)

---

## Model Features & Architecture

* **Task:** Multiclass Classification
* **Algorithm:** SDCA Maximum Entropy (`SdcaMaximumEntropy`)
* **Target Label:** `PackageChosen` (`Basic`, `Standard`, `Premium`)
* **Input Features:**
  1. `Age` (float, e.g. `30.0`)
  2. `DurationDays` (float, e.g. `7.0`)
  3. `TravelerType` (One-hot encoded, 4 classes: `Solo`, `Friends`, `Family`, `Couple`)
  4. `PreferredActivity` (One-hot encoded, 4 classes: `Backpacking`, `Sightseeing`, `Adventure`, `Cultural`, `Relaxation`, `Luxury`)
  5. `BudgetUSD` (float, e.g. `1500.0`)
* **ONNX Tensor Input:**
  * Tensor Name: `Features`
  * Shape: `[1, 11]` (1 sample, 11 float features)

---

## How to Push to GitHub

To enable automated training in the cloud and host your model on GitHub:

```bash
cd /Users/santamayengbam/Desktop/heysanamodel
git init
git add .
git commit -m "Add HeySanaModel ML pipeline and artifacts"
git branch -M main
git remote add origin https://github.com/santa8232/heysanamodel.git
git push -u origin main
```

Once pushed, GitHub Actions automatically executes `.github/workflows/train.yml` on every push to `main`, retraining and committing `artifacts/model.onnx` back to the repository.

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

### 2. Flutter Dart Code (`main.dart`):

```dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:onnxruntime/onnxruntime.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Tourism ML Predictor')),
        body: Center(
          child: ElevatedButton(
            onPressed: loadAndRunModelFromGitHub,
            child: const Text('Load Model from GitHub Raw & Predict'),
          ),
        ),
      ),
    );
  }

  Future<void> loadAndRunModelFromGitHub() async {
    // 1. Direct GitHub Raw URL of model.onnx
    const modelUrl =
        'https://raw.githubusercontent.com/santa8232/heysanamodel/main/artifacts/model.onnx';

    print('Downloading latest model from GitHub...');
    final response = await http.get(Uri.parse(modelUrl));

    if (response.statusCode == 200) {
      // 2. Save ONNX bytes to temporary directory
      final tempDir = await getTemporaryDirectory();
      final modelPath = '${tempDir.path}/model.onnx';
      final file = File(modelPath);
      await file.writeAsBytes(response.bodyBytes);

      print('Model downloaded successfully to $modelPath!');

      // 3. Initialize ONNX Runtime in Flutter
      OrtEnv.instance.init();
      final sessionOptions = OrtSessionOptions();
      final session = OrtSession.fromFile(file, sessionOptions);

      // 4. Prepare Input Tensor [Age, Duration, TravelerType(4), PreferredActivity(4), Budget]
      final inputData = Float32List.fromList([
        30.0, // Age
        7.0,  // DurationDays
        0.0, 1.0, 0.0, 0.0, // TravelerType: Family
        0.0, 0.0, 1.0, 0.0, // PreferredActivity: Cultural
        1500.0 // BudgetUSD
      ]);
      final inputShape = [1, 11];

      final inputTensor = OrtValueTensor.createTensorWithDataList(inputData, inputShape);
      final runOptions = OrtRunOptions();
      final outputs = session.run(runOptions, {'Features': inputTensor});

      print('Inference completed! Outputs: ${outputs.length}');

      // Clean up
      inputTensor.release();
      runOptions.release();
      sessionOptions.release();
      session.release();
    } else {
      print('Failed to load model. Status code: ${response.statusCode}');
    }
  }
}
```

---

## Modifying the Dataset & Retraining

To update or improve the model:
1. Open `data/tourism_travellers.csv` and add or edit tourist data rows.
2. Either train locally:
   ```bash
   ~/.dotnet/dotnet run --project src/heysanamodel.csproj --configuration Release
   ```
3. Or push to GitHub:
   ```bash
   git add data/tourism_travellers.csv
   git commit -m "Update tourism dataset with new records"
   git push
   ```
   GitHub Actions will automatically retrain and update `artifacts/model.onnx`!
