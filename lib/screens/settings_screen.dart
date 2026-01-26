import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/game_provider.dart';
import '../providers/step_counter_provider.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSection(
            context,
            '앱 정보',
            [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('버전'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('앱 소개'),
                subtitle: const Text('걸으면 풀리는 퍼즐 게임'),
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            '데이터 관리',
            [
              ListTile(
                leading: const Icon(Icons.refresh, color: Colors.orange),
                title: const Text('진행 상황 초기화'),
                subtitle: const Text('모든 게임 진행 상황을 삭제합니다'),
                onTap: () => _showResetConfirmation(context),
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            '게임 통계',
            [
              Consumer2<GameProvider, StepCounterProvider>(
                builder: (context, gameProvider, stepProvider, child) {
                  final userProgress = gameProvider.userProgress;
                  final completedCount = userProgress?.completedPuzzles.length ?? 0;
                  final availableHints = userProgress?.availableHints ?? 0;

                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.flag, color: Colors.green),
                        title: const Text('완료한 스테이지'),
                        trailing: Text(
                          '$completedCount개',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.lightbulb, color: Colors.orange),
                        title: const Text('사용 가능한 힌트'),
                        trailing: Text(
                          '$availableHints개',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.directions_walk, color: Colors.blue),
                        title: const Text('오늘 걸음 수'),
                        trailing: Text(
                          '${stepProvider.todaySteps}보',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ...children,
      ],
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('진행 상황 초기화'),
        content: const Text(
          '모든 게임 진행 상황이 삭제됩니다.\n이 작업은 되돌릴 수 없습니다.\n\n정말 초기화하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _resetProgress(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('초기화'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetProgress(BuildContext context) async {
    try {
      final storageService = StorageService();
      await storageService.clearUserProgress();

      // 튜토리얼 본 기록도 초기화
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('has_seen_tutorial');

      // Provider 재초기화
      if (context.mounted) {
        final gameProvider = Provider.of<GameProvider>(context, listen: false);
        await gameProvider.initialize();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('진행 상황이 초기화되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('초기화 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
