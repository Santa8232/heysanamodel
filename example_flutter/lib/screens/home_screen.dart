import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tourist_profile.dart';
import '../providers/recommendation_provider.dart';
import 'result_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏔️ HeySanaModel'),
        centerTitle: true,
      ),
      body: Consumer<RecommendationProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'Manipur Tourism Recommender',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Select a preset or customize your travel profile',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Preset Buttons
                Text(
                  '⚡ Quick Presets',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _PresetChip(
                      label: '🏔️ Dzukou Trek',
                      profile: TouristProfile.dzukouTrekker,
                      isSelected: provider.profile.preferredActivity == 'Trekking',
                    ),
                    _PresetChip(
                      label: '🚣 Loktak Boating',
                      profile: TouristProfile.loktakBoating,
                      isSelected: provider.profile.preferredActivity == 'Boating',
                    ),
                    _PresetChip(
                      label: '🏛️ Kangla Heritage',
                      profile: TouristProfile.kanglaHeritage,
                      isSelected: provider.profile.preferredActivity == 'Historical',
                    ),
                    _PresetChip(
                      label: '🏺 Andro Pottery',
                      profile: TouristProfile.androPottery,
                      isSelected: provider.profile.preferredActivity == 'Pottery',
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Age Slider
                _SectionTitle(title: '👤 Age: ${provider.profile.age.round()}'),
                Slider(
                  value: provider.profile.age,
                  min: 18,
                  max: 70,
                  divisions: 52,
                  label: provider.profile.age.round().toString(),
                  onChanged: provider.updateAge,
                ),
                const SizedBox(height: 16),

                // Duration
                _SectionTitle(title: '📅 Duration (Days)'),
                const SizedBox(height: 8),
                _ChipSelector<int>(
                  items: const [1, 2, 3, 4, 5],
                  labels: const ['1 Day', '2 Days', '3 Days', '4 Days', '5 Days'],
                  selected: provider.profile.durationDays,
                  onSelected: provider.updateDuration,
                ),
                const SizedBox(height: 16),

                // Traveler Type
                _SectionTitle(title: '👥 Traveler Type'),
                const SizedBox(height: 8),
                _ChipSelector<String>(
                  items: const ['Solo', 'Couple', 'Family', 'Friends'],
                  labels: const ['Solo', 'Couple', 'Family', 'Friends'],
                  selected: provider.profile.travelerType,
                  onSelected: provider.updateTravelerType,
                ),
                const SizedBox(height: 16),

                // Activity
                _SectionTitle(title: '🎯 Preferred Activity'),
                const SizedBox(height: 8),
                _ChipSelector<String>(
                  items: const [
                    'Trekking', 'Boating', 'Historical', 'Wildlife',
                    'Adventure', 'Shopping', 'Pottery', 'Caving',
                    'Waterfalls', 'Gardens',
                  ],
                  labels: const [
                    '🥾 Trekking', '🚣 Boating', '🏛️ Historical', '🦌 Wildlife',
                    '⛰️ Adventure', '🛍️ Shopping', '🏺 Pottery', '🕳️ Caving',
                    '💧 Waterfalls', '🌹 Gardens',
                  ],
                  selected: provider.profile.preferredActivity,
                  onSelected: provider.updateActivity,
                ),
                const SizedBox(height: 16),

                // Budget Slider
                _SectionTitle(
                  title: '💰 Budget (USD): \$${provider.profile.budgetUSD.round()}',
                ),
                Slider(
                  value: provider.profile.budgetUSD,
                  min: 30,
                  max: 500,
                  divisions: 47,
                  label: '\$${provider.profile.budgetUSD.round()}',
                  onChanged: provider.updateBudget,
                ),
                const SizedBox(height: 16),

                // Season
                _SectionTitle(title: '🌤️ Season'),
                const SizedBox(height: 8),
                _ChipSelector<String>(
                  items: const ['Summer', 'Winter', 'Spring', 'Autumn'],
                  labels: const [
                    '☀️ Summer', '❄️ Winter', '🌸 Spring', '🍂 Autumn',
                  ],
                  selected: provider.profile.season,
                  onSelected: provider.updateSeason,
                ),
                const SizedBox(height: 16),

                // Fitness Level
                _SectionTitle(title: '💪 Fitness Level'),
                const SizedBox(height: 8),
                _ChipSelector<String>(
                  items: const ['Active', 'Moderate', 'Relaxed'],
                  labels: const ['🏃 Active', '🚶 Moderate', '🧘 Relaxed'],
                  selected: provider.profile.fitnessLevel,
                  onSelected: provider.updateFitness,
                ),
                const SizedBox(height: 16),

                // Stay Preference
                _SectionTitle(title: '🏠 Stay Preference'),
                const SizedBox(height: 8),
                _ChipSelector<String>(
                  items: const [
                    'Camping', 'Homestay', 'Hotel', 'Resort', 'Farmstay',
                  ],
                  labels: const [
                    '⛺ Camping', '🏡 Homestay', '🏨 Hotel', '🏖️ Resort', '🌾 Farmstay',
                  ],
                  selected: provider.profile.stayPreference,
                  onSelected: provider.updateStay,
                ),
                const SizedBox(height: 32),

                // Get Recommendation Button
                FilledButton.icon(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          await provider.generateRecommendation();
                          if (provider.result != null && context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ResultScreen(),
                              ),
                            );
                          }
                        },
                  icon: provider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.travel_explore),
                  label: Text(
                    provider.isLoading
                        ? 'Finding your destination...'
                        : '🌟 Get Recommendation',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final TouristProfile profile;
  final bool isSelected;

  const _PresetChip({
    required this.label,
    required this.profile,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      backgroundColor: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      onPressed: () {
        context.read<RecommendationProvider>().loadPreset(profile);
      },
    );
  }
}

class _ChipSelector<T> extends StatelessWidget {
  final List<T> items;
  final List<String> labels;
  final T selected;
  final ValueChanged<T> onSelected;

  const _ChipSelector({
    required this.items,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: List.generate(items.length, (i) {
        final isActive = items[i] == selected;
        return ChoiceChip(
          label: Text(labels[i]),
          selected: isActive,
          onSelected: (_) => onSelected(items[i]),
        );
      }),
    );
  }
}

