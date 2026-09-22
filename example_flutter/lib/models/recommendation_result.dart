class RecommendationResult {
  final String destination;
  final double confidencePercent;
  final String district;
  final String highlights;
  final String bestSeason;
  final String localFood;

  // Matching Curated Trip Plan Combo
  final String tripPlanTitle;
  final String tripPlanTagline;
  final int planDurationDays;
  final String estimatedBudgetINR;
  final String curatedStay;
  final String topDining;
  final String planHighlights;
  final List<TripPlanDay> itinerary;

  const RecommendationResult({
    required this.destination,
    required this.confidencePercent,
    required this.district,
    required this.highlights,
    required this.bestSeason,
    required this.localFood,
    required this.tripPlanTitle,
    required this.tripPlanTagline,
    required this.planDurationDays,
    required this.estimatedBudgetINR,
    required this.curatedStay,
    required this.topDining,
    required this.planHighlights,
    required this.itinerary,
  });
}

class TripPlanDay {
  final int day;
  final String title;
  final String activities;

  const TripPlanDay({
    required this.day,
    required this.title,
    required this.activities,
  });
}

