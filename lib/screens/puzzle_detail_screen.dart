import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/puzzle_model.dart';
import '../providers/game_provider.dart';
import '../widgets/puzzle_grid_painter.dart';

class PuzzleDetailScreen extends StatefulWidget {
  final PuzzleModel puzzle;

  const PuzzleDetailScreen({
    super.key,
    required this.puzzle,
  });

  @override
  State<PuzzleDetailScreen> createState() => _PuzzleDetailScreenState();
}

class _PuzzleDetailScreenState extends State<PuzzleDetailScreen> {
  final TextEditingController _answerController = TextEditingController();
  final List<String> _revealedHints = [];
  double _currentOpacity = 0.9; // 초기 투명도 (90% 투명)

  @override
  void initState() {
    super.initState();
    _setInitialOpacity();
  }

  void _setInitialOpacity() {
    // 난이도별 초기 투명도 설정
    switch (widget.puzzle.difficulty) {
      case 1: // 쉬움
        _currentOpacity = 0.7;
        break;
      case 2: // 일반
        _currentOpacity = 0.8;
        break;
      case 3: // 어려움
        _currentOpacity = 0.85;
        break;
      case 4: // 매우 어려움
        _currentOpacity = 0.9;
        break;
    }
  }

  void _useHint() {
    final gameProvider = context.read<GameProvider>();
    final userProgress = gameProvider.userProgress;

    if (userProgress == null || userProgress.availableHints <= 0) {
      _showWalkingMissionDialog();
      return;
    }

    if (_revealedHints.length >= widget.puzzle.hints.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('더 이상 사용 가능한 힌트가 없습니다')),
      );
      return;
    }

    setState(() {
      _revealedHints.add(widget.puzzle.hints[_revealedHints.length]);
      _currentOpacity = (_currentOpacity - 0.15).clamp(0.0, 1.0);
    });

    gameProvider.useHint();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('힌트 사용! (남은 힌트: ${userProgress.availableHints - 1}개)')),
    );
  }

  void _showWalkingMissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('힌트가 부족합니다'),
        content: const Text('걸음 미션을 완료하여 힌트를 얻으시겠습니까?\n\n지금부터 500걸음을 걸으면 힌트 1개를 획득할 수 있습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 실시간 걷기 미션 화면으로 이동
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('걷기 미션 화면 (구현 예정)')),
              );
            },
            child: const Text('시작하기'),
          ),
        ],
      ),
    );
  }

  void _checkAnswer() {
    final answer = _answerController.text.trim();

    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('정답을 입력해주세요')),
      );
      return;
    }

    if (answer == widget.puzzle.answer) {
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('틀렸습니다! 다시 시도해보세요'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.celebration, color: Colors.amber, size: 32),
            const SizedBox(width: 12),
            Text(
              '정답입니다!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            Text(
              '${widget.puzzle.title}을(를) 완료했습니다!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final gameProvider = context.read<GameProvider>();
              gameProvider.completePuzzle(widget.puzzle.id);
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context); // 퍼즐 상세 화면 닫기
            },
            child: const Text('다음 스테이지로'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzle.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 퍼즐 정보 카드
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.extension,
                          color: _getDifficultyColor(widget.puzzle.difficulty),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getDifficultyText(widget.puzzle.difficulty),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getDifficultyColor(widget.puzzle.difficulty),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${widget.puzzle.totalPieces}조각',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.puzzle.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 퍼즐 그리드
            AspectRatio(
              aspectRatio: widget.puzzle.gridColumns / widget.puzzle.gridRows,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomPaint(
                    painter: PuzzleGridPainter(
                      rows: widget.puzzle.gridRows,
                      columns: widget.puzzle.gridColumns,
                      opacity: _currentOpacity,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 힌트 섹션
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          '힌트',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Spacer(),
                        Consumer<GameProvider>(
                          builder: (context, gameProvider, child) {
                            final hints = gameProvider.userProgress?.availableHints ?? 0;
                            return Text(
                              '보유: $hints개',
                              style: TextStyle(
                                fontSize: 14,
                                color: hints > 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_revealedHints.isEmpty)
                      const Text('힌트를 사용하여 퍼즐을 더 쉽게 풀어보세요!')
                    else
                      ..._revealedHints.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(entry.value),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _useHint,
                      icon: const Icon(Icons.lightbulb_outline),
                      label: const Text('힌트 사용하기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 정답 입력 섹션
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '정답 입력',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _answerController,
                      decoration: const InputDecoration(
                        hintText: '정답을 입력하세요',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.edit),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _checkAnswer,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          '제출하기',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
