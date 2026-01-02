import 'package:hive/hive.dart';

part 'workout_set.g.dart';

@HiveType(typeId: 2)
class WorkoutSet extends HiveObject {
  @HiveField(0)
  final String id;

  // For strength exercises
  @HiveField(1)
  double? weight;

  @HiveField(2)
  int? reps;

  // For cardio exercises
  @HiveField(3)
  double? distance; // in kilometers

  @HiveField(4)
  int? durationSeconds;

  @HiveField(5)
  int? rpe; // Rate of Perceived Exertion (1-10)

  @HiveField(6)
  bool isCompleted;

  WorkoutSet({
    required this.id,
    this.weight,
    this.reps,
    this.distance,
    this.durationSeconds,
    this.rpe,
    this.isCompleted = false,
  });

  // Calculate pace for cardio (minutes per km)
  double? get paceMinPerKm {
    if (distance != null && durationSeconds != null && distance! > 0) {
      return (durationSeconds! / 60) / distance!;
    }
    return null;
  }

  String? get formattedPace {
    final pace = paceMinPerKm;
    if (pace == null) return null;
    final minutes = pace.floor();
    final seconds = ((pace - minutes) * 60).round();
    return '$minutes:${seconds.toString().padLeft(2, '0')} /km';
  }

  String get formattedDuration {
    if (durationSeconds == null) return '';
    final hours = durationSeconds! ~/ 3600;
    final minutes = (durationSeconds! % 3600) ~/ 60;
    final seconds = durationSeconds! % 60;
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  WorkoutSet copyWith({
    String? id,
    double? weight,
    int? reps,
    double? distance,
    int? durationSeconds,
    int? rpe,
    bool? isCompleted,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      distance: distance ?? this.distance,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      rpe: rpe ?? this.rpe,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
