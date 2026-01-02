import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _selectedPeriod = 30; // Days

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, _) {
        final now = DateTime.now();
        final startDate = now.subtract(Duration(days: _selectedPeriod));
        final workouts = provider.getWorkoutsInRange(
          startDate,
          now.add(const Duration(days: 1)),
        );

        // Calculate stats
        final totalWorkouts = workouts.length;
        final totalVolume = workouts.fold<double>(
          0,
          (sum, w) => sum + w.totalVolume,
        );
        final totalSets = workouts.fold<int>(
          0,
          (sum, w) => sum + w.totalSets,
        );

        // Get workout frequency per week
        final weeklyData = _getWeeklyData(workouts, startDate, now);

        // Get most frequent exercises
        final exerciseFrequency = <String, int>{};
        for (final workout in workouts) {
          for (final exercise in workout.exercises) {
            exerciseFrequency[exercise.exerciseName] =
                (exerciseFrequency[exercise.exerciseName] ?? 0) + 1;
          }
        }
        final topExercises = exerciseFrequency.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.spacingMd),
                Text(
                  'Stats',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppTheme.spacingMd),

                // Period selector
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPeriodChip(7, '7 days'),
                      const SizedBox(width: AppTheme.spacingSm),
                      _buildPeriodChip(30, '30 days'),
                      const SizedBox(width: AppTheme.spacingSm),
                      _buildPeriodChip(90, '90 days'),
                      const SizedBox(width: AppTheme.spacingSm),
                      _buildPeriodChip(365, '1 year'),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),

                // Summary stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Workouts',
                        '$totalWorkouts',
                        Icons.fitness_center,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Total Sets',
                        '$totalSets',
                        Icons.repeat,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingMd),
                _buildStatCard(
                  context,
                  'Total Volume',
                  '${(totalVolume / 1000).toStringAsFixed(1)}k kg',
                  Icons.trending_up,
                  fullWidth: true,
                ),
                const SizedBox(height: AppTheme.spacingXl),

                // Workout frequency chart
                Text(
                  'Workout Frequency',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: AppTheme.getSurface(context),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                  child: weeklyData.isEmpty
                      ? Center(
                          child: Text(
                            'No data available',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: (weeklyData.map((e) => e['count'] as int).reduce((a, b) => a > b ? a : b) + 1).toDouble(),
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipColor: (_) => AppTheme.getSurfaceLight(context),
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  return BarTooltipItem(
                                    '${rod.toY.toInt()} workouts',
                                    TextStyle(
                                      color: AppTheme.getTextPrimary(context),
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() >= weeklyData.length) {
                                      return const SizedBox.shrink();
                                    }
                                    final data = weeklyData[value.toInt()];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        data['label'] as String,
                                        style: TextStyle(
                                          color: AppTheme.getTextTertiary(context),
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(show: false),
                            barGroups: weeklyData.asMap().entries.map((entry) {
                              return BarChartGroupData(
                                x: entry.key,
                                barRods: [
                                  BarChartRodData(
                                    toY: (entry.value['count'] as int).toDouble(),
                                    color: AppTheme.getPrimary(context),
                                    width: 20,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(4),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                ),
                const SizedBox(height: AppTheme.spacingXl),

                // Most frequent exercises
                if (topExercises.isNotEmpty) ...[
                  Text(
                    'Top Exercises',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    decoration: BoxDecoration(
                      color: AppTheme.getSurface(context),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    ),
                    child: Column(
                      children: topExercises.take(5).map((entry) {
                        final maxCount = topExercises.first.value;
                        final progress = entry.value / maxCount;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: Theme.of(context).textTheme.bodyLarge,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '${entry.value}×',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppTheme.getPrimary(context),
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppTheme.spacingSm),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: AppTheme.getSurfaceLight(context),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.getPrimary(context),
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodChip(int days, String label) {
    final isSelected = _selectedPeriod == days;

    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = days),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.getPrimary(context) : AppTheme.getSurface(context),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.getTextPrimary(context) : AppTheme.getTextSecondary(context),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon, {
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.getSurface(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.getPrimary(context).withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(icon, color: AppTheme.getPrimary(context)),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getWeeklyData(
    List<Workout> workouts,
    DateTime startDate,
    DateTime endDate,
  ) {
    final result = <Map<String, dynamic>>[];

    // Calculate number of weeks
    final days = endDate.difference(startDate).inDays;
    final weeks = (days / 7).ceil();

    if (weeks <= 0) return result;

    // Limit to last 8 weeks for readability
    final displayWeeks = weeks > 8 ? 8 : weeks;
    final adjustedStart = endDate.subtract(Duration(days: displayWeeks * 7));

    for (int i = 0; i < displayWeeks; i++) {
      final weekStart = adjustedStart.add(Duration(days: i * 7));
      final weekEnd = weekStart.add(const Duration(days: 7));

      final weekWorkouts = workouts.where((w) {
        return w.date.isAfter(weekStart) && w.date.isBefore(weekEnd);
      }).length;

      final label = DateFormat('M/d').format(weekStart);

      result.add({
        'label': label,
        'count': weekWorkouts,
      });
    }

    return result;
  }
}
