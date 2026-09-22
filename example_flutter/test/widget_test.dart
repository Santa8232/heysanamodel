import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:example_flutter/models/tourist_profile.dart';
import 'package:example_flutter/providers/recommendation_provider.dart';
import 'package:example_flutter/services/dataset_loader.dart';
import 'package:example_flutter/services/recommendation_service.dart';
import 'package:example_flutter/screens/home_screen.dart';

void main() {
  late RecommendationService service;
  late RecommendationProvider provider;

  setUp(() {
    service = RecommendationService(datasetLoader: DatasetLoader());
    provider = RecommendationProvider(recommendationService: service);
  });

  group('RecommendationProvider', () {
    test('loads Dzukou preset correctly', () {
      provider.loadPreset(TouristProfile.dzukouTrekker);
      expect(provider.profile.preferredActivity, 'Trekking');
      expect(provider.profile.stayPreference, 'Camping');
      expect(provider.profile.age, 24);
    });

    test('loads Loktak preset correctly', () {
      provider.loadPreset(TouristProfile.loktakBoating);
      expect(provider.profile.preferredActivity, 'Boating');
      expect(provider.profile.travelerType, 'Couple');
    });

    test('loads Kangla preset correctly', () {
      provider.loadPreset(TouristProfile.kanglaHeritage);
      expect(provider.profile.preferredActivity, 'Historical');
      expect(provider.profile.durationDays, 1);
    });

    test('loads Andro preset correctly', () {
      provider.loadPreset(TouristProfile.androPottery);
      expect(provider.profile.preferredActivity, 'Pottery');
      expect(provider.profile.season, 'Autumn');
    });

    test('updateAge modifies profile age', () {
      provider.updateAge(35);
      expect(provider.profile.age, 35);
    });

    test('updateDuration modifies profile duration', () {
      provider.updateDuration(5);
      expect(provider.profile.durationDays, 5);
    });

    test('reset clears the result', () {
      provider.reset();
      expect(provider.result, isNull);
    });
  });

  group('RecommendationService - Prediction Logic', () {
    test('predicts Dzukou Valley for Trekking activity', () async {
      final result = await service.predict(TouristProfile.dzukouTrekker);
      expect(result.destination, 'Dzukou Valley');
      expect(result.district, contains('Senapati'));
    });

    test('predicts Loktak Lake for Boating activity', () async {
      final result = await service.predict(TouristProfile.loktakBoating);
      expect(result.destination, 'Loktak Lake');
      expect(result.district, contains('Bishnupur'));
    });

    test('predicts Kangla Fort for Historical activity', () async {
      final result = await service.predict(TouristProfile.kanglaHeritage);
      expect(result.destination, 'Kangla Fort');
      expect(result.district, contains('Imphal'));
    });

    test('predicts Andro Cultural Village for Pottery activity', () async {
      final result = await service.predict(TouristProfile.androPottery);
      expect(result.destination, 'Andro Cultural Village');
      expect(result.tripPlanTitle, contains('Andro'));
    });

    test('result has valid trip plan with budget', () async {
      final result = await service.predict(TouristProfile.loktakBoating);
      expect(result.tripPlanTitle, isNotEmpty);
      expect(result.estimatedBudgetINR, contains('₹'));
      expect(result.planDurationDays, greaterThan(0));
    });

    test('keeps a 4-day trip timeline aligned to the selected duration', () async {
      final profile = TouristProfile(
        age: 28,
        durationDays: 4,
        travelerType: 'Couple',
        preferredActivity: 'Boating',
        budgetUSD: 250,
        season: 'Winter',
        fitnessLevel: 'Relaxed',
        stayPreference: 'Resort',
      );

      final result = await service.predict(profile);
      expect(result.planDurationDays, 4);
      expect(result.itinerary.length, 4);
    });
  });

  group('HomeScreen Widget', () {
    testWidgets('renders title and preset buttons', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => RecommendationProvider(
            recommendationService: RecommendationService(
              datasetLoader: DatasetLoader(),
            ),
          ),
          child: const MaterialApp(home: HomeScreen()),
        ),
      );

      expect(find.text('Manipur Tourism Recommender'), findsOneWidget);
      expect(find.text('🏔️ Dzukou Trek'), findsOneWidget);
      expect(find.text('🚣 Loktak Boating'), findsOneWidget);
      expect(find.text('🏛️ Kangla Heritage'), findsOneWidget);
      expect(find.text('🏺 Andro Pottery'), findsOneWidget);
    });

    testWidgets('renders Get Recommendation button', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => RecommendationProvider(
            recommendationService: RecommendationService(
              datasetLoader: DatasetLoader(),
            ),
          ),
          child: const MaterialApp(home: HomeScreen()),
        ),
      );

      expect(find.text('🌟 Get Recommendation'), findsOneWidget);
    });

    testWidgets('tapping preset chip updates selected activity', (
      tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => RecommendationProvider(
            recommendationService: RecommendationService(
              datasetLoader: DatasetLoader(),
            ),
          ),
          child: const MaterialApp(home: HomeScreen()),
        ),
      );

      // Tap the Loktak Boating preset
      await tester.tap(find.text('🚣 Loktak Boating'));
      await tester.pump();

      // Verify the Boating activity chip becomes selected
      final boatingChip = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, '🚣 Boating'),
      );
      expect(boatingChip.selected, isTrue);
    });
  });
}
