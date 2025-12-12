import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  Habit? _selectedHabit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.red.shade600,
        title: const Text(
          '🔧 Admin Panel',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warning Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red.shade600),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '⚠️ Admin Mode - Use with caution!\nChanges here affect real data.',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Habit Selector
                const Text(
                  'Select Habit to Test',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                if (habitProvider.habits.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'No habits available\nCreate some habits first!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...habitProvider.habits.map((habit) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: RadioListTile<Habit>(
                      title: Row(
                        children: [
                          Text(habit.name),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getEvolutionColor(habit.evolution).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Lv.${habit.evolutionLevel}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _getEvolutionColor(habit.evolution),
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text('${habit.completedDays.length}/${habit.raceLength} days'),
                      value: habit,
                      selected: _selectedHabit == habit,
                      onChanged: (habit) => setState(() => _selectedHabit = habit),
                    ),
                  )),

                const SizedBox(height: 24),

                // Testing Tools
                if (_selectedHabit != null) ...[
                  const Text(
                    'Testing Tools',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildAdminCard(
                    title: 'Quick Completions',
                    description: 'Add multiple completion days at once',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _addCompletions(context, 1),
                              icon: const Icon(Icons.add),
                              label: const Text('Add 1 Day'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _addCompletions(context, 3),
                              icon: const Icon(Icons.add),
                              label: const Text('Add 3 Days'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _addCompletions(context, 7),
                              icon: const Icon(Icons.add),
                              label: const Text('Add 7 Days'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _addCompletions(context, 15),
                              icon: const Icon(Icons.add),
                              label: const Text('Add 15 Days'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  _buildAdminCard(
                    title: 'Evolution Control',
                    description: 'Force evolution or reset level',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _forceEvolution(context),
                              icon: const Icon(Icons.upgrade),
                              label: const Text('Force Evolve'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _resetEvolution(context),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reset to Seed'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  _buildAdminCard(
                    title: 'Habit Management',
                    description: 'Modify habit properties',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _completeToday(context),
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Complete Today'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _clearCompletions(context),
                              icon: const Icon(Icons.clear),
                              label: const Text('Clear All'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  _buildAdminCard(
                    title: 'Habit Details',
                    description: 'View internal state',
                    children: [
                      _buildDetailRow('ID', _selectedHabit!.id),
                      _buildDetailRow('Name', _selectedHabit!.name),
                      _buildDetailRow('Evolution', '${_selectedHabit!.evolutionName} (Lv.${_selectedHabit!.evolutionLevel})'),
                      _buildDetailRow('Progress', '${(_selectedHabit!.progress * 100).toInt()}%'),
                      _buildDetailRow('Completed Days', _selectedHabit!.completedDays.length.toString()),
                      _buildDetailRow('Remaining Days', _selectedHabit!.remainingDays.toString()),
                      _buildDetailRow('Current Streak', _selectedHabit!.currentStreak.toString()),
                      _buildDetailRow('Can Evolve', _selectedHabit!.canEvolve ? 'Yes' : 'No'),
                    ],
                  ),
                ],

                const SizedBox(height: 24),

                // Global Tools
                const Text(
                  'Global Tools',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                _buildAdminCard(
                  title: 'Generate Test Data',
                  description: 'Create sample habits for testing',
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _generateTestData(context),
                      icon: const Icon(Icons.science),
                      label: const Text('Create Test Habits'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ),

                _buildAdminCard(
                  title: 'Clear All Data',
                  description: '⚠️ Delete all habits (irreversible)',
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _clearAllData(context),
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('Clear Everything'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdminCard({
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  void _addCompletions(BuildContext context, int days) {
    if (_selectedHabit == null) return;

    final habitProvider = context.read<HabitProvider>();
    final today = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = today.subtract(Duration(days: i));
      if (!_selectedHabit!.completedDays.any((d) =>
          d.year == date.year && d.month == date.month && d.day == date.day)) {
        _selectedHabit!.completedDays.add(date);
      }
    }

    habitProvider.updateHabit(_selectedHabit!);
    _showSnackBar(context, 'Added $days completion days');
  }

  void _forceEvolution(BuildContext context) {
    if (_selectedHabit == null) return;

    final habitProvider = context.read<HabitProvider>();
    if (_selectedHabit!.canEvolve) {
      _selectedHabit!.evolution = _selectedHabit!.nextEvolution;
      habitProvider.updateHabit(_selectedHabit!);
      _showSnackBar(context, 'Forced evolution to ${_selectedHabit!.evolutionName}');
    } else {
      _showSnackBar(context, 'Habit cannot evolve yet');
    }
  }

  void _resetEvolution(BuildContext context) {
    if (_selectedHabit == null) return;

    final habitProvider = context.read<HabitProvider>();
    _selectedHabit!.evolution = HabitEvolution.seed;
    habitProvider.updateHabit(_selectedHabit!);
    _showSnackBar(context, 'Reset to Seed level');
  }

  void _completeToday(BuildContext context) {
    if (_selectedHabit == null) return;

    final habitProvider = context.read<HabitProvider>();
    habitProvider.completeHabitToday(_selectedHabit!.id);
    _showSnackBar(context, 'Completed today');
  }

  void _clearCompletions(BuildContext context) {
    if (_selectedHabit == null) return;

    final habitProvider = context.read<HabitProvider>();
    _selectedHabit!.completedDays.clear();
    habitProvider.updateHabit(_selectedHabit!);
    _showSnackBar(context, 'Cleared all completions');
  }

  void _generateTestData(BuildContext context) {
    final habitProvider = context.read<HabitProvider>();

    // Create test habits with different evolution levels
    final testHabits = [
      Habit(
        id: 'test_seed',
        name: 'Seed Habit',
        description: 'Just started - should be at Seed level',
        raceLength: 7,
        difficulty: Difficulty.easy,
        theme: HabitTheme.road,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        completedDays: [DateTime.now().subtract(const Duration(days: 1))],
        evolution: HabitEvolution.seed,
      ),
      Habit(
        id: 'test_sprout',
        name: 'Sprout Habit',
        description: 'Getting consistent - should evolve to Sprout',
        raceLength: 14,
        difficulty: Difficulty.normal,
        theme: HabitTheme.ocean,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        completedDays: List.generate(4, (i) => DateTime.now().subtract(Duration(days: i))),
        evolution: HabitEvolution.sprout,
      ),
      Habit(
        id: 'test_bloom',
        name: 'Bloom Habit',
        description: 'Well established - should evolve to Bloom',
        raceLength: 30,
        difficulty: Difficulty.hard,
        theme: HabitTheme.mountain,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        completedDays: List.generate(10, (i) => DateTime.now().subtract(Duration(days: i))),
        evolution: HabitEvolution.bloom,
      ),
      Habit(
        id: 'test_ancient',
        name: 'Ancient Habit',
        description: 'Master level - Ancient evolution',
        raceLength: 30,
        difficulty: Difficulty.hard,
        theme: HabitTheme.space,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        completedDays: List.generate(25, (i) => DateTime.now().subtract(Duration(days: i))),
        evolution: HabitEvolution.ancient,
      ),
    ];

    for (final habit in testHabits) {
      habitProvider.addHabit(habit);
    }

    _showSnackBar(context, 'Created 4 test habits with different evolution levels');
  }

  void _clearAllData(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Clear All Data'),
        content: const Text(
          'This will permanently delete ALL habits. This action cannot be undone.\n\nAre you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final habitProvider = context.read<HabitProvider>();
              // This would need to be implemented in the provider
              // For now, just clear the local list
              for (final habit in habitProvider.habits) {
                habitProvider.deleteHabit(habit.id);
              }
              Navigator.of(context).pop();
              _showSnackBar(context, 'All data cleared');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('DELETE EVERYTHING'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _getEvolutionColor(HabitEvolution evolution) {
    switch (evolution) {
      case HabitEvolution.seed:
        return Colors.grey;
      case HabitEvolution.sprout:
        return Colors.green;
      case HabitEvolution.bloom:
        return Colors.blue;
      case HabitEvolution.ancient:
        return Colors.purple;
    }
  }
}
