import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'workout_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _selectedLocationId;

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, _) {
        List<Workout> workouts = provider.workouts;

        // Filter by location if selected
        if (_selectedLocationId != null) {
          workouts = workouts.where((w) => w.locationId == _selectedLocationId).toList();
        }

        // Group workouts by month
        final grouped = <String, List<Workout>>{};
        for (final workout in workouts) {
          final key = DateFormat('MMMM yyyy').format(workout.date);
          grouped.putIfAbsent(key, () => []);
          grouped[key]!.add(workout);
        }

        final months = grouped.keys.toList();

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverPadding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppTheme.spacingMd),
                      Text(
                        'History',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: AppTheme.spacingMd),

                      // Location filter
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(
                              context,
                              'All',
                              _selectedLocationId == null,
                              () => setState(() => _selectedLocationId = null),
                            ),
                            ...provider.locations.map((location) => Padding(
                                  padding: const EdgeInsets.only(left: AppTheme.spacingSm),
                                  child: _buildFilterChip(
                                    context,
                                    location.name,
                                    _selectedLocationId == location.id,
                                    () => setState(() => _selectedLocationId = location.id),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Workout list
              if (workouts.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.spacingXl),
                      decoration: BoxDecoration(
                        color: AppTheme.getSurface(context),
                        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.history,
                            size: 48,
                            color: AppTheme.getTextTertiary(context),
                          ),
                          const SizedBox(height: AppTheme.spacingMd),
                          Text(
                            'No workouts yet',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: AppTheme.spacingSm),
                          Text(
                            'Your completed workouts will appear here',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ...months.map((month) {
                  final monthWorkouts = grouped[month]!;
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: AppTheme.spacingMd,
                                bottom: AppTheme.spacingSm,
                              ),
                              child: Text(
                                month,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppTheme.getTextTertiary(context),
                                    ),
                              ),
                            );
                          }

                          final workout = monthWorkouts[index - 1];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                            child: WorkoutCard(
                              workout: workout,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => WorkoutDetailScreen(workout: workout),
                                  ),
                                );
                              },
                              onDelete: () => _confirmDelete(context, workout),
                            ),
                          );
                        },
                        childCount: monthWorkouts.length + 1,
                      ),
                    ),
                  );
                }),

              // Bottom padding
              const SliverPadding(
                padding: EdgeInsets.only(bottom: 100),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? AppTheme.getTextPrimary(context) : AppTheme.getTextSecondary(context),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Workout workout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete workout?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            onPressed: () async {
              await context.read<WorkoutProvider>().deleteWorkout(workout.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
