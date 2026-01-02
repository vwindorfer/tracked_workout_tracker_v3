import 'package:hive/hive.dart';
import 'workout_exercise.dart';

part 'workout.g.dart';

@HiveType(typeId: 4)
class Workout extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String? locationId;

  @HiveField(3)
  String? locationName;

  @HiveField(4)
  List<WorkoutExercise> exercises;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  int? durationMinutes;

  Workout({
    required this.id,
    required this.date,
    this.locationId,
    this.locationName,
    List<WorkoutExercise>? exercises,
    this.notes,
    this.durationMinutes,
  }) : exercises = exercises ?? [];

  // Get total volume across all strength exercises
  double get totalVolume {
    return exercises.fold(0, (sum, ex) => sum + ex.totalVolume);
  }

  // Get total sets count
  int get totalSets {
    return exercises.fold(0, (sum, ex) => sum + ex.sets.length);
  }

  // Get exercise count
  int get exerciseCount => exercises.length;

  Workout copyWith({
    String? id,
    DateTime? date,
    String? locationId,
    String? locationName,
    List<WorkoutExercise>? exercises,
    String? notes,
    int? durationMinutes,
  }) {
    return Workout(
      id: id ?? this.id,
      date: date ?? this.date,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      exercises: exercises ?? this.exercises,
      notes: notes ?? this.notes,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}
