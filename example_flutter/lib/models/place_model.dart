class PlaceModel {
  final int id;
  final String name;
  final String region;
  final String category;
  final double durationMin;
  final String bestTime;
  final double entryFee;
  final String imageUrl;
  final String shortDescription;

  const PlaceModel({
    required this.id,
    required this.name,
    required this.region,
    required this.category,
    required this.durationMin,
    required this.bestTime,
    required this.entryFee,
    required this.imageUrl,
    required this.shortDescription,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      region: json['region'] as String? ?? '',
      category: json['category'] as String? ?? '',
      durationMin: (json['duration_min'] as num?)?.toDouble() ?? 60.0,
      bestTime: json['best_time'] as String? ?? '',
      entryFee: (json['entry_fee'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String? ?? '',
      shortDescription: json['short_description'] as String? ?? '',
    );
  }
}

