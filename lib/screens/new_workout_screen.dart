import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/workout_provider.dart';
import '../theme/app_theme.dart';
import 'exercise_picker_screen.dart';

class NewWorkoutScreen extends StatefulWidget {
  final bool isEditing;

  const NewWorkoutScreen({super.key, this.isEditing = false});

  @override
  State<NewWorkoutScreen> createState() => _NewWorkoutScreenState();
}

class _NewWorkoutScreenState extends State<NewWorkoutScreen> {

  Future<void> _selectLocation(BuildContext context) async {
    final provider = context.read<WorkoutProvider>();
    final locations = provider.locations;

    await showModalBottomSheet(
      context: context,
      builder: (context) => _LocationPicker(
        locations: locations,
        selectedId: provider.currentWorkout?.locationId,
        onSelect: (location) {
          provider.updateCurrentWorkoutLocation(location?.id, location?.name);
          Navigator.pop(context);
        },
        onAddNew: () async {
          Navigator.pop(context);
          await _showAddLocationDialog(context);
        },
      ),
    );
  }

  Future<void> _showAddLocationDialog(BuildContext context) async {
    final controller = TextEditingController();
    final provider = context.read<WorkoutProvider>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Location'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Location name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final location = Location(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: controller.text,
                );
                await provider.addLocation(location);
                provider.updateCurrentWorkoutLocation(location.id, location.name);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final provider = context.read<WorkoutProvider>();
    final currentDate = provider.currentWorkout?.date ?? DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      provider.updateCurrentWorkoutDate(
        DateTime(date.year, date.month, date.day),
      );
    }
  }

  void _addExercise() async {
    final exercise = await Navigator.of(context).push<Exercise>(
      MaterialPageRoute(
        builder: (_) => const ExercisePickerScreen(),
      ),
    );

    if (exercise != null && context.mounted) {
      context.read<WorkoutProvider>().addExerciseToWorkout(exercise);
    }
  }

  void _saveWorkout() async {
    final provider = context.read<WorkoutProvider>();
    final workout = provider.currentWorkout;

    if (workout == null || workout.exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one exercise')),
      );
      return;
    }

    await provider.saveCurrentWorkout();
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _cancelWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard workout?'),
        content: const Text('Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep editing'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            onPressed: () {
              context.read<WorkoutProvider>().cancelCurrentWorkout();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, _) {
        final workout = provider.currentWorkout;
        final dateFormat = DateFormat('EEE, MMM d');

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: _cancelWorkout,
            ),
            title: Text(widget.isEditing ? 'Edit Workout' : 'New Workout'),
            actions: [
              TextButton(
                onPressed: _saveWorkout,
                child: const Text('Save'),
              ),
            ],
          ),
          body: workout == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Header info
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                      child: Row(
                        children: [
                          // Date picker
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingMd,
                                  vertical: AppTheme.spacingSm,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.getSurface(context),
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 18, color: AppTheme.getTextSecondary(context)),
                                    const SizedBox(width: AppTheme.spacingSm),
                                    Text(
                                      dateFormat.format(workout.date),
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingSm),
                          // Location picker
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectLocation(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingMd,
                                  vertical: AppTheme.spacingSm,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.getSurface(context),
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, size: 18, color: AppTheme.getTextSecondary(context)),
                                    const SizedBox(width: AppTheme.spacingSm),
                                    Expanded(
                                      child: Text(
                                        workout.locationName ?? 'Location',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: workout.locationName != null
                                                  ? AppTheme.getTextPrimary(context)
                                                  : AppTheme.getTextTertiary(context),
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Exercises list
                    Expanded(
                      child: workout.exercises.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.fitness_center,
                                    size: 64,
                                    color: AppTheme.getTextTertiary(context),
                                  ),
                                  const SizedBox(height: AppTheme.spacingMd),
                                  Text(
                                    'Add your first exercise',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                              itemCount: workout.exercises.length,
                              itemBuilder: (context, index) {
                                return _ExerciseCard(
                                  exerciseIndex: index,
                                  workoutExercise: workout.exercises[index],
                                  provider: provider,
                                );
                              },
                            ),
                    ),

                    // Add exercise button
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _addExercise,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Exercise'),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _LocationPicker extends StatelessWidget {
  final List<Location> locations;
  final String? selectedId;
  final Function(Location?) onSelect;
  final VoidCallback onAddNew;

  const _LocationPicker({
    required this.locations,
    required this.selectedId,
    required this.onSelect,
    required this.onAddNew,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.getTextTertiary(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            'Select Location',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          // No location option
          ListTile(
            leading: const Icon(Icons.location_off_outlined),
            title: const Text('No location'),
            selected: selectedId == null,
            onTap: () => onSelect(null),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
          ),
          ...locations.map((location) => ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(location.name),
                selected: selectedId == location.id,
                onTap: () => onSelect(location),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
              )),
          const Divider(),
          ListTile(
            leading: Icon(Icons.add, color: AppTheme.getPrimary(context)),
            title: Text('Add new location', style: TextStyle(color: AppTheme.getPrimary(context))),
            onTap: onAddNew,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final int exerciseIndex;
  final WorkoutExercise workoutExercise;
  final WorkoutProvider provider;

  const _ExerciseCard({
    required this.exerciseIndex,
    required this.workoutExercise,
    required this.provider,
  });

  void _showSetEditor(BuildContext context, int? setIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _SetEditorSheet(
        isCardio: workoutExercise.isCardio,
        existingSet: setIndex != null ? workoutExercise.sets[setIndex] : null,
        onSave: (weight, reps, distance, duration, rpe) {
          if (setIndex != null) {
            provider.updateSet(
              exerciseIndex,
              setIndex,
              weight: weight,
              reps: reps,
              distance: distance,
              duration: duration,
              rpe: rpe,
            );
          } else {
            provider.addSetToExercise(
              exerciseIndex,
              weight: weight,
              reps: reps,
              distance: distance,
              duration: duration,
            );
          }
          Navigator.pop(context);
        },
        onDelete: setIndex != null
            ? () {
                provider.removeSetFromExercise(exerciseIndex, setIndex);
                Navigator.pop(context);
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get last performance
    final lastPerformance = provider.getLastPerformance(workoutExercise.exerciseId);

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
          // Exercise header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                workoutExercise.exerciseName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: AppTheme.getTextTertiary(context)),
                onPressed: () => provider.removeExerciseFromWorkout(exerciseIndex),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),

          // Last performance hint
          if (lastPerformance != null && lastPerformance.sets.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingMd),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
                vertical: AppTheme.spacingSm,
              ),
              decoration: BoxDecoration(
                color: AppTheme.getAccent(context).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                border: Border.all(
                  color: AppTheme.getAccent(context).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    size: 14,
                    color: AppTheme.getAccent(context),
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Text(
                      _getLastPerformanceText(lastPerformance),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.getAccent(context),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppTheme.spacingMd),

          // Sets header
          if (workoutExercise.sets.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
              child: Row(
                children: [
                  const SizedBox(width: 32),
                  if (!workoutExercise.isCardio) ...[
                    Expanded(
                      child: Text(
                        'Weight',
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Reps',
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: Text(
                        'Distance',
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Time',
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Pace',
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),

          // Sets list
          ...workoutExercise.sets.asMap().entries.map((entry) {
            final index = entry.key;
            final set = entry.value;

            return GestureDetector(
              onTap: () => _showSetEditor(context, index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSm,
                  vertical: AppTheme.spacingSm,
                ),
                margin: const EdgeInsets.only(top: AppTheme.spacingSm),
                decoration: BoxDecoration(
                  color: AppTheme.getSurfaceLight(context),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppTheme.getPrimary(context).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppTheme.getPrimary(context),
                              ),
                        ),
                      ),
                    ),
                    if (!workoutExercise.isCardio) ...[
                      Expanded(
                        child: Text(
                          set.weight != null ? '${set.weight} kg' : '-',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          set.reps != null ? '${set.reps}' : '-',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: Text(
                          set.distance != null ? '${set.distance} km' : '-',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          set.formattedDuration.isNotEmpty ? set.formattedDuration : '-',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          set.formattedPace ?? '-',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.getAccent(context),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),

          // Add set button
          const SizedBox(height: AppTheme.spacingMd),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => _showSetEditor(context, null),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Set'),
            ),
          ),
        ],
      ),
    );
  }

  String _getLastPerformanceText(WorkoutExercise lastPerformance) {
    if (workoutExercise.isCardio) {
      final totalDistance = lastPerformance.totalDistance;
      return 'Last: ${totalDistance.toStringAsFixed(1)} km';
    } else {
      final sets = lastPerformance.sets;
      if (sets.isEmpty) return '';

      // Show best set
      final bestSet = sets.reduce((a, b) {
        final volumeA = (a.weight ?? 0) * (a.reps ?? 0);
        final volumeB = (b.weight ?? 0) * (b.reps ?? 0);
        return volumeA > volumeB ? a : b;
      });

      return 'Last: ${bestSet.weight?.toStringAsFixed(1) ?? '-'} kg × ${bestSet.reps ?? '-'}';
    }
  }
}

class _SetEditorSheet extends StatefulWidget {
  final bool isCardio;
  final WorkoutSet? existingSet;
  final Function(double?, int?, double?, int?, int?) onSave;
  final VoidCallback? onDelete;

  const _SetEditorSheet({
    required this.isCardio,
    this.existingSet,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<_SetEditorSheet> createState() => _SetEditorSheetState();
}

class _SetEditorSheetState extends State<_SetEditorSheet> {
  late TextEditingController _weightController;
  late TextEditingController _repsController;
  late TextEditingController _distanceController;
  late TextEditingController _minutesController;
  late TextEditingController _secondsController;
  int? _rpe;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: widget.existingSet?.weight?.toString() ?? '',
    );
    _repsController = TextEditingController(
      text: widget.existingSet?.reps?.toString() ?? '',
    );
    _distanceController = TextEditingController(
      text: widget.existingSet?.distance?.toString() ?? '',
    );

    final duration = widget.existingSet?.durationSeconds ?? 0;
    _minutesController = TextEditingController(
      text: duration > 0 ? (duration ~/ 60).toString() : '',
    );
    _secondsController = TextEditingController(
      text: duration > 0 ? (duration % 60).toString() : '',
    );

    _rpe = widget.existingSet?.rpe;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _distanceController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _save() {
    double? weight;
    int? reps;
    double? distance;
    int? duration;

    if (!widget.isCardio) {
      weight = double.tryParse(_weightController.text);
      reps = int.tryParse(_repsController.text);
    } else {
      distance = double.tryParse(_distanceController.text);
      final minutes = int.tryParse(_minutesController.text) ?? 0;
      final seconds = int.tryParse(_secondsController.text) ?? 0;
      if (minutes > 0 || seconds > 0) {
        duration = minutes * 60 + seconds;
      }
    }

    widget.onSave(weight, reps, distance, duration, _rpe);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.getTextTertiary(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.existingSet != null ? 'Edit Set' : 'Add Set',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (widget.onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppTheme.error),
                    onPressed: widget.onDelete,
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),

            if (!widget.isCardio) ...[
              // Strength exercise inputs
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                      ),
                      autofocus: true,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: TextField(
                      controller: _repsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Reps',
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Cardio exercise inputs
              TextField(
                controller: _distanceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Distance (km)',
                ),
                autofocus: true,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minutesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Minutes',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: TextField(
                      controller: _secondsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Seconds',
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: AppTheme.spacingLg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(widget.existingSet != null ? 'Update' : 'Add'),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
          ],
        ),
      ),
    );
  }
}
