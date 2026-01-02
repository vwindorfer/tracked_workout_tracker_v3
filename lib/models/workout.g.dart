// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutAdapter extends TypeAdapter<Workout> {
  @override
  final int typeId = 4;

  @override
  Workout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Workout(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      locationId: fields[2] as String?,
      locationName: fields[3] as String?,
      exercises: (fields[4] as List?)?.cast<WorkoutExercise>(),
      notes: fields[5] as String?,
      durationMinutes: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Workout obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.locationId)
      ..writeByte(3)
      ..write(obj.locationName)
      ..writeByte(4)
      ..write(obj.exercises)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.durationMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
