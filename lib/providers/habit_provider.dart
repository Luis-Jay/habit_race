import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';

class HabitProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Habit> _habits = [];
  bool _isLoading = false;
  String? _error;

  List<Habit> get habits => _habits;
  List<Habit> get activeHabits => _habits.where((h) => !h.isCompleted).toList();
  List<Habit> get completedHabits => _habits.where((h) => h.isCompleted).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Computed statistics
  int get totalHabitsCreated => _habits.length;
  int get totalCompletedHabits => completedHabits.length;
  int get totalActiveHabits => activeHabits.length;

  double get averageCompletionRate {
    if (_habits.isEmpty) return 0.0;
    final totalProgress = _habits.fold<double>(0, (sum, habit) => sum + habit.progress);
    return totalProgress / _habits.length;
  }

  int get currentStreak {
    final completedDays = <DateTime>{};
    for (final habit in _habits) {
      completedDays.addAll(habit.completedDays);
    }

    if (completedDays.isEmpty) return 0;

    final sortedDays = completedDays.toList()..sort();
    int streak = 0;
    DateTime current = DateTime.now();

    // Check from today backwards
    while (true) {
      final today = DateTime(current.year, current.month, current.day);
      if (sortedDays.contains(today)) {
        streak++;
        current = current.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  Map<String, int> get habitsByTheme {
    final themeCount = <String, int>{};
    for (final habit in _habits) {
      final themeName = habit.theme.name;
      themeCount[themeName] = (themeCount[themeName] ?? 0) + 1;
    }
    return themeCount;
  }

  Map<String, int> get habitsByDifficulty {
    final difficultyCount = <String, int>{};
    for (final habit in _habits) {
      final difficultyName = habit.difficulty.name;
      difficultyCount[difficultyName] = (difficultyCount[difficultyName] ?? 0) + 1;
    }
    return difficultyCount;
  }

  Future<void> init() async {
    _setLoading(true);
    try {
      await StorageService.init();
      _loadHabits();
      _error = null;
    } catch (e) {
      _error = 'Failed to initialize app: $e';
    } finally {
      _setLoading(false);
    }
  }

  void _loadHabits() {
    try {
      _habits = _storageService.getAllHabits();
      _error = null;
    } catch (e) {
      _error = 'Failed to load habits: $e';
    }
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    _setLoading(true);
    try {
      await _storageService.addHabit(habit);
      _loadHabits();
      _error = null;
    } catch (e) {
      _error = 'Failed to add habit: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      await _storageService.updateHabit(habit);
      _loadHabits();
      _error = null;
    } catch (e) {
      _error = 'Failed to update habit: $e';
      notifyListeners();
    }
  }

  Future<void> deleteHabit(String id) async {
    _setLoading(true);
    try {
      await _storageService.deleteHabit(id);
      _loadHabits();
      _error = null;
    } catch (e) {
      _error = 'Failed to delete habit: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> completeHabitToday(String id) async {
    try {
      final habit = _storageService.getHabit(id);
      if (habit != null) {
        final oldEvolution = habit.evolution;
        habit.completeToday();
        final newEvolution = habit.evolution;

        await updateHabit(habit);

        // Check if evolution happened
        if (newEvolution != oldEvolution) {
          // Evolution occurred! This will be handled by the UI
          _lastEvolvedHabit = habit;
          _lastEvolutionLevel = newEvolution;
          notifyListeners();
        }
      }
    } catch (e) {
      _error = 'Failed to complete habit: $e';
      notifyListeners();
    }
  }

  // Evolution tracking
  Habit? _lastEvolvedHabit;
  HabitEvolution? _lastEvolutionLevel;

  Habit? get lastEvolvedHabit => _lastEvolvedHabit;
  HabitEvolution? get lastEvolutionLevel => _lastEvolutionLevel;

  void clearEvolutionNotification() {
    _lastEvolvedHabit = null;
    _lastEvolutionLevel = null;
    notifyListeners();
  }

  Future<void> markHabitIncomplete(String id, DateTime date) async {
    try {
      final habit = _storageService.getHabit(id);
      if (habit != null) {
        habit.completedDays.remove(date);
        await updateHabit(habit);
      }
    } catch (e) {
      _error = 'Failed to mark habit incomplete: $e';
      notifyListeners();
    }
  }

  Habit? getHabitById(String id) {
    return _storageService.getHabit(id);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
