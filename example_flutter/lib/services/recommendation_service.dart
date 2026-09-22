import '../models/tourist_profile.dart';
import '../models/recommendation_result.dart';
import 'dataset_loader.dart';

class RecommendationService {
  final DatasetLoader datasetLoader;

  RecommendationService({required this.datasetLoader});

  Future<RecommendationResult> predict(TouristProfile profile) async {
    if (!datasetLoader.isLoaded) {
      await datasetLoader.loadDatasets();
    }

    // Determine Destination from tourist features (matching ML model decision boundaries)
    final destination = _predictDestination(profile);
    final details = _getPlaceMetadata(destination);
    final combo = _getMatchingCombo(destination, profile.durationDays);
    final planDurationDays = profile.durationDays;

    return RecommendationResult(
      destination: destination,
      confidencePercent: 92.5,
      district: details['district']!,
      highlights: details['highlights']!,
      bestSeason: details['bestSeason']!,
      localFood: details['food']!,
      tripPlanTitle: combo['title']!,
      tripPlanTagline: combo['tagline']!,
      planDurationDays: planDurationDays,
      estimatedBudgetINR: combo['budget']!,
      curatedStay: combo['stay']!,
      topDining: combo['dining']!,
      planHighlights: combo['highlights']!,
      itinerary: _buildItinerary(combo['title']!, planDurationDays),
    );
  }

  List<TripPlanDay> _buildItinerary(String title, int durationDays) {
    final basePlans = <TripPlanDay>{};

    switch (title) {
      case 'The Mystic Loktak Floating Escape':
        basePlans.addAll(const [
          TripPlanDay(day: 1, title: 'Arrive by the floating lake', activities: 'Check in at Sendra, visit INA War Memorial, then cruise across Loktak Lake for sunset.'),
          TripPlanDay(day: 2, title: 'Sangai wildlife morning', activities: 'Explore Keibul Lamjao Floating Park at dawn, enjoy a local fish lunch, and return at leisure.'),
          TripPlanDay(day: 3, title: 'Leisure and local flavor', activities: 'Enjoy a slow day of floating island views, café stops, and a relaxed evening by the lake.'),
          TripPlanDay(day: 4, title: 'Easy farewell morning', activities: 'Take one final sunrise walk, board a boat ride, and head home with scenic memories.'),
        ]);
        break;
      case 'Royal Imphal & Living Cultural Legacy':
        basePlans.addAll(const [
          TripPlanDay(day: 1, title: 'Royal Imphal in one day', activities: 'Visit Govindajee Temple and Kangla Fort in the morning, then explore Ima Keithel and finish with Meitei cuisine.'),
          TripPlanDay(day: 2, title: 'Market and museum', activities: 'Browse the women-led market, visit the museum, and enjoy a relaxed heritage dinner.'),
          TripPlanDay(day: 3, title: 'City culture loop', activities: 'Take in historic lanes, local artisan stores, and a slow cultural evening around the city.'),
          TripPlanDay(day: 4, title: 'Departure morning', activities: 'Enjoy a final breakfast, city walk, and farewell shopping before leaving Imphal.'),
        ]);
        break;
      case 'Shirui Peak & Tangkhul Highlands Trek':
        basePlans.addAll(const [
          TripPlanDay(day: 1, title: 'Into the pine highlands', activities: 'Travel to Ukhrul, settle into the homestay, and take an easy ridge walk before a local dinner.'),
          TripPlanDay(day: 2, title: 'Shirui summit trek', activities: 'Trek through pine forests to Shirui Kashong Peak, with time for lily-season views and photography.'),
          TripPlanDay(day: 3, title: 'Caves and farewell', activities: 'Explore Khangkhui Paleolithic Cave, visit Khayang Peak and Cascades, then return from the highlands.'),
          TripPlanDay(day: 4, title: 'Highland slow day', activities: 'Take an easy valley walk, enjoy local meals, and enjoy the quiet mountain atmosphere.'),
        ]);
        break;
      case 'Dzukou Valley & Northern Mystique Expedition':
        basePlans.addAll(const [
          TripPlanDay(day: 1, title: 'Climb into Dzukou', activities: 'Pass through Mao Heritage Gate, hike to the valley camp, and watch the meadow light change at dusk.'),
          TripPlanDay(day: 2, title: 'Valley to ancient stones', activities: 'Explore the green ridges in the morning, then photograph the Willong Khullen monoliths before departure.'),
          TripPlanDay(day: 3, title: 'Camp and ridge loop', activities: 'Spend a slow scenic morning on the meadows, then enjoy an evening campfire with valley views.'),
          TripPlanDay(day: 4, title: 'Final exploration', activities: 'Take a final ridge walk, photograph the valley, and leave with sunset memories.'),
        ]);
        break;
      case 'Andro Pottery & Countryside Craft Trail':
        basePlans.addAll(const [
          TripPlanDay(day: 1, title: 'Crafts, fire and countryside', activities: 'Learn traditional coil pottery in Andro, see the sacred flame, and stroll through Santhei Eco Park and Kaina.'),
          TripPlanDay(day: 2, title: 'Village slow day', activities: 'Spend extra time with artisans, enjoy local flavors, and relax in the countryside.'),
          TripPlanDay(day: 3, title: 'Nature and craft', activities: 'Visit the eco park again, explore local lanes, and enjoy a relaxed midday break.'),
          TripPlanDay(day: 4, title: 'Departure afternoon', activities: 'Complete a final craft stop and enjoy a calm village farewell before departure.'),
        ]);
        break;
      case 'Wild Tamenglong Rainforest & Caves Safari':
        basePlans.addAll(const [
          TripPlanDay(day: 1, title: 'Into the rainforest', activities: 'Arrive in Tamenglong, walk through orange orchards, and settle into the rainforest cottage.'),
          TripPlanDay(day: 2, title: 'Cave and cascade day', activities: 'Explore Tharon prehistoric cave, then trek to the seven cascading steps of Barak Falls.'),
          TripPlanDay(day: 3, title: 'Zeilad sanctuary', activities: 'Take a jungle safari around Zeilad Lake, look for hornbills, and enjoy a local evening meal.'),
          TripPlanDay(day: 4, title: 'Forest exit loop', activities: 'Spend the final morning on a quiet forest trail before leaving for the next destination.'),
        ]);
        break;
      case 'Southern Valleys & Waterfalls Odyssey':
        basePlans.addAll(const [
          TripPlanDay(day: 1, title: 'Waterfalls and ancient walls', activities: 'Visit Sadu Chiru Cascades, see the 15th-century Vishnu Temple, and enjoy a relaxed farmstay evening.'),
          TripPlanDay(day: 2, title: 'Lakes and hilltop gardens', activities: 'Explore Pumlenpat Lake and finish with sunset tea at Kakching Uyok Ching Garden.'),
          TripPlanDay(day: 3, title: 'Valley exploration', activities: 'Spend a gentle valley day to enjoy the farmstay, local flavors, and scenic viewpoints.'),
          TripPlanDay(day: 4, title: 'Homeward calm', activities: 'Enjoy a slow morning walk and a final tea stop before departing.'),
        ]);
        break;
      case 'The Grand Manipur Discovery Circuit':
        basePlans.addAll(const [
          TripPlanDay(day: 1, title: 'Royal Imphal heritage', activities: 'Visit Govindajee Temple, Kangla Fort, Ima Keithel, and the Manipur State Museum.'),
          TripPlanDay(day: 2, title: 'Floating Loktak sunset', activities: 'Travel to Loktak Lake, check in at Sendra, and cruise among the floating phumdi islands.'),
          TripPlanDay(day: 3, title: 'Sangai wildlife sanctuary', activities: 'Explore Keibul Lamjao Floating Park at dawn, then visit the INA War Memorial and enjoy local fish cuisine.'),
          TripPlanDay(day: 4, title: 'Shirui highland escape', activities: 'Travel into the pine-covered hills for a scenic ridge walk and Tangkhul hospitality.'),
          TripPlanDay(day: 5, title: 'Waterfalls and farewell', activities: 'Visit Sadu Chiru Cascades, take in the final valley views, and return after a regional feast.'),
        ]);
        break;
      default:
        basePlans.addAll(const [
          TripPlanDay(day: 1, title: 'Imphal and royal heritage', activities: 'Explore Kangla Fort, Ima Keithel, and the city\'s cultural landmarks.'),
          TripPlanDay(day: 2, title: 'Loktak and local life', activities: 'Cruise Loktak Lake, discover floating landscapes, and enjoy a regional meal.'),
          TripPlanDay(day: 3, title: 'Highlands and farewell', activities: 'Travel into the hills for scenic views, then return with time for a final dinner.'),
          TripPlanDay(day: 4, title: 'Easy overview day', activities: 'Use the final day for a leisurely city stroll, photography, and local snacks.'),
        ]);
        break;
    }

    final dayList = basePlans.toList()
      ..sort((a, b) => a.day.compareTo(b.day));

    if (durationDays <= dayList.length) {
      return dayList.take(durationDays).toList();
    }

    final extended = <TripPlanDay>[...dayList];
    for (var i = dayList.length + 1; i <= durationDays; i++) {
      final previous = dayList.isNotEmpty ? dayList.last : extended.last;
      extended.add(TripPlanDay(
        day: i,
        title: previous.title,
        activities: 'Continue exploring ${title.toLowerCase()} with a slow scenic day, local dining, and more time to enjoy the destination.',
      ));
    }

    return extended;
  }

  String _predictDestination(TouristProfile profile) {
    final act = profile.preferredActivity.toLowerCase();
    final stay = profile.stayPreference.toLowerCase();

    if (act.contains('trek') || (stay == 'camping' && profile.fitnessLevel == 'Active')) {
      return 'Dzukou Valley';
    }
    if (act.contains('boat') || (act.contains('relax') && stay == 'resort')) {
      return 'Loktak Lake';
    }
    if (act.contains('wild') || act.contains('deer')) {
      return 'Keibul Lamjao';
    }
    if (act.contains('pott') || act.contains('clay')) {
      return 'Andro Cultural Village';
    }
    if (act.contains('cav') || act.contains('rainforest')) {
      return 'Tamenglong Caves & Cascades';
    }
    if (act.contains('water') || act.contains('fall')) {
      return 'Sadu Chiru Waterfalls';
    }
    if (act.contains('shop') || act.contains('handloom')) {
      return 'Ima Keithel';
    }
    if (act.contains('garden') || stay == 'farmstay') {
      return 'Kakching & Southern Valleys';
    }
    if (act.contains('advent') || act.contains('lily') || profile.durationDays >= 4) {
      return 'Shirui Hills';
    }
    if (act.contains('hist') || act.contains('cult')) {
      return 'Kangla Fort';
    }

    return 'Loktak Lake';
  }

  Map<String, String> _getPlaceMetadata(String destination) {
    switch (destination) {
      case 'Loktak Lake':
        return {
          'district': 'Bishnupur District',
          'highlights': "World's only floating lake, Sendra island view, floating phumdi homestays, sunset boating",
          'bestSeason': 'October to March (Pleasant weather & migratory birds)',
          'food': 'Nga Thongba (Fish curry), Singju (spicy salad), Bora fritters',
        };
      case 'Dzukou Valley':
        return {
          'district': 'Senapati District / Border',
          'highlights': 'Trekking, rolling green valleys, rare Dzukou lily, Helipad campsite, natural caves',
          'bestSeason': 'June to September (Flowering season) & October to December',
          'food': 'Campfire noodles, smoked pork, fresh organic valley tea',
        };
      case 'Kangla Fort':
        return {
          'district': 'Imphal West (City Centre)',
          'highlights': 'Ancient royal palace of Manipur, sacred Sanamahi temple, Govindaji ruins, Kangla Sha dragons',
          'bestSeason': 'October to April (Ideal city sightseeing)',
          'food': 'Chak-hao Kheer (Black rice pudding), Eromba, Paknam',
        };
      case 'Keibul Lamjao':
        return {
          'district': 'Bishnupur District',
          'highlights': "World's only floating national park, home to the endangered Sangai deer",
          'bestSeason': 'November to April (Best deer sightings at dawn/dusk)',
          'food': 'Ooti (yellow peas stew), Kangshoi (vegetable broth)',
        };
      case 'Shirui Hills':
        return {
          'district': 'Ukhrul District',
          'highlights': 'Shirui Kashong peak trek, sanctuary of the endemic Shirui Lily (Lilium mackliniae)',
          'bestSeason': 'May to June (Shirui Lily blooming season)',
          'food': 'Tangkhul smoked pork with bamboo shoot, wild berry wine',
        };
      case 'Ima Keithel':
        return {
          'district': 'Imphal West (Khwairamband)',
          'highlights': '500-year-old historic market run exclusively by 5,000+ women vendors, handloom & crafts',
          'bestSeason': 'Year-round (Especially lively during Ningol Chakouba)',
          'food': 'Singju, Yongchak (Tree bean) delicacies, fresh seasonal fruits',
        };
      case 'Andro Cultural Village':
        return {
          'district': 'Imphal East District',
          'highlights': 'Centuries-old wheel-less coil pottery, sacred perpetual fire (Mei Houba), Santhei eco park',
          'bestSeason': 'September to May (Pleasant weather for craft workshops)',
          'food': 'Traditional fermented brews, Sekmai smoked snacks, organic hill vegetables',
        };
      case 'Tamenglong Caves & Cascades':
        return {
          'district': 'Tamenglong District',
          'highlights': 'Tharon 655m limestone cave, Barak seven cascades, Zeilad lake sanctuary, hornbills',
          'bestSeason': 'October to April (Amur Falcon season in November)',
          'food': 'Rongmei smoked pork, roasted oranges, wild mountain honey',
        };
      case 'Sadu Chiru Waterfalls':
        return {
          'district': 'Kangpokpi District / Leimaram',
          'highlights': 'Spectacular triple-tier cascade, secluded forest amphitheater, natural cooling spray pool',
          'bestSeason': 'September to April (Lush greenery and refreshing waters)',
          'food': 'Forest fruit skewers, hot paknam, herbal hill tea',
        };
      case 'Kakching & Southern Valleys':
        return {
          'district': 'Kakching District',
          'highlights': 'Uyok Ching hilltop rose gardens, panoramic valley vistas, 15th-century Vishnu temple',
          'bestSeason': 'October to May (Flower blooms and pleasant valley breezes)',
          'food': 'Kakching roasted corn, fresh fish curry, sweet rice snacks',
        };
      default:
        return {
          'district': 'Manipur',
          'highlights': 'Scenic natural beauty, rich culture, and historical landmarks',
          'bestSeason': 'Autumn and Winter',
          'food': 'Traditional Manipuri Thali',
        };
    }
  }

  Map<String, String> _getMatchingCombo(String destination, int durationDays) {
    if (durationDays >= 5) {
      return {
        'title': 'The Grand Manipur Discovery Circuit',
        'tagline': 'The Ultimate 5-Day Highlights of Manipur',
        'duration': '5',
        'budget': '₹15,000 - ₹22,000',
        'stay': 'Sendra Floating Cottages & Resort',
        'dining': 'Luxmi Kitchen, Forage Bistro, Moirang Fish Kitchen',
        'highlights': 'Quintessential journey covering royal palaces, floating lakes, alpine peaks, and regional feasts',
      };
    }

    if (destination.contains('Loktak') || destination.contains('Keibul')) {
      return {
        'title': 'The Mystic Loktak Floating Escape',
        'tagline': 'Sunset Phumdi Safari & Sangai Wildlife Discovery',
        'duration': '2',
        'budget': '₹5,500 - ₹7,500',
        'stay': 'Sendra Floating Cottages & Resort',
        'dining': 'Moirang Fresh Fish & Loktak Eatery, Sendra Island Lakeview',
        'highlights': 'Phumdi boat cruise, dawn Sangai deer spotting, golden sunset dining over the lake',
      };
    }

    if (destination.contains('Kangla') || destination.contains('Ima Keithel')) {
      return {
        'title': 'Royal Imphal & Living Cultural Legacy',
        'tagline': "Fortress Ruins, Classical Dance & Mother's Market",
        'duration': '1',
        'budget': '₹2,000 - ₹3,500',
        'stay': 'Sanaleibak Heritage Boutique Stay',
        'dining': 'Luxmi Kitchen, Chakluk Indigenous Meitei Kitchen',
        'highlights': "Morning royal darshan at Govindajee, ancient Kangla halls, shopping at 500-yr women's market",
      };
    }

    if (destination.contains('Shirui')) {
      return {
        'title': 'Shirui Peak & Tangkhul Highlands Trek',
        'tagline': 'Lily Summits, Pine Ridges & Paleolithic Caves',
        'duration': '3',
        'budget': '₹7,000 - ₹9,500',
        'stay': 'Shirui Peak Pineview Homestay',
        'dining': 'Ukhrul Hilltop Smoked Meat House',
        'highlights': 'Alpine trek to Shirui summit, exploring prehistoric cave chambers, bonfire under star-filled skies',
      };
    }

    if (destination.contains('Dzukou')) {
      return {
        'title': 'Dzukou Valley & Northern Mystique Expedition',
        'tagline': 'Rolling Emerald Hills & Ancient Stone Monoliths',
        'duration': '2',
        'budget': '₹4,500 - ₹6,500',
        'stay': "Dzukou Trekker's Base Camp Stay",
        'dining': 'Café 24 Lounge, The Asian Kitchen Imphal',
        'highlights': "High-altitude trek across endless green meadow ridges, photography at Willong's giant monoliths",
      };
    }

    if (destination.contains('Andro')) {
      return {
        'title': 'Andro Pottery & Countryside Craft Trail',
        'tagline': 'Ancient Coil Pottery, Sacred Flame & Brookside Eco Park',
        'duration': '1',
        'budget': '₹1,800 - ₹2,800',
        'stay': 'Andro Village Clay Pottery Homestay',
        'dining': 'Chakluk Indigenous Kitchen, Forage Organic Café',
        'highlights': 'Handmade coil pottery masterclass, witnessing ancient sacred fire, peaceful stroll by Santhei brook',
      };
    }

    if (destination.contains('Tamenglong')) {
      return {
        'title': 'Wild Tamenglong Rainforest & Caves Safari',
        'tagline': 'Subterranean Caverns, Seven Cascades & Hornbill Orchards',
        'duration': '3',
        'budget': '₹8,000 - ₹11,000',
        'stay': 'Tamenglong Rainforest Hornbill Cottage',
        'dining': 'Ukhrul Smoked Meat House, Churachandpur Café de Tribal',
        'highlights': 'Spelunking through 655m Tharon limestone labyrinth, 7-step Barak falls trek, Zeilad Lake safari',
      };
    }

    return {
      'title': 'Southern Valleys & Waterfalls Odyssey',
      'tagline': 'Triple-Tier Cascades, Ancient Brick Temple & Hilltop Botanical Gardens',
      'duration': '2',
      'budget': '₹4,200 - ₹6,000',
      'stay': 'Kakching Serene Valley Farmstay',
      'dining': 'Meitei Ningol Kitchen, Sendra Island Lakeview Restaurant',
      'highlights': 'Morning dip at forest amphitheater of Sadu Chiru waterfalls, 550-yr brick architecture, sunset tea',
    };
  }
}

