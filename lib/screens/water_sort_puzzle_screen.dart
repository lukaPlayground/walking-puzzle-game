import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/water_tube.dart';
import '../models/puzzle_model.dart';
import '../providers/game_provider.dart';

class WaterSortPuzzleScreen extends StatefulWidget {
  final PuzzleModel puzzle;

  const WaterSortPuzzleScreen({
    super.key,
    required this.puzzle,
  });

  @override
  State<WaterSortPuzzleScreen> createState() => _WaterSortPuzzleScreenState();
}

class _WaterSortPuzzleScreenState extends State<WaterSortPuzzleScreen> {
  late List<WaterTube> tubes;
  int? selectedTubeId;
  int moveCount = 0;
  int maxMoves = 0;
  int colorCount = 0;
  bool isColorblindMode = false;

  @override
  void initState() {
    super.initState();
    _generatePuzzle();
  }

  void _generatePuzzle() {
    final difficulty = widget.puzzle.difficulty;
    int tubeCount;
    const int capacity = 4;
    const int emptyTubeCount = 2; // 항상 빈 튜브 2개

    // 난이도에 따른 총 튜브 수
    switch (difficulty) {
      case 1: // 쉬움
        tubeCount = 5; // 색상 3개 + 빈 튜브 2개
        break;
      case 2: // 일반
        tubeCount = 6; // 색상 4개 + 빈 튜브 2개
        break;
      case 3: // 어려움
        tubeCount = 7; // 색상 5개 + 빈 튜브 2개
        break;
      case 4: // 지옥
        tubeCount = 8; // 색상 6개 + 빈 튜브 2개
        break;
      default:
        tubeCount = 5;
    }

    // 색상 수 = 채워진 튜브 수
    colorCount = tubeCount - emptyTubeCount;

    // 이동 횟수 제한 설정 (난이도에 따라 조정)
    // 기본: (색상 수 * 8) + 추가 여유
    switch (difficulty) {
      case 1: // 쉬움
        maxMoves = 30; // 색상 3개
        break;
      case 2: // 일반
        maxMoves = 40; // 색상 4개
        break;
      case 3: // 어려움
        maxMoves = 50; // 색상 5개
        break;
      case 4: // 지옥
        maxMoves = 60; // 색상 6개
        break;
      default:
        maxMoves = 30;
    }

    // 색상 생성
    final colors = _generateColors(colorCount);

    // 모든 레이어 생성 (각 색상당 4개 레이어)
    final allLayers = <Color>[];
    for (final color in colors) {
      for (int i = 0; i < capacity; i++) {
        allLayers.add(color);
      }
    }

    // 퍼즐 ID를 기반으로 시드 생성하여 동일한 배치 보장
    final seed = widget.puzzle.id.hashCode;
    final random = Random(seed);

    // 섞기 (Fisher-Yates shuffle with seed)
    for (int i = allLayers.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = allLayers[i];
      allLayers[i] = allLayers[j];
      allLayers[j] = temp;
    }

    // 튜브 생성
    tubes = [];
    final filledTubeCount = colorCount;

    // 레이어를 튜브에 분배
    for (int i = 0; i < filledTubeCount; i++) {
      final tubeLayers = <Color?>[];
      for (int j = 0; j < capacity; j++) {
        final index = i * capacity + j;
        tubeLayers.add(allLayers[index]);
      }
      tubes.add(WaterTube(
        id: i,
        capacity: capacity,
        layers: tubeLayers,
      ));
    }

    // 빈 튜브 2개 추가
    for (int i = filledTubeCount; i < tubeCount; i++) {
      tubes.add(WaterTube(
        id: i,
        capacity: capacity,
        layers: List.filled(capacity, null),
      ));
    }
  }

  List<Color> _generateColors(int count) {
    final colors = <Color>[];
    for (int i = 0; i < count; i++) {
      final hue = (i * 360.0 / count) % 360;
      colors.add(HSLColor.fromAHSL(1.0, hue, 0.7, 0.5).toColor());
    }
    return colors;
  }

  void _onTubeTap(int tubeId) {
    setState(() {
      if (selectedTubeId == null) {
        // 첫 번째 선택 (붓는 튜브)
        final tube = tubes.firstWhere((t) => t.id == tubeId);
        if (!tube.isEmpty) {
          selectedTubeId = tubeId;
        }
      } else {
        // 두 번째 선택 (받는 튜브)
        if (selectedTubeId == tubeId) {
          // 같은 튜브 클릭 시 선택 취소
          selectedTubeId = null;
        } else {
          final sourceTube = tubes.firstWhere((t) => t.id == selectedTubeId);
          final destTube = tubes.firstWhere((t) => t.id == tubeId);

          if (sourceTube.canPourTo(destTube)) {
            sourceTube.pourTo(destTube);
            moveCount++;

            // 완료 체크
            if (_checkWin()) {
              _showWinDialog(success: true);
            } else if (moveCount >= maxMoves) {
              // 이동 횟수 초과
              _showWinDialog(success: false);
            }
          }
          selectedTubeId = null;
        }
      }
    });
  }

  bool _checkWin() {
    // 빈 튜브를 제외하고, 채워진 튜브가 모두 정렬되었는지 확인
    final filledTubes = tubes.where((tube) => !tube.isEmpty).toList();
    return filledTubes.length == colorCount && filledTubes.every((tube) => tube.isSorted);
  }

  void _showWinDialog({required bool success}) {
    final String title;
    final String message;
    final String emoji;

    if (success) {
      // 퍼즐 완료를 GameProvider에 저장
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      gameProvider.completePuzzle(widget.puzzle.id);

      emoji = '🎉';
      title = '완료!';
      if (moveCount <= maxMoves * 0.7) {
        message = '환상적입니다! $moveCount번 만에 퍼즐을 완성했습니다!\n⭐⭐⭐ 완벽한 클리어!';
      } else if (moveCount <= maxMoves * 0.9) {
        message = '훌륭합니다! $moveCount번 만에 퍼즐을 완성했습니다!\n⭐⭐ 멋진 클리어!';
      } else {
        message = '성공! $moveCount번 만에 퍼즐을 완성했습니다!\n⭐ 클리어!';
      }
    } else {
      emoji = '😅';
      title = '이동 횟수 초과!';
      message = '최대 이동 횟수($maxMoves)를 초과했습니다.\n다시 도전해보세요!';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('$emoji $title'),
        content: Text(message),
        actions: [
          if (!success)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetPuzzle();
              },
              child: const Text('다시 시도'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(success ? '확인' : '닫기'),
          ),
        ],
      ),
    );
  }

  void _resetPuzzle() {
    setState(() {
      moveCount = 0;
      selectedTubeId = null;
      _generatePuzzle();
    });
  }

  void _useHint() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final hints = gameProvider.userProgress?.availableHints ?? 0;

    if (hints <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용 가능한 힌트가 없습니다')),
      );
      return;
    }

    // 가능한 이동 찾기
    final move = _findBestMove();

    if (move == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('더 이상 이동할 수 없습니다')),
      );
      return;
    }

    // 힌트 사용
    gameProvider.useHint();

    // 이동 실행
    setState(() {
      final sourceTube = tubes.firstWhere((t) => t.id == move['from']);
      final destTube = tubes.firstWhere((t) => t.id == move['to']);

      sourceTube.pourTo(destTube);
      moveCount++;

      // 완료 체크
      if (_checkWin()) {
        _showWinDialog(success: true);
      } else if (moveCount >= maxMoves) {
        _showWinDialog(success: false);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('힌트를 사용했습니다! (남은 힌트: ${hints - 1}개)'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Map<String, int>? _findBestMove() {
    // 1순위: 같은 색상끼리 합치기 (완성에 가까워짐)
    for (final sourceTube in tubes) {
      if (sourceTube.isEmpty || sourceTube.isSorted) continue;

      for (final destTube in tubes) {
        if (sourceTube.id == destTube.id) continue;
        if (!sourceTube.canPourTo(destTube)) continue;

        // 같은 색상을 합치는 경우
        if (!destTube.isEmpty && sourceTube.topColor == destTube.topColor) {
          return {'from': sourceTube.id, 'to': destTube.id};
        }
      }
    }

    // 2순위: 빈 튜브로 이동 (공간 확보)
    for (final sourceTube in tubes) {
      if (sourceTube.isEmpty || sourceTube.isSorted) continue;

      for (final destTube in tubes) {
        if (sourceTube.id == destTube.id) continue;
        if (!destTube.isEmpty) continue;
        if (!sourceTube.canPourTo(destTube)) continue;

        return {'from': sourceTube.id, 'to': destTube.id};
      }
    }

    // 3순위: 아무 가능한 이동
    for (final sourceTube in tubes) {
      if (sourceTube.isEmpty || sourceTube.isSorted) continue;

      for (final destTube in tubes) {
        if (sourceTube.id == destTube.id) continue;
        if (!sourceTube.canPourTo(destTube)) continue;

        return {'from': sourceTube.id, 'to': destTube.id};
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzle.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              final hints = gameProvider.userProgress?.availableHints ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.lightbulb_outline),
                    onPressed: hints > 0 ? _useHint : null,
                    tooltip: '힌트 사용 ($hints개)',
                    color: hints > 0 ? Colors.orange : Colors.grey,
                  ),
                  if (hints > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$hints',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: Icon(
              isColorblindMode ? Icons.visibility : Icons.visibility_off,
              color: isColorblindMode ? Colors.green : null,
            ),
            onPressed: () {
              setState(() {
                isColorblindMode = !isColorblindMode;
              });
            },
            tooltip: '색약 모드',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetPuzzle,
            tooltip: '다시 시작',
          ),
        ],
      ),
      body: Column(
        children: [
          // 정보 패널
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  Icons.swap_horiz,
                  '이동 횟수',
                  '$moveCount / $maxMoves',
                  color: moveCount > maxMoves
                      ? Colors.red
                      : moveCount > maxMoves * 0.8
                          ? Colors.orange
                          : null,
                ),
                _buildInfoItem(
                  Icons.check_circle,
                  '완료된 튜브',
                  '${tubes.where((t) => t.isSorted).length} / $colorCount',
                ),
                Consumer<GameProvider>(
                  builder: (context, gameProvider, child) {
                    final hints = gameProvider.userProgress?.availableHints ?? 0;
                    return GestureDetector(
                      onTap: hints > 0 ? _useHint : null,
                      child: _buildInfoItem(
                        Icons.lightbulb,
                        '힌트',
                        '$hints개',
                        color: hints > 0 ? Colors.orange : Colors.grey,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // 튜브 영역
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: tubes.map((tube) {
                      return _buildTube(tube);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey[700]),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTube(WaterTube tube) {
    final isSelected = selectedTubeId == tube.id;
    final canReceive = selectedTubeId != null &&
                       selectedTubeId != tube.id &&
                       tubes.firstWhere((t) => t.id == selectedTubeId).canPourTo(tube);

    return GestureDetector(
      onTap: () => _onTubeTap(tube.id),
      child: Container(
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : canReceive
                    ? Colors.green
                    : Colors.transparent,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // 튜브 본체
            Container(
              width: 50,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[800]!, width: 3),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(tube.capacity, (index) {
                    return Expanded(
                      child: _buildLayer(tube.layers[index], index),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 4),
            // 튜브 번호
            Text(
              '${tube.id + 1}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayer(Color? color, int index) {
    if (color == null) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            top: index > 0 ? BorderSide(color: Colors.grey[400]!, width: 0.5) : BorderSide.none,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border(
          top: index > 0 ? const BorderSide(color: Colors.white24, width: 1) : BorderSide.none,
        ),
      ),
      child: isColorblindMode
          ? Center(
              child: Icon(
                _getPatternIcon(color),
                color: Colors.white,
                size: 20,
              ),
            )
          : null,
    );
  }

  IconData _getPatternIcon(Color color) {
    // 색상의 HSL hue 값으로 패턴 결정
    final hslColor = HSLColor.fromColor(color);
    final hue = hslColor.hue;

    if (hue < 60) return Icons.circle;
    if (hue < 120) return Icons.square;
    if (hue < 180) return Icons.star;
    if (hue < 240) return Icons.hexagon;
    if (hue < 300) return Icons.change_history;
    return Icons.favorite;
  }
}
