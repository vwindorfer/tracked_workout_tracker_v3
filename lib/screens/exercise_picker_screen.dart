import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';

class ExercisePickerScreen extends StatefulWidget {
  const ExercisePickerScreen({super.key});

  @override
  State<ExercisePickerScreen> createState() => _ExercisePickerScreenState();
}

class _ExercisePickerScreenState extends State<ExercisePickerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Exercise> _filterExercises(List<Exercise> exercises) {
    if (_searchQuery.isEmpty) return exercises;
    return exercises
        .where((e) => e.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _showAddExerciseDialog(ExerciseType type) {
    final nameController = TextEditingController();
    String? muscleGroup;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('New ${type == ExerciseType.strength ? 'Strength' : 'Cardio'} Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Exercise name',
                ),
              ),
              if (type == ExerciseType.strength) ...[
                const SizedBox(height: AppTheme.spacingMd),
                DropdownButtonFormField<String>(
                  value: muscleGroup,
                  hint: const Text('Muscle group (optional)'),
                  decoration: const InputDecoration(),
                  items: const [
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final exercise = Exercise(
                    id: const Uuid().v4(),
                    name: nameController.text,
                    type: type,
                    muscleGroup: muscleGroup,
                  );
                  await context.read<WorkoutProvider>().addExercise(exercise);
                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.pop(context, exercise);
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, _) {
        final strengthExercises = _filterExercises(provider.strengthExercises);
        final cardioExercises = _filterExercises(provider.cardioExercises);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Exercise'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Strength'),
                Tab(text: 'Cardio'),
              ],
              indicatorColor: AppTheme.getPrimary(context),
              labelColor: AppTheme.getPrimary(context),
              unselectedLabelColor: AppTheme.getTextSecondary(context),
            ),
          ),
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search exercises',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
              ),

              // Exercise lists
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Strength exercises
                    _buildExerciseList(
                      strengthExercises,
                      ExerciseType.strength,
                    ),
                    // Cardio exercises
                    _buildExerciseList(
                      cardioExercises,
                      ExerciseType.cardio,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExerciseList(List<Exercise> exercises, ExerciseType type) {
    // Group by muscle group for strength exercises
    if (type == ExerciseType.strength && _searchQuery.isEmpty) {
      final grouped = <String, List<Exercise>>{};
      for (final exercise in exercises) {
        final group = exercise.muscleGroup ?? 'Other';
        grouped.putIfAbsent(group, () => []);
        grouped[group]!.add(exercise);
      }

      final sortedGroups = grouped.keys.toList()..sort();

      return ListView(
        children: [
          ...sortedGroups.expand((group) => [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.spacingMd,
                    AppTheme.spacingMd,
                    AppTheme.spacingMd,
                    AppTheme.spacingSm,
                  ),
                  child: Text(
                    group,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppTheme.getTextTertiary(context),
                        ),
                  ),
                ),
                ...grouped[group]!.map((exercise) => _buildExerciseTile(exercise)),
              ]),
          _buildAddNewTile(type),
        ],
      );
    }

    return ListView(
      children: [
        ...exercises.map((exercise) => _buildExerciseTile(exercise)),
        _buildAddNewTile(type),
      ],
    );
  }

  Widget _buildExerciseTile(Exercise exercise) {
    return ListTile(
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
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Icon(
          exercise.type == ExerciseType.strength ? Icons.fitness_center : Icons.directions_run,
          color: exercise.type == ExerciseType.strength ? AppTheme.getPrimary(context) : AppTheme.getAccent(context),
          size: 20,
        ),
      ),
      title: Text(
        exercise.name,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: exercise.muscleGroup != null
          ? Text(
              exercise.muscleGroup!,
              style: Theme.of(context).textTheme.bodySmall,
            )
          : null,
      onTap: () => Navigator.pop(context, exercise),
    );
  }

  Widget _buildAddNewTile(ExerciseType type) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingXs,
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.getSurfaceLight(context),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: AppTheme.getBorder(context), width: 1),
        ),
        child: Icon(
          Icons.add,
          color: AppTheme.getPrimary(context),
          size: 20,
        ),
      ),
      title: Text(
        'Create new exercise',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.getPrimary(context),
            ),
      ),
      onTap: () => _showAddExerciseDialog(type),
    );
  }
}
