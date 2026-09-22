# Summary

HeySanaModel helps travellers discover the best destinations in Manipur and pairs each recommendation with a matching curated trip plan.

The system uses tourist preference inputs to estimate the best-fit destination and then builds a travel package with a stay, food suggestions, highlights, and a recommended itinerary timeline.

---

## What the model predicts

It recommends from the following destinations:

- Loktak Lake
- Dzukou Valley
- Kangla Fort
- Keibul Lamjao
- Shirui Hills
- Ima Keithel
- Andro Cultural Village
- Tamenglong Caves & Cascades
- Sadu Chiru Waterfalls
- Kakching & Southern Valleys

---

## What the app shows

The Flutter app displays:

- destination and district
- confidence level
- best season
- local food recommendations
- budget, stay, dining, and highlights
- a day-by-day plan in a proper timeline

This is the main user-facing experience in the example Flutter app.

---

## How it works

1. A traveller profile is created from user input.
2. The ML model predicts the best destination.
3. A matching trip package is selected.
4. The UI shows the final recommendation and its travel timeline.

---

## Where the code lives

- Core ML project: [src](src)
- Model files: [artifacts](artifacts)
- Sample datasets: [data](data)
- Dart examples: [example_dart](example_dart)
- Flutter app: [example_flutter](example_flutter)

---

## Quick start

```bash
cd example_flutter
flutter pub get
flutter run -d windows
```

Or run the command-line demonstrations from the repository root:

```bash
dart run example_dart/bin/predict.dart 24 4 Solo Trekking 160 Summer Active Camping
```

---

## Current focus

The current app emphasis is on making the recommended trip plan readable and realistic in a timeline view so users can understand the day-by-day sequence instead of reading a single summary block.

