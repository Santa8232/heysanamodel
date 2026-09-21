# Dart CLI ONNX Model Tester

This is a pure **Dart CLI application** (no Flutter required) to load and test the `model.onnx` file.

---

## How to Run

1. Open your terminal in the `example_dart` folder:
   ```bash
   cd /Users/santamayengbam/Desktop/heysanamodel/example_dart
   ```

2. Fetch dependencies:
   ```bash
   dart pub get
   ```

3. Run the Dart CLI application:
   ```bash
   dart run bin/main.dart
   ```

---

## What the Script Does

1. Checks if `artifacts/model.onnx` exists locally.
2. If not found locally, it automatically downloads `model.onnx` from your **GitHub Raw URL** over HTTP.
3. Initializes the ONNX Runtime engine in pure Dart.
4. Passes a sample tourist profile (Age: 30, Budget: $1500, Family, Cultural) into the ONNX model.
5. Prints the predicted package output.
