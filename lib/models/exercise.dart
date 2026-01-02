import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 5)
enum ExerciseType {
  @HiveField(0)
  strength,
  @HiveField(1)
  cardio,
}

@HiveType(typeId: 0)
class Exercise extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  ExerciseType type;

  @HiveField(3)
  String? muscleGroup;

  Exercise({
    required this.id,
    required this.name,
    required this.type,
    this.muscleGroup,
  });

  Exercise copyWith({
    String? id,
    String? name,
    ExerciseType? type,
    String? muscleGroup,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      muscleGroup: muscleGroup ?? this.muscleGroup,
    );
  }
}
