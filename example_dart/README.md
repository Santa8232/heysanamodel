# Flutter / Dart ONNX Model Client Tester

This project demonstrates how to load, download, and test the exported `model.onnx` file using `package:onnxruntime`.

---

## What the Script Does

1. **Local Model Detection:** First checks if `../artifacts/model.onnx` exists locally.
2. **GitHub Raw Fallback:** If not found locally, downloads the latest `model.onnx` over HTTP from your GitHub Raw URL.
3. **ONNX Runtime Initialization:** Initializes the ONNX runtime environment (`OrtEnv`) and creates an inference session.
4. **Tourist Profile Feature Tensor:** Prepares the 11-element feature vector:
   * Age: `30`
   * Duration (Days): `7`
   * Traveler Type (One-Hot): `[0, 1, 0, 0]` (*Family*)
   * Preferred Activity (One-Hot): `[0, 0, 1, 0]` (*Cultural*)
   * Budget (USD): `\$1500`
5. **Inference Execution:** Evaluates the `Features` input tensor and prints model prediction outputs.
6. **Resource Cleanup:** Releases all native tensor, session, and run options memory.

---

## Prerequisites

> [!NOTE]
> The `onnxruntime` package is a **Flutter plugin** that binds to native ONNX Runtime dynamic libraries (`.dylib` on macOS, `.so` on Android/Linux, `.dll` on Windows). It requires the **Flutter SDK**.

Ensure you have Flutter installed:
```bash
flutter --version
```

---

## How to Run

1. Navigate to the `example_dart` directory:
   ```bash
   cd /Users/santamayengbam/Desktop/heysanamodel/example_dart
   ```

2. Resolve dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   # In a Flutter project or CLI test runner
   flutter run -d macos
   ```

---

## Customizing the GitHub Raw URL

In [bin/main.dart](bin/main.dart), update `githubRawUrl` with your actual GitHub username once you push your repository:

```dart
const githubRawUrl =
    'https://raw.githubusercontent.com/santa8232/heysanamodel/main/artifacts/model.onnx';
```
