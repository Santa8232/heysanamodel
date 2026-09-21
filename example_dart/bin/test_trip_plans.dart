import 'dart:convert';
import 'dart:io';

class TripPlan {
  final int id;
  final String title;
  final String tagline;
  final int durationDays;
  final String travelStyle;
  final String difficulty;
  final String estimatedBudget;
  final List<int> placeIds;
  final String placesSummary;
  final int homestayId;
  final String homestayName;
  final List<int> restaurantIds;
  final String restaurantsSummary;
  final String highlights;
  final String bestSeason;
  final String imageUrl;
  final String description;

  TripPlan({
    required this.id,
    required this.title,
    required this.tagline,
    required this.durationDays,
    required this.travelStyle,
    required this.difficulty,
    required this.estimatedBudget,
    required this.placeIds,
    required this.placesSummary,
    required this.homestayId,
    required this.homestayName,
    required this.restaurantIds,
    required this.restaurantsSummary,
    required this.highlights,
    required this.bestSeason,
    required this.imageUrl,
    required this.description,
  });

  factory TripPlan.fromJson(Map<String, dynamic> json) {
    return TripPlan(
      id: json['id'] as int,
      title: json['title'] as String,
      tagline: json['tagline'] as String,
      durationDays: json['duration_days'] as int,
      travelStyle: json['travel_style'] as String,
      difficulty: json['difficulty'] as String,
      estimatedBudget: json['estimated_budget'] as String,
      placeIds: (json['place_ids'] as List<dynamic>).map((e) => e as int).toList(),
      placesSummary: json['places_summary'] as String,
      homestayId: json['homestay_id'] as int,
      homestayName: json['homestay_name'] as String,
      restaurantIds: (json['restaurant_ids'] as List<dynamic>).map((e) => e as int).toList(),
      restaurantsSummary: json['restaurants_summary'] as String,
      highlights: json['highlights'] as String,
      bestSeason: json['best_season'] as String,
      imageUrl: json['image_url'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'tagline': tagline,
    'duration_days': durationDays,
    'travel_style': travelStyle,
    'difficulty': difficulty,
    'estimated_budget': estimatedBudget,
    'place_ids': placeIds,
    'places_summary': placesSummary,
    'homestay_id': homestayId,
    'homestay_name': homestayName,
    'restaurant_ids': restaurantIds,
    'restaurants_summary': restaurantsSummary,
    'highlights': highlights,
    'best_season': bestSeason,
    'image_url': imageUrl,
    'description': description,
  };
}

void main() {
  print('===============================================================');
  print('    🧪 Testing HeySanaModel Trip Plan Combos (Dart Test)      ');
  print('===============================================================\n');

  // Locate data/trip_plans.json
  final candidatePaths = [
    'data/trip_plans.json',
    '../data/trip_plans.json',
    '../../data/trip_plans.json',
  ];

  File? jsonFile;
  for (final path in candidatePaths) {
    final f = File(path);
    if (f.existsSync()) {
      jsonFile = f;
      break;
    }
  }

  if (jsonFile == null) {
    print('❌ Error: trip_plans.json not found in expected paths.');
    exit(1);
  }

  print('✅ Found dataset at: ${jsonFile.path}');
  final rawContent = jsonFile.readAsStringSync();
  final List<dynamic> jsonList = jsonDecode(rawContent);

  print('📦 Total Trip Plans in JSON: ${jsonList.length}');

  // Parse all into strongly-typed Dart objects
  final List<TripPlan> plans = [];
  for (final item in jsonList) {
    try {
      plans.add(TripPlan.fromJson(item as Map<String, dynamic>));
    } catch (e) {
      print('❌ Error parsing item: $e');
      exit(1);
    }
  }

  print('✅ Successfully parsed all ${plans.length} trip plans into Dart model classes!\n');

  // Display details of each plan
  print('---------------------------------------------------------------');
  print('📋 List of Curated Trip Plans:');
  print('---------------------------------------------------------------');
  for (final p in plans) {
    print('Trip #${p.id}: "${p.title}"');
    print('  📌 Tagline:     ${p.tagline}');
    print('  ⏱️  Duration:    ${p.durationDays} day(s) | Pace: ${p.difficulty}');
    print('  💰 Budget:      ${p.estimatedBudget}');
    print('  🌿 Style:       ${p.travelStyle}');
    print('  🏡 Homestay:    ${p.homestayName} (ID: ${p.homestayId})');
    print('  🍽️  Dining:      ${p.restaurantsSummary}');
    print('  📍 Places:      ${p.placesSummary}');
    print('  🗓️  Best Time:   ${p.bestSeason}');
    print('  ✨ Highlights:  ${p.highlights}');
    print('');
  }

  // Run validation checks
  print('---------------------------------------------------------------');
  print('🔍 Validation Checks:');
  print('---------------------------------------------------------------');

  bool allValid = true;

  // Check 1: Unique IDs
  final ids = plans.map((p) => p.id).toSet();
  if (ids.length == plans.length) {
    print('  [PASS] All trip IDs are unique (1 to ${plans.length}).');
  } else {
    print('  [FAIL] Duplicate trip IDs found!');
    allValid = false;
  }

  // Check 2: Non-empty place & restaurant IDs
  final emptyPlaces = plans.where((p) => p.placeIds.isEmpty).toList();
  final emptyRestaurants = plans.where((p) => p.restaurantIds.isEmpty).toList();
  if (emptyPlaces.isEmpty && emptyRestaurants.isEmpty) {
    print('  [PASS] All trip plans link to valid place and restaurant IDs.');
  } else {
    print('  [FAIL] Some trip plans are missing place or restaurant IDs.');
    allValid = false;
  }

  // Check 3: Valid Image URLs
  final invalidUrls = plans.where((p) => !p.imageUrl.startsWith('http')).toList();
  if (invalidUrls.isEmpty) {
    print('  [PASS] All ${plans.length} trip plans have valid HTTP/HTTPS image URLs.');
  } else {
    print('  [FAIL] Some trip plans have invalid image URLs.');
    allValid = false;
  }

  print('\n===============================================================');
  if (allValid) {
    print('🎉 ALL 3 CHECKS PASSED! Dataset is ready for Flutter & Backend.');
  } else {
    print('⚠️ Some checks failed. Please check errors above.');
  }
  print('===============================================================\n');
}
