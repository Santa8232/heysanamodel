# HeySanaModel - Tourism Traveller ML Project

This project trains a machine learning model using **ML.NET** (C#) on a **Tourism Traveller Dataset**.

When you push updates to GitHub, **GitHub Actions** will automatically:
1. Train the model on the latest dataset.
2. Export the trained model as `model.onnx` (for Flutter) and `model.zip` (for .NET).
3. Commit `model.onnx` back to your repository so your Flutter app can fetch it live!

---

## Project Structure

```text
heysanamodel/
├── .github/
│   └── workflows/
│       └── train.yml            <-- GitHub Actions workflow script
├── data/
│   └── tourism_travellers.csv   <-- Dataset CSV file
├── src/
│   ├── heysanamodel.csproj      <-- C# project file with ML.NET dependencies
│   ├── TravellerData.cs         <-- C# data schema for input features
│   ├── TravellerPrediction.cs   <-- C# prediction result class
│   └── Program.cs               <-- Main ML.NET training code
├── artifacts/
│   ├── model.onnx               <-- ONNX model (for Flutter app)
│   └── model.zip                <-- ML.NET model file
└── README.md                    <-- This guide
```

---

## How to Push to GitHub

Run these commands in your terminal to create your GitHub repository and push your project:

```bash
cd /Users/santamayengbam/Desktop/heysanamodel
git init
git add .
git commit -m "Initial commit of heysanamodel"
git branch -M main
git remote add origin https://github.com/<your-github-username>/heysanamodel.git
git push -u origin main
```

---

## How to Use the Model in Your Flutter App (Raw GitHub Link)

You do **not** need to download `model.onnx` manually. Your Flutter app can download the latest model dynamically at startup from GitHub Raw!

### 1. Add dependencies to `pubspec.yaml`:

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
        'https://raw.githubusercontent.com/<your-github-username>/heysanamodel/main/artifacts/model.onnx';

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

      print('ONNX Model Loaded Ready for Predictions!');
      session.release();
    } else {
      print('Failed to load model. Status code: ${response.statusCode}');
    }
  }
}
```

---

## Modifying the Dataset

To re-train the model anytime:
1. Open `data/tourism_travellers.csv` and edit or add rows.
2. Commit and push to GitHub:
   ```bash
   git add data/tourism_travellers.csv
   git commit -m "Updated tourism dataset"
   git push
   ```
3. GitHub Actions will automatically train the model and update `artifacts/model.onnx` on GitHub!
