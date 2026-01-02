import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const WorkoutCard({
    super.key,
    required this.workout,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d');
    final timeFormat = DateFormat('h:mm a');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: AppTheme.getSurface(context),
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateFormat.format(workout.date),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppTheme.spacingXs),
                      Row(
                        children: [
                          Text(
                            timeFormat.format(workout.date),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (workout.locationName != null) ...[
                            const SizedBox(width: AppTheme.spacingSm),
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppTheme.getTextTertiary(context),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              workout.locationName!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline,
                      color: AppTheme.getTextTertiary(context),
                      size: 20,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Wrap(
              spacing: AppTheme.spacingSm,
              runSpacing: AppTheme.spacingSm,
              children: workout.exercises.map((ex) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSm,
                    vertical: AppTheme.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.getSurfaceLight(context),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Text(
                    ex.exerciseName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.getTextSecondary(context),
                        ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              children: [
                _buildStat(
                  context,
                  '${workout.exerciseCount}',
                  'exercises',
                ),
                const SizedBox(width: AppTheme.spacingLg),
                _buildStat(
                  context,
                  '${workout.totalSets}',
                  'sets',
                ),
                if (workout.durationMinutes != null) ...[
                  const SizedBox(width: AppTheme.spacingLg),
                  _buildStat(
                    context,
                    '${workout.durationMinutes}',
                    'min',
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Row(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.getPrimary(context),
              ),
        ),
        const SizedBox(width: AppTheme.spacingXs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
