import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
enum Difficulty {
  @HiveField(0)
  easy,
  @HiveField(1)
  normal,
  @HiveField(2)
  hard,
}

@HiveType(typeId: 1)
enum HabitTheme {
  @HiveField(0)
  road,
  @HiveField(1)
  space,
  @HiveField(2)
  mountain,
  @HiveField(3)
  ocean,
}

@HiveType(typeId: 4)
enum HabitEvolution {
  @HiveField(0)
  seed,      // Level 1: Just started
  @HiveField(1)
  sprout,    // Level 2: Getting consistent
  @HiveField(2)
  bloom,     // Level 3: Well established
  @HiveField(3)
  ancient,   // Level 4: Master level
}

@HiveType(typeId: 2)
class Habit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  int raceLength; // 7, 14, 30

  @HiveField(4)
  Difficulty difficulty;

  @HiveField(5)
  HabitTheme theme;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  List<DateTime> completedDays;

  @HiveField(8)
  HabitEvolution evolution;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.raceLength,
    required this.difficulty,
    required this.theme,
    required this.createdAt,
    List<DateTime>? completedDays,
    HabitEvolution? evolution,
  }) : completedDays = completedDays ?? [],
       evolution = evolution ?? HabitEvolution.seed;

  double get progress => completedDays.length / raceLength;

  bool get isCompleted => progress >= 1.0;

  int get currentStreak {
    if (completedDays.isEmpty) return 0;

    // Sort completed days
    final sortedDays = completedDays..sort();

    int streak = 0;
    DateTime current = DateTime.now();

    // Check from today backwards
    while (true) {
      if (sortedDays.contains(DateTime(current.year, current.month, current.day))) {
        streak++;
        current = current.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  int get speed {
    final streak = currentStreak;
    if (streak >= 4 && streak <= 7) return 2; // boost
    if (streak >= 1 && streak <= 3) return 1; // normal
    return 0; // reset
  }

  int get remainingDays => raceLength - completedDays.length;

  // Evolution system
  int get evolutionLevel {
    switch (evolution) {
      case HabitEvolution.seed: return 1;
      case HabitEvolution.sprout: return 2;
      case HabitEvolution.bloom: return 3;
      case HabitEvolution.ancient: return 4;
    }
  }

  String get evolutionName {
    switch (evolution) {
      case HabitEvolution.seed: return 'Seed';
      case HabitEvolution.sprout: return 'Sprout';
      case HabitEvolution.bloom: return 'Bloom';
      case HabitEvolution.ancient: return 'Ancient';
    }
  }

  HabitEvolution get nextEvolution {
    switch (evolution) {
      case HabitEvolution.seed: return HabitEvolution.sprout;
      case HabitEvolution.sprout: return HabitEvolution.bloom;
      case HabitEvolution.bloom: return HabitEvolution.ancient;
      case HabitEvolution.ancient: return HabitEvolution.ancient; // Max level
    }
  }

  bool get canEvolve {
    if (evolution == HabitEvolution.ancient) return false; // Max level

    final totalCompletions = completedDays.length;
    final consistency = progress;
    final currentStreak = this.currentStreak;

    switch (evolution) {
      case HabitEvolution.seed:
        // Evolve to sprout: 3+ completions AND 50%+ consistency OR 3+ day streak
        return (totalCompletions >= 3 && consistency >= 0.5) || currentStreak >= 3;

      case HabitEvolution.sprout:
        // Evolve to bloom: 7+ completions AND 70%+ consistency OR 7+ day streak
        return (totalCompletions >= 7 && consistency >= 0.7) || currentStreak >= 7;

      case HabitEvolution.bloom:
        // Evolve to ancient: 15+ completions AND 80%+ consistency OR 15+ day streak
        return (totalCompletions >= 15 && consistency >= 0.8) || currentStreak >= 15;

      case HabitEvolution.ancient:
        return false;
    }
  }

  void tryEvolve() {
    if (canEvolve) {
      evolution = nextEvolution;
      save();
    }
  }

  void completeToday() {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (!completedDays.contains(today)) {
      completedDays.add(today);
      tryEvolve(); // Check for evolution after completion
      save(); // Hive save
    }
  }

  void markCompleted() {
    // Force complete if needed, but normally through completions
  }
}
