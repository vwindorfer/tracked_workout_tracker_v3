// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 0;

  @override
  Exercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exercise(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as ExerciseType,
      muscleGroup: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.muscleGroup);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseTypeAdapter extends TypeAdapter<ExerciseType> {
  @override
  final int typeId = 5;

  @override
  ExerciseType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExerciseType.strength;
      case 1:
        return ExerciseType.cardio;
      default:
        return ExerciseType.strength;
    }
  }

  @override
  void write(BinaryWriter writer, ExerciseType obj) {
    switch (obj) {
      case ExerciseType.strength:
        writer.writeByte(0);
        break;
      case ExerciseType.cardio:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
