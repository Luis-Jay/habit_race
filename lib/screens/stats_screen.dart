import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          if (habitProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading statistics...'),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true,
                title: const Text(
                  'Your Progress',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Overview Cards
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Total Habits',
                            value: habitProvider.totalHabitsCreated.toString(),
                            icon: Icons.track_changes,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Active',
                            value: habitProvider.totalActiveHabits.toString(),
                            icon: Icons.directions_run,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Completed',
                            value: habitProvider.totalCompletedHabits.toString(),
                            icon: Icons.emoji_events,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Current Streak',
                            value: '${habitProvider.currentStreak}d',
                            icon: Icons.local_fire_department,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Average Completion Rate
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.show_chart, color: Colors.purple),
                                const SizedBox(width: 12),
                                const Text(
                                  'Average Completion Rate',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            LinearProgressIndicator(
                              value: habitProvider.averageCompletionRate.clamp(0.0, 1.0),
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${(habitProvider.averageCompletionRate * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Theme Distribution
                    if (habitProvider.habitsByTheme.isNotEmpty) ...[
                      const Text(
                        'Habits by Theme',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: habitProvider.habitsByTheme.entries.map((entry) {
                              final themeColor = _getThemeColor(entry.key);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        entry.key.toUpperCase(),
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Text(
                                      '${entry.value}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Difficulty Distribution
                    if (habitProvider.habitsByDifficulty.isNotEmpty) ...[
                      const Text(
                        'Habits by Difficulty',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: habitProvider.habitsByDifficulty.entries.map((entry) {
                              final difficultyColor = _getDifficultyColor(entry.key);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: difficultyColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        entry.key.toUpperCase(),
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Text(
                                      '${entry.value}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Completed Habits List
                    if (habitProvider.completedHabits.isNotEmpty) ...[
                      const Text(
                        'Completed Habits',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...habitProvider.completedHabits.map((habit) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            _getThemeIcon(habit.theme),
                            color: _getThemeColor(habit.theme.name),
                          ),
                          title: Text(habit.name),
                          subtitle: Text(
                            'Completed on ${habit.createdAt.add(Duration(days: habit.raceLength)).toLocal().toString().split(' ')[0]}',
                          ),
                          trailing: const Icon(Icons.check_circle, color: Colors.green),
                        ),
                      )),
                    ],
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static Color _getThemeColor(String themeName) {
    switch (themeName) {
      case 'road':
        return const Color(0xFF6C5CE7);
      case 'ocean':
        return const Color(0xFF0984E3);
      case 'mountain':
        return const Color(0xFF00B894);
      case 'space':
        return const Color(0xFFE84393);
      default:
        return const Color(0xFF6C5CE7);
    }
  }

  static IconData _getThemeIcon(HabitTheme theme) {
    switch (theme) {
      case HabitTheme.road:
        return Icons.directions_car;
      case HabitTheme.ocean:
        return Icons.sailing;
      case HabitTheme.mountain:
        return Icons.landscape;
      case HabitTheme.space:
        return Icons.rocket_launch;
    }
  }

  static Color _getDifficultyColor(String difficultyName) {
    switch (difficultyName) {
      case 'easy':
        return Colors.green;
      case 'normal':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
