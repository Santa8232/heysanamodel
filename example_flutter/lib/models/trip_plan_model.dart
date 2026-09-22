class TripPlanModel {
  final int id;
  final String title;
  final String tagline;
  final int durationDays;
  final String travelStyle;
  final String difficulty;
  final String estimatedBudget;
  final String homestayName;
  final String restaurantsSummary;
  final String highlights;
  final String bestSeason;
  final String imageUrl;
  final String description;

  const TripPlanModel({
    required this.id,
    required this.title,
    required this.tagline,
    required this.durationDays,
    required this.travelStyle,
    required this.difficulty,
    required this.estimatedBudget,
    required this.homestayName,
    required this.restaurantsSummary,
    required this.highlights,
    required this.bestSeason,
    required this.imageUrl,
    required this.description,
  });

  factory TripPlanModel.fromJson(Map<String, dynamic> json) {
    return TripPlanModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      durationDays: json['duration_days'] as int? ?? 1,
      travelStyle: json['travel_style'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      estimatedBudget: json['estimated_budget'] as String? ?? '',
      homestayName: json['homestay_name'] as String? ?? '',
      restaurantsSummary: json['restaurants_summary'] as String? ?? '',
      highlights: json['highlights'] as String? ?? '',
      bestSeason: json['best_season'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

