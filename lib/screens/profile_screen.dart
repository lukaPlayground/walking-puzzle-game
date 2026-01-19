import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/step_counter_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer2<GameProvider, StepCounterProvider>(
        builder: (context, gameProvider, stepProvider, child) {
          final progress = gameProvider.userProgress;
          final currentStage = (progress?.completedPuzzles.length ?? 0) + 1;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '현재 스테이지',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Stage $currentStage',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '게임 통계',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          _buildStatRow(
                            context,
                            Icons.check_circle,
                            '완료한 스테이지',
                            '${progress?.completedPuzzles.length ?? 0}개',
                            Colors.green,
                          ),
                          const Divider(height: 24),
                          _buildStatRow(
                            context,
                            Icons.lightbulb,
                            '사용 가능한 힌트',
                            '${progress?.availableHints ?? 0}개',
                            Colors.orange,
                          ),
                          const Divider(height: 24),
                          _buildStatRow(
                            context,
                            Icons.lock_open,
                            '잠금 해제된 퍼즐',
                            '${progress?.unlockedPuzzles.length ?? 0}개',
                            Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '걸음 수 통계',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          _buildStatRow(
                            context,
                            Icons.directions_walk,
                            '오늘의 걸음 수',
                            '${stepProvider.todaySteps}걸음',
                            Theme.of(context).colorScheme.primary,
                          ),
                          const Divider(height: 24),
                          _buildStatRow(
                            context,
                            Icons.map,
                            '오늘의 거리',
                            '${stepProvider.todayDistanceKm.toStringAsFixed(2)} km',
                            Theme.of(context).colorScheme.secondary,
                          ),
                          const Divider(height: 24),
                          _buildStatRow(
                            context,
                            Icons.local_fire_department,
                            '소모 칼로리',
                            '${stepProvider.todayCalories.toStringAsFixed(0)} kcal',
                            Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
