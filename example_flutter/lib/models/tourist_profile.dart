class TouristProfile {
  final double age;
  final int durationDays;
  final String travelerType;
  final String preferredActivity;
  final double budgetUSD;
  final String season;
  final String fitnessLevel;
  final String stayPreference;

  const TouristProfile({
    required this.age,
    required this.durationDays,
    required this.travelerType,
    required this.preferredActivity,
    required this.budgetUSD,
    required this.season,
    required this.fitnessLevel,
    required this.stayPreference,
  });

  TouristProfile copyWith({
    double? age,
    int? durationDays,
    String? travelerType,
    String? preferredActivity,
    double? budgetUSD,
    String? season,
    String? fitnessLevel,
    String? stayPreference,
  }) {
    return TouristProfile(
      age: age ?? this.age,
      durationDays: durationDays ?? this.durationDays,
      travelerType: travelerType ?? this.travelerType,
      preferredActivity: preferredActivity ?? this.preferredActivity,
      budgetUSD: budgetUSD ?? this.budgetUSD,
      season: season ?? this.season,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      stayPreference: stayPreference ?? this.stayPreference,
    );
  }

  // Pre-configured profiles for 1-click testing
  static const TouristProfile dzukouTrekker = TouristProfile(
    age: 24,
    durationDays: 4,
    travelerType: 'Solo',
    preferredActivity: 'Trekking',
    budgetUSD: 160,
    season: 'Summer',
    fitnessLevel: 'Active',
    stayPreference: 'Camping',
  );

  static const TouristProfile loktakBoating = TouristProfile(
    age: 32,
    durationDays: 3,
    travelerType: 'Couple',
    preferredActivity: 'Boating',
    budgetUSD: 270,
    season: 'Winter',
    fitnessLevel: 'Relaxed',
    stayPreference: 'Resort',
  );

  static const TouristProfile kanglaHeritage = TouristProfile(
    age: 45,
    durationDays: 1,
    travelerType: 'Family',
    preferredActivity: 'Historical',
    budgetUSD: 80,
    season: 'Winter',
    fitnessLevel: 'Relaxed',
    stayPreference: 'Hotel',
  );

  static const TouristProfile androPottery = TouristProfile(
    age: 30,
    durationDays: 1,
    travelerType: 'Solo',
    preferredActivity: 'Pottery',
    budgetUSD: 50,
    season: 'Autumn',
    fitnessLevel: 'Relaxed',
    stayPreference: 'Homestay',
  );
}

