import 'package:flutter/foundation.dart';
import '../models/tourist_profile.dart';
import '../models/recommendation_result.dart';
import '../services/recommendation_service.dart';

class RecommendationProvider extends ChangeNotifier {
  final RecommendationService recommendationService;

  TouristProfile _profile = TouristProfile.dzukouTrekker;
  RecommendationResult? _result;
  bool _isLoading = false;

  RecommendationProvider({required this.recommendationService});

  TouristProfile get profile => _profile;
  RecommendationResult? get result => _result;
  bool get isLoading => _isLoading;

  void loadPreset(TouristProfile preset) {
    _profile = preset;
    notifyListeners();
  }

  void updateAge(double age) {
    _profile = _profile.copyWith(age: age);
    notifyListeners();
  }

  void updateDuration(int days) {
    _profile = _profile.copyWith(durationDays: days);
    notifyListeners();
  }

  void updateTravelerType(String type) {
    _profile = _profile.copyWith(travelerType: type);
    notifyListeners();
  }

  void updateActivity(String activity) {
    _profile = _profile.copyWith(preferredActivity: activity);
    notifyListeners();
  }

  void updateBudget(double budget) {
    _profile = _profile.copyWith(budgetUSD: budget);
    notifyListeners();
  }

  void updateSeason(String season) {
    _profile = _profile.copyWith(season: season);
    notifyListeners();
  }

  void updateFitness(String fitness) {
    _profile = _profile.copyWith(fitnessLevel: fitness);
    notifyListeners();
  }

  void updateStay(String stay) {
    _profile = _profile.copyWith(stayPreference: stay);
    notifyListeners();
  }

  Future<void> generateRecommendation() async {
    _isLoading = true;
    notifyListeners();

    try {
      _result = await recommendationService.predict(_profile);
    } catch (e) {
      if (kDebugMode) {
        print('Error generating recommendation: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _result = null;
    notifyListeners();
  }
}

