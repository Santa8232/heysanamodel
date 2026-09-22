# example_dart

This directory contains the Dart-side helper scripts for testing and validating the HeySanaModel recommendation flow.

The CLI scripts let you evaluate a tourist profile and see which Manipur destination and trip plan are recommended.

---

## Included scripts

- `bin/main.dart` — runs a set of sample destination checks
- `bin/predict.dart` — predicts a destination from custom traveller inputs
- `bin/test_onnx.dart` — checks ONNX model loading and inference
- `bin/test_raw_url.dart` — verifies raw model download access
- `bin/test_trip_plans.dart` — validates trip-plan dataset structure

---

## Quick prediction example

```bash
dart run example_dart/bin/predict.dart 24 4 Solo Trekking 160 Summer Active Camping
```

Example profile inputs:

- Age: 24
- Duration: 4 days
- Type: Solo
- Activity: Trekking
- Budget: 160 USD
- Season: Summer
- Fitness: Active
- Stay: Camping

This resolves to a destination such as Dzukou Valley with a matching outdoor itinerary.

---

## Other useful commands

```bash
dart run example_dart/bin/main.dart
dart run example_dart/bin/test_onnx.dart
dart run example_dart/bin/test_trip_plans.dart
```

---

## Notes

These scripts are useful for validating the recommendation logic outside the Flutter UI and for checking model or dataset compatibility during development.
