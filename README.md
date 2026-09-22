# HeySanaModel

HeySanaModel is a Manipur tourism recommendation project that combines a .NET ML pipeline with a Flutter UI to suggest destinations and curated trip plans.

The app predicts the most relevant place for a traveller based on profile inputs such as age, trip duration, traveler type, activity, budget, season, fitness level, and stay preference. It then pairs that recommendation with a matching trip plan, stay, dining picks, and a day-by-day itinerary timeline.

---

## What this project includes

- .NET ML training code in [src/Program.cs](src/Program.cs)
- ONNX model artifacts in [artifacts](artifacts)
- sample datasets in [data](data)
- Dart CLI examples in [example_dart](example_dart)
- Flutter app in [example_flutter](example_flutter)

---

## Recommendation flow

```text
Traveller profile
        ↓
ML.NET destination prediction
        ↓
Trip-plan matching logic
        ↓
Flutter result screen with timeline itinerary
```

The recommendation system currently covers key Manipur destinations such as:

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

## Flutter app features

The Flutter example app displays:

- destination and district summary
- confidence score
- best season and local food
- recommended trip plan
- budget, stay, dining, and highlights
- a proper chronological timeline for the selected trip

The result screen is designed to show a readable "Day 1, Day 2, ..." structure instead of a flat summary block.

---

## Project structure

```text
.
├── README.md
├── summary.md
├── data/
├── src/
├── artifacts/
├── example_dart/
├── example_flutter/
└── .github/
```

---

## Run the .NET model

```bash
dotnet run --project src/heysanamodel.csproj --configuration Release
```

---

## Run the Dart examples

From the repository root:

```bash
dart run example_dart/bin/predict.dart
```

With custom attributes:

```bash
dart run example_dart/bin/predict.dart 24 4 Solo Trekking 160 Summer Active Camping
```

---

## Run the Flutter app

```bash
cd example_flutter
flutter pub get
flutter run -d windows
```

Or use the desktop target you prefer, such as Linux, macOS, Android, or Web depending on your environment.

---

## Notes

- The recommendation engine and the Flutter timeline feature are now aligned around the selected trip duration.
- Each matched trip plan is converted into a day-by-day itinerary so the UI reflects the actual travel timeline more clearly.
- The project is intended as a demo and learning project for AI-based tourism recommendations, not as a production travel booking service.
