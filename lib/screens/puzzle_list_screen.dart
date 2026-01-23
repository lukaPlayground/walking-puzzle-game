import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/step_counter_provider.dart';
import '../models/puzzle_model.dart';
import 'water_sort_puzzle_screen.dart';

class PuzzleListScreen extends StatelessWidget {
  const PuzzleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('퍼즐'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer2<GameProvider, StepCounterProvider>(
        builder: (context, gameProvider, stepProvider, child) {
          final userProgress = gameProvider.userProgress;
          final puzzles = gameProvider.puzzles;
          final completedCount = userProgress?.completedPuzzles.length ?? 0;
          final todaySteps = stepProvider.todaySteps;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 진행 상황 카드
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildProgressItem(
                          context,
                          Icons.flag,
                          '완료',
                          '$completedCount/${puzzles.length}',
                          Colors.green,
                        ),
                        Container(width: 1, height: 40, color: Colors.grey[300]),
                        _buildProgressItem(
                          context,
                          Icons.extension,
                          '총 스테이지',
                          '${puzzles.length}개',
                          Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 걸음 수 보상 진행 상황 카드
                _buildStepRewardCard(context, gameProvider, todaySteps),
                const SizedBox(height: 24),
                Text(
                  '플레이 가능한 스테이지',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                // 퍼즐 목록 (완료되지 않은 것만 표시)
                ...puzzles.asMap().entries.where((entry) {
                  final puzzle = entry.value;
                  final isCompleted = userProgress?.isPuzzleCompleted(puzzle.id) ?? false;
                  final isUnlocked = userProgress?.isPuzzleUnlocked(puzzle.id) ?? false;
                  // 완료되지 않았고 잠금 해제된 퍼즐만 표시
                  return !isCompleted && isUnlocked;
                }).map((entry) {
                  final index = entry.key;
                  final puzzle = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildPuzzleCard(
                      context,
                      puzzle,
                      index + 1,
                      isCompleted: false,
                      isUnlocked: true,
                    ),
                  );
                }).toList(),
                // 플레이 가능한 스테이지가 없는 경우
                if (puzzles.every((puzzle) => userProgress?.isPuzzleCompleted(puzzle.id) ?? false))
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.celebration,
                            size: 80,
                            color: Colors.amber,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '모든 스테이지를 완료했습니다!',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '정말 대단합니다! 🎉',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (puzzles.where((puzzle) {
                  final isCompleted = userProgress?.isPuzzleCompleted(puzzle.id) ?? false;
                  final isUnlocked = userProgress?.isPuzzleUnlocked(puzzle.id) ?? false;
                  return !isCompleted && isUnlocked;
                }).isEmpty && !puzzles.every((puzzle) => userProgress?.isPuzzleCompleted(puzzle.id) ?? false))
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        '현재 플레이 가능한 스테이지가 없습니다',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }

  Widget _buildStepRewardCard(
    BuildContext context,
    GameProvider gameProvider,
    int todaySteps,
  ) {
    final stepsUntilNextHint = gameProvider.getStepsUntilNextHint(todaySteps);
    final totalHintsFromSteps = gameProvider.getTotalHintsFromSteps(todaySteps);
    final progress = (todaySteps % GameProvider.stepsPerHint) / GameProvider.stepsPerHint;

    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.directions_walk,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  '걸음 수 보상',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
                const Spacer(),
                Icon(
                  Icons.lightbulb,
                  color: Colors.amber,
                  size: 24,
                ),
                const SizedBox(width: 4),
                Text(
                  '+$totalHintsFromSteps',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '다음 힌트까지 $stepsUntilNextHint보 남음 (${GameProvider.stepsPerHint}보당 힌트 1개)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPuzzleCard(
    BuildContext context,
    PuzzleModel puzzle,
    int stageNumber, {
    required bool isCompleted,
    required bool isUnlocked,
  }) {
    return Card(
      elevation: isUnlocked ? 4 : 2,
      child: InkWell(
        onTap: isUnlocked
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WaterSortPuzzleScreen(puzzle: puzzle),
                  ),
                );
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(puzzle.difficulty).withOpacity(isUnlocked ? 0.1 : 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getDifficultyColor(puzzle.difficulty).withOpacity(isUnlocked ? 1.0 : 0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          isCompleted
                              ? Icons.check_circle
                              : isUnlocked
                                  ? Icons.extension
                                  : Icons.lock,
                          size: 40,
                          color: _getDifficultyColor(puzzle.difficulty).withOpacity(isUnlocked ? 1.0 : 0.3),
                        ),
                      ),
                      if (isCompleted)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                puzzle.title,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isUnlocked ? null : Colors.grey,
                                    ),
                              ),
                            ),
                            if (isCompleted)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '완료',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (!isUnlocked)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '잠김',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.stars,
                              size: 18,
                              color: _getDifficultyColor(puzzle.difficulty),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getDifficultyText(puzzle.difficulty),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _getDifficultyColor(puzzle.difficulty),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                puzzle.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoChip(
                    context,
                    Icons.lightbulb_outline,
                    '힌트 ${puzzle.hintsAvailable}개',
                    Colors.orange,
                  ),
                  if (puzzle.isLocationBased)
                    _buildInfoChip(
                      context,
                      Icons.place,
                      '위치 보너스',
                      Colors.purple,
                    ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WaterSortPuzzleScreen(puzzle: puzzle),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow),
                    const SizedBox(width: 8),
                    Text(
                      '시작하기',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 1:
        return '쉬움';
      case 2:
        return '일반';
      case 3:
        return '어려움';
      case 4:
        return '매우 어려움';
      default:
        return '알 수 없음';
    }
  }
}
