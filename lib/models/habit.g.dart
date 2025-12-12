// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 2;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      raceLength: fields[3] as int,
      difficulty: fields[4] as Difficulty,
      theme: fields[5] as HabitTheme,
      createdAt: fields[6] as DateTime,
      completedDays: (fields[7] as List?)?.cast<DateTime>(),
      evolution: fields[8] as HabitEvolution?,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.raceLength)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.theme)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.completedDays)
      ..writeByte(8)
      ..write(obj.evolution);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DifficultyAdapter extends TypeAdapter<Difficulty> {
  @override
  final int typeId = 0;

  @override
  Difficulty read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Difficulty.easy;
      case 1:
        return Difficulty.normal;
      case 2:
        return Difficulty.hard;
      default:
        return Difficulty.easy;
    }
  }

  @override
  void write(BinaryWriter writer, Difficulty obj) {
    switch (obj) {
      case Difficulty.easy:
        writer.writeByte(0);
        break;
      case Difficulty.normal:
        writer.writeByte(1);
        break;
      case Difficulty.hard:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DifficultyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HabitThemeAdapter extends TypeAdapter<HabitTheme> {
  @override
  final int typeId = 1;

  @override
  HabitTheme read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HabitTheme.road;
      case 1:
        return HabitTheme.space;
      case 2:
        return HabitTheme.mountain;
      case 3:
        return HabitTheme.ocean;
      default:
        return HabitTheme.road;
    }
  }

  @override
  void write(BinaryWriter writer, HabitTheme obj) {
    switch (obj) {
      case HabitTheme.road:
        writer.writeByte(0);
        break;
      case HabitTheme.space:
        writer.writeByte(1);
        break;
      case HabitTheme.mountain:
        writer.writeByte(2);
        break;
      case HabitTheme.ocean:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HabitEvolutionAdapter extends TypeAdapter<HabitEvolution> {
  @override
  final int typeId = 4;

  @override
  HabitEvolution read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HabitEvolution.seed;
      case 1:
        return HabitEvolution.sprout;
      case 2:
        return HabitEvolution.bloom;
      case 3:
        return HabitEvolution.ancient;
      default:
        return HabitEvolution.seed;
    }
  }

  @override
  void write(BinaryWriter writer, HabitEvolution obj) {
    switch (obj) {
      case HabitEvolution.seed:
        writer.writeByte(0);
        break;
      case HabitEvolution.sprout:
        writer.writeByte(1);
        break;
      case HabitEvolution.bloom:
        writer.writeByte(2);
        break;
      case HabitEvolution.ancient:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitEvolutionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
