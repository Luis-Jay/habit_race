import 'package:flutter/material.dart';
import '../models/habit.dart';

class EvolutionCelebration extends StatefulWidget {
  final Habit habit;
  final HabitEvolution newEvolution;
  final VoidCallback onDismiss;

  const EvolutionCelebration({
    super.key,
    required this.habit,
    required this.newEvolution,
    required this.onDismiss,
  });

  @override
  State<EvolutionCelebration> createState() => _EvolutionCelebrationState();
}

class _EvolutionCelebrationState extends State<EvolutionCelebration>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_glowController);

    // Start the animation
    _scaleController.forward();

    // Auto dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Color _getEvolutionColor() {
    switch (widget.newEvolution) {
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

  IconData _getEvolutionIcon() {
    switch (widget.newEvolution) {
      case HabitEvolution.seed:
        return Icons.grain;
      case HabitEvolution.sprout:
        return Icons.grass;
      case HabitEvolution.bloom:
        return Icons.local_florist;
      case HabitEvolution.ancient:
        return Icons.park;
    }
  }

  String _getEvolutionMessage() {
    switch (widget.newEvolution) {
      case HabitEvolution.sprout:
        return 'Your habit has sprouted! 🌱';
      case HabitEvolution.bloom:
        return 'Your habit is blooming beautifully! 🌸';
      case HabitEvolution.ancient:
        return 'Your habit has become ancient wisdom! 🌿';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
      builder: (context, child) {
        return Container(
          color: Colors.black.withValues(alpha: 0.7),
          child: Center(
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _getEvolutionColor().withValues(alpha: _glowAnimation.value * 0.5),
                      blurRadius: 20 + (_glowAnimation.value * 10),
                      spreadRadius: _glowAnimation.value * 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Evolution icon with glow
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _getEvolutionColor().withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _getEvolutionColor().withValues(alpha: _glowAnimation.value * 0.6),
                            blurRadius: 15 + (_glowAnimation.value * 5),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        _getEvolutionIcon(),
                        size: 60,
                        color: _getEvolutionColor(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Habit name
                    Text(
                      widget.habit.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    // Evolution message
                    Text(
                      _getEvolutionMessage(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // Evolution level
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getEvolutionColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getEvolutionColor().withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'Level ${widget.habit.evolutionLevel} - ${widget.habit.evolutionName}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getEvolutionColor(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          '${widget.habit.completedDays.length}',
                          'Completions',
                          Icons.check_circle,
                          Colors.green,
                        ),
                        _buildStatItem(
                          '${widget.habit.currentStreak}',
                          'Day Streak',
                          Icons.local_fire_department,
                          Colors.orange,
                        ),
                        _buildStatItem(
                          '${(widget.habit.progress * 100).toInt()}%',
                          'Progress',
                          Icons.show_chart,
                          Colors.blue,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: widget.onDismiss,
                        style: FilledButton.styleFrom(
                          backgroundColor: _getEvolutionColor(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Continue Your Journey',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
