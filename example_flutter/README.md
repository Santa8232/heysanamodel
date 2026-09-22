# example_flutter

This is the Flutter frontend for the HeySanaModel Manipur tourism recommender.

It uses a tourist profile to recommend a destination, a matching trip package, and a day-by-day itinerary timeline. The UI is designed to make travel suggestions easy to scan and understand at a glance.

---

## App flow

1. User selects or customizes a traveller profile.
2. The app calls the recommendation provider.
3. The provider loads the recommendation service.
4. The result screen renders:
   - destination and district
   - confidence score
   - highlights and local food
   - trip budget, stay, dining
   - timeline-based itinerary

---

## Run locally

```bash
cd example_flutter
flutter pub get
flutter run -d windows
```

You can also target Android, Linux, macOS, or Web depending on your machine.

---

## Main files

- `lib/main.dart` — app entry point and provider setup
- `lib/screens/home_screen.dart` — profile selection screen
- `lib/screens/result_screen.dart` — destination result and trip timeline
- `lib/providers/recommendation_provider.dart` — state management
- `lib/services/recommendation_service.dart` — recommendation and itinerary generation

---

## Timeline behavior

The recommendation screen shows days in sequence so the trip plan reads like a real journey, instead of a flat list of attributes. This is especially helpful for longer trip packages like the 4-day or 5-day circuit recommendations.

---

## Notes

This example app is a UI showcase and prototype for the recommender system, intended to demonstrate how AI-backed travel suggestions can be presented in a clean, tour-friendly interface.
