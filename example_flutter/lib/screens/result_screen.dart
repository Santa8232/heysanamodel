import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recommendation_result.dart';
import '../providers/recommendation_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecommendationProvider>();
    final result = provider.result;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Result')),
        body: const Center(child: Text('No recommendation found.')),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌟 Your Destination'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            provider.reset();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Destination Hero Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.secondaryContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text('📍', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    Text(
                      result.destination,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.district,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${result.confidencePercent.toStringAsFixed(1)}% Confidence',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Details Section
            _DetailCard(
              icon: Icons.star,
              title: 'Highlights',
              content: result.highlights,
              color: Colors.amber,
            ),
            const SizedBox(height: 12),
            _DetailCard(
              icon: Icons.wb_sunny,
              title: 'Best Season',
              content: result.bestSeason,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            _DetailCard(
              icon: Icons.restaurant,
              title: 'Local Food',
              content: result.localFood,
              color: Colors.red,
            ),
            const SizedBox(height: 24),

            // Curated Trip Combo
            Text(
              '🎁 Recommended Timeline',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _TripPlanTimeline(result: result),
            const SizedBox(height: 24),

            // Back Button
            OutlinedButton.icon(
              onPressed: () {
                provider.reset();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Another Profile'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TripDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 8),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}

class _TripPlanTimeline extends StatelessWidget {
  final RecommendationResult result;

  const _TripPlanTimeline({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.tripPlanTitle,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              result.tripPlanTagline,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            ...result.itinerary.asMap().entries.map(
                  (entry) => _TimelineItem(
                    item: entry.value,
                    isLast: entry.key == result.itinerary.length - 1,
                    color: colorScheme.primary,
                  ),
                ),
            const Divider(height: 24),
            _TripDetail(icon: Icons.schedule, label: 'Duration', value: '${result.planDurationDays} Days'),
            const SizedBox(height: 8),
            _TripDetail(icon: Icons.account_balance_wallet, label: 'Budget', value: result.estimatedBudgetINR),
            const SizedBox(height: 8),
            _TripDetail(icon: Icons.hotel, label: 'Stay', value: result.curatedStay),
            const SizedBox(height: 8),
            _TripDetail(icon: Icons.restaurant_menu, label: 'Dining', value: result.topDining),
            const SizedBox(height: 8),
            _TripDetail(icon: Icons.auto_awesome, label: 'Highlights', value: result.planHighlights),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final TripPlanDay item;
  final bool isLast;
  final Color color;

  const _TimelineItem({
    required this.item,
    required this.isLast,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 46,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: color,
                  child: Text(
                    '${item.day}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: color.withAlpha(70)),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Day ${item.day}', style: theme.textTheme.labelLarge?.copyWith(color: color, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Text(item.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(item.activities, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

