import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/recommendation_provider.dart';
import 'services/dataset_loader.dart';
import 'services/recommendation_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HeySanaModelApp());
}

class HeySanaModelApp extends StatelessWidget {
  const HeySanaModelApp({super.key});

  @override
  Widget build(BuildContext context) {
    final datasetLoader = DatasetLoader();
    final recommendationService = RecommendationService(
      datasetLoader: datasetLoader,
    );

    return ChangeNotifierProvider(
      create: (_) => RecommendationProvider(
        recommendationService: recommendationService,
      ),
      child: MaterialApp(
        title: 'HeySanaModel - Manipur Tourism',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32), // Forest green — Manipur hills
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
