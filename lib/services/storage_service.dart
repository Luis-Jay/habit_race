import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/habit.dart';

class StorageService {
  static const String habitsBoxName = 'habits';

  static Future<void> init() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);

    // Register adapters
    Hive.registerAdapter(DifficultyAdapter());
    Hive.registerAdapter(HabitThemeAdapter());
    Hive.registerAdapter(HabitEvolutionAdapter());
    Hive.registerAdapter(HabitAdapter());

      await Hive.openBox<Habit>(habitsBoxName);
    } catch (e) {
      throw Exception('Failed to initialize storage: $e');
    }
  }

  Box<Habit> get habitsBox => Hive.box<Habit>(habitsBoxName);

  Future<void> addHabit(Habit habit) async {
    await habitsBox.put(habit.id, habit);
  }

  Future<void> updateHabit(Habit habit) async {
    await habit.save();
  }

  Future<void> deleteHabit(String id) async {
    await habitsBox.delete(id);
  }

  List<Habit> getAllHabits() {
    return habitsBox.values.toList();
  }

  Habit? getHabit(String id) {
    return habitsBox.get(id);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
