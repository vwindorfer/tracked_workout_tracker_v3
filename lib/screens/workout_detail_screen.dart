import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';
import 'new_workout_screen.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  void _editWorkout(BuildContext context) async {
    context.read<WorkoutProvider>().editWorkout(workout);
    if (context.mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const NewWorkoutScreen(isEditing: true),
        ),
      );
      // Refresh when coming back from edit
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _deleteWorkout(BuildContext context) {
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
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _editWorkout(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _deleteWorkout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date and location header
            Text(
              dateFormat.format(workout.date),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (workout.locationName != null) ...[
              const SizedBox(height: AppTheme.spacingSm),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppTheme.getTextSecondary(context),
                  ),
                  const SizedBox(width: AppTheme.spacingXs),
                  Text(
                    workout.locationName!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getTextSecondary(context),
                        ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppTheme.spacingLg),

            // Summary stats
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.getSurface(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(context, '${workout.exerciseCount}', 'Exercises'),
                  Container(
                    width: 1,
                    height: 48,
                    color: AppTheme.getBorder(context),
                  ),
                  _buildStat(context, '${workout.totalSets}', 'Sets'),
                  if (workout.totalVolume > 0) ...[
                    Container(
                      width: 1,
                      height: 48,
                      color: AppTheme.getBorder(context),
                    ),
                    _buildStat(
                      context,
                      workout.totalVolume.toStringAsFixed(0),
                      'Volume (kg)',
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Exercises
            Text(
              'Exercises',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingMd),

            ...workout.exercises.map((exercise) => _buildExerciseCard(context, exercise)),

            if (workout.notes != null && workout.notes!.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: AppTheme.getSurface(context),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                ),
                child: Text(
                  workout.notes!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],

            const SizedBox(height: AppTheme.spacingMd),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.getPrimary(context),
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppTheme.spacingXs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.getTextSecondary(context),
              ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(BuildContext context, WorkoutExercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.getSurface(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: exercise.isCardio
                      ? AppTheme.getAccent(context).withValues(alpha: 0.2)
                      : AppTheme.getPrimary(context).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Icon(
                  exercise.isCardio ? Icons.directions_run : Icons.fitness_center,
                  color: exercise.isCardio ? AppTheme.getAccent(context) : AppTheme.getPrimary(context),
                  size: 22,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Text(
                  exercise.exerciseName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Text(
                '${exercise.sets.length} sets',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.getTextSecondary(context),
                    ),
              ),
            ],
          ),
          if (exercise.sets.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingMd),
            // Sets table header
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
                vertical: AppTheme.spacingSm,
              ),
              decoration: BoxDecoration(
                color: AppTheme.getSurfaceLight(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 36),
                  if (!exercise.isCardio) ...[
                    Expanded(
                      child: Text(
                        'WEIGHT',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppTheme.getTextSecondary(context),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'REPS',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppTheme.getTextSecondary(context),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: Text(
                        'DISTANCE',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppTheme.getTextSecondary(context),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'TIME',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppTheme.getTextSecondary(context),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'PACE',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppTheme.getTextSecondary(context),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            // Sets
            ...exercise.sets.asMap().entries.map((entry) {
              final index = entry.key;
              final set = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingMd,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.getSurfaceLight(context),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.getPrimary(context).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.getPrimary(context),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (!exercise.isCardio) ...[
                      Expanded(
                        child: Text(
                          set.weight != null ? '${set.weight} kg' : '-',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          set.reps?.toString() ?? '-',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: Text(
                          set.distance != null ? '${set.distance} km' : '-',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          set.formattedDuration.isNotEmpty ? set.formattedDuration : '-',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          set.formattedPace ?? '-',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.getAccent(context),
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
