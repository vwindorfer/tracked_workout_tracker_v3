import 'package:hive/hive.dart';
import 'workout_set.dart';

part 'workout_exercise.g.dart';

@HiveType(typeId: 3)
class WorkoutExercise extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String exerciseId;

  @HiveField(2)
  String exerciseName;

  @HiveField(3)
  bool isCardio;

  @HiveField(4)
  List<WorkoutSet> sets;

  @HiveField(5)
  String? notes;

  WorkoutExercise({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.isCardio,
    List<WorkoutSet>? sets,
    this.notes,
  }) : sets = sets ?? [];

  // Get total volume for strength exercises (weight * reps)
  double get totalVolume {
    if (isCardio) return 0;
    return sets.fold(0, (sum, set) {
      if (set.weight != null && set.reps != null) {
        return sum + (set.weight! * set.reps!);
      }
      return sum;
    });
  }

  // Get total distance for cardio
  double get totalDistance {
    if (!isCardio) return 0;
    return sets.fold(0, (sum, set) => sum + (set.distance ?? 0));
  }

  // Get total duration for cardio (in seconds)
  int get totalDuration {
    if (!isCardio) return 0;
    return sets.fold(0, (sum, set) => sum + (set.durationSeconds ?? 0));
  }

  WorkoutExercise copyWith({
    String? id,
    String? exerciseId,
    String? exerciseName,
    bool? isCardio,
    List<WorkoutSet>? sets,
    String? notes,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      isCardio: isCardio ?? this.isCardio,
      sets: sets ?? this.sets,
      notes: notes ?? this.notes,
    );
  }
}
