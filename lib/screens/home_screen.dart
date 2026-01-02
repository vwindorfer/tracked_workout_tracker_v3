import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'new_workout_screen.dart';
import 'workout_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, _) {
        final recentWorkouts = provider.workouts.take(3).toList();

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Header with greeting
                    const SizedBox(height: AppTheme.spacingMd),
                    Text(
                      _getGreeting(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingXs),
                    Text(
                      "Ready to train?",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: AppTheme.spacingXl),

                    // Start workout button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.startNewWorkout();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const NewWorkoutScreen(),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 24),
                            SizedBox(width: AppTheme.spacingSm),
                            Text('Start Workout'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXl),

                    // Quick stats
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: 'This Week',
                            value: '${provider.workoutsThisWeek}',
                            subtitle: 'workouts',
                            icon: Icons.calendar_today_outlined,
                            iconColor: AppTheme.getPrimary(context),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingMd),
                        Expanded(
                          child: StatCard(
                            title: 'Total',
                            value: '${provider.totalWorkouts}',
                            subtitle: 'all time',
                            icon: Icons.fitness_center,
                            iconColor: AppTheme.getAccent(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXl),

                    // Recent workouts section
                    if (recentWorkouts.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                    ],
                  ]),
                ),
              ),

              // Recent workouts list
              if (recentWorkouts.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final workout = recentWorkouts[index];
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
                          ),
                        );
                      },
                      childCount: recentWorkouts.length,
                    ),
                  ),
                ),

              // Empty state
              if (recentWorkouts.isEmpty)
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
                            Icons.fitness_center,
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
                            'Start your first workout to begin tracking your progress',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Bottom padding for navigation bar
              const SliverPadding(
                padding: EdgeInsets.only(bottom: 100),
              ),
            ],
          ),
        );
      },
    );
  }
}
