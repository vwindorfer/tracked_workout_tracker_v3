import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../providers/theme_provider.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'Settings',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // Appearance section
            _buildSectionHeader(context, 'Appearance'),
            const SizedBox(height: AppTheme.spacingSm),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: AppTheme.getSurface(context),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    border: Theme.of(context).brightness == Brightness.light
                        ? Border.all(color: AppTheme.getBorder(context))
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.getPrimary(context).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        ),
                        child: Icon(
                          themeProvider.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: AppTheme.getPrimary(context),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dark Mode',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppTheme.spacingXs),
                            Text(
                              themeProvider.isDarkMode ? 'Enabled' : 'Disabled',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (_) => themeProvider.toggleTheme(),
                        activeTrackColor: AppTheme.getPrimary(context),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // Exercises section
            _buildSectionHeader(context, 'Exercises'),
            const SizedBox(height: AppTheme.spacingSm),
            _buildSettingsCard(
              context,
              'Manage Exercises',
              'Add, edit, or remove exercises',
              Icons.fitness_center,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageExercisesScreen()),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Locations section
            _buildSectionHeader(context, 'Locations'),
            const SizedBox(height: AppTheme.spacingSm),
            _buildSettingsCard(
              context,
              'Manage Locations',
              'Add, edit, or remove gym locations',
              Icons.location_on_outlined,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageLocationsScreen()),
              ),
            ),
            const SizedBox(height: AppTheme.spacingXl),

            // About section
            _buildSectionHeader(context, 'About'),
            const SizedBox(height: AppTheme.spacingSm),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: AppTheme.getSurface(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'tracked',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Text(
                    'A simple, minimalistic workout tracker.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppTheme.getTextTertiary(context),
          ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.getTextTertiary(context),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageExercisesScreen extends StatelessWidget {
  const ManageExercisesScreen({super.key});

  void _showAddEditDialog(BuildContext context, {Exercise? exercise}) {
    final nameController = TextEditingController(text: exercise?.name ?? '');
    ExerciseType type = exercise?.type ?? ExerciseType.strength;
    String? muscleGroup = exercise?.muscleGroup;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(exercise == null ? 'New Exercise' : 'Edit Exercise'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Exercise name',
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                DropdownButtonFormField<ExerciseType>(
                  value: type,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: ExerciseType.strength,
                      child: Text('Strength'),
                    ),
                    DropdownMenuItem(
                      value: ExerciseType.cardio,
                      child: Text('Cardio'),
                    ),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      type = value!;
                      if (type == ExerciseType.cardio) {
                        muscleGroup = null;
                      }
                    });
                  },
                ),
                if (type == ExerciseType.strength) ...[
                  const SizedBox(height: AppTheme.spacingMd),
                  DropdownButtonFormField<String>(
                    value: muscleGroup,
                    decoration: const InputDecoration(
                      labelText: 'Muscle group',
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('None')),
                      DropdownMenuItem(value: 'Chest', child: Text('Chest')),
                      DropdownMenuItem(value: 'Back', child: Text('Back')),
                      DropdownMenuItem(value: 'Shoulders', child: Text('Shoulders')),
                      DropdownMenuItem(value: 'Arms', child: Text('Arms')),
                      DropdownMenuItem(value: 'Legs', child: Text('Legs')),
                      DropdownMenuItem(value: 'Core', child: Text('Core')),
                    ],
                    onChanged: (value) {
                      setDialogState(() => muscleGroup = value);
                    },
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final newExercise = Exercise(
                    id: exercise?.id ?? const Uuid().v4(),
                    name: nameController.text,
                    type: type,
                    muscleGroup: muscleGroup,
                  );
                  if (exercise == null) {
                    await context.read<WorkoutProvider>().addExercise(newExercise);
                  } else {
                    await context.read<WorkoutProvider>().updateExercise(newExercise);
                  }
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: Text(exercise == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Exercise exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete exercise?'),
        content: Text('Are you sure you want to delete "${exercise.name}"?'),
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
              await context.read<WorkoutProvider>().deleteExercise(exercise.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, _) {
        final strengthExercises = provider.strengthExercises;
        final cardioExercises = provider.cardioExercises;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Exercises'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddEditDialog(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            children: [
              // Strength exercises
              Text(
                'Strength',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme.getTextTertiary(context),
                    ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              ...strengthExercises.map((exercise) => _buildExerciseTile(
                    context,
                    exercise,
                  )),

              const SizedBox(height: AppTheme.spacingLg),

              // Cardio exercises
              Text(
                'Cardio',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme.getTextTertiary(context),
                    ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              ...cardioExercises.map((exercise) => _buildExerciseTile(
                    context,
                    exercise,
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExerciseTile(BuildContext context, Exercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      decoration: BoxDecoration(
        color: AppTheme.getSurface(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingXs,
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: exercise.type == ExerciseType.strength
                ? AppTheme.getPrimary(context).withOpacity(0.2)
                : AppTheme.getAccent(context).withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: Icon(
            exercise.type == ExerciseType.strength ? Icons.fitness_center : Icons.directions_run,
            color: exercise.type == ExerciseType.strength ? AppTheme.getPrimary(context) : AppTheme.getAccent(context),
            size: 20,
          ),
        ),
        title: Text(exercise.name),
        subtitle: exercise.muscleGroup != null
            ? Text(
                exercise.muscleGroup!,
                style: Theme.of(context).textTheme.bodySmall,
              )
            : null,
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert, color: AppTheme.getTextTertiary(context)),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _showAddEditDialog(context, exercise: exercise);
            } else if (value == 'delete') {
              _confirmDelete(context, exercise);
            }
          },
        ),
      ),
    );
  }
}

class ManageLocationsScreen extends StatelessWidget {
  const ManageLocationsScreen({super.key});

  void _showAddEditDialog(BuildContext context, {Location? location}) {
    final nameController = TextEditingController(text: location?.name ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(location == null ? 'New Location' : 'Edit Location'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Location name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final newLocation = Location(
                  id: location?.id ?? const Uuid().v4(),
                  name: nameController.text,
                );
                if (location == null) {
                  await context.read<WorkoutProvider>().addLocation(newLocation);
                } else {
                  await context.read<WorkoutProvider>().updateLocation(newLocation);
                }
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: Text(location == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Location location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete location?'),
        content: Text('Are you sure you want to delete "${location.name}"?'),
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
              await context.read<WorkoutProvider>().deleteLocation(location.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, _) {
        final locations = provider.locations;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Locations'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddEditDialog(context),
              ),
            ],
          ),
          body: locations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off_outlined,
                        size: 64,
                        color: AppTheme.getTextTertiary(context),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      Text(
                        'No locations yet',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      Text(
                        'Add your gym or workout locations',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final location = locations[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
                      decoration: BoxDecoration(
                        color: AppTheme.getSurface(context),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd,
                          vertical: AppTheme.spacingXs,
                        ),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.getPrimary(context).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: AppTheme.getPrimary(context),
                            size: 20,
                          ),
                        ),
                        title: Text(location.name),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert, color: AppTheme.getTextTertiary(context)),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showAddEditDialog(context, location: location);
                            } else if (value == 'delete') {
                              _confirmDelete(context, location);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
