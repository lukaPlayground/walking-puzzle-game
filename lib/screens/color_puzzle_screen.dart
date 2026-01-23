import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/puzzle_model.dart';
import '../models/color_tile.dart';
import '../providers/game_provider.dart';

class ColorPuzzleScreen extends StatefulWidget {
  final PuzzleModel puzzle;

  const ColorPuzzleScreen({
    super.key,
    required this.puzzle,
  });

  @override
  State<ColorPuzzleScreen> createState() => _ColorPuzzleScreenState();
}

class _ColorPuzzleScreenState extends State<ColorPuzzleScreen> {
  List<ColorTile> _tiles = [];
  final double _tileSize = 80.0;
  final double _snapTolerance = 20.0;
  final List<String> _revealedHints = [];
  bool _isColorblindMode = false;

  // A구역 (조립 영역) 설정
  late Rect _assemblyZone;

  // 흔들림 감지
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  double _shakeThreshold = 15.0;
  DateTime? _lastShakeTime;

  @override
  void initState() {
    super.initState();
    _initializeAssemblyZone();
    _initializePuzzle();
    _startShakeDetection();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void _initializeAssemblyZone() {
    final gridWidth = widget.puzzle.gridColumns * _tileSize;
    final gridHeight = widget.puzzle.gridRows * _tileSize;
    final centerX = 200.0;
    final centerY = 300.0;

    _assemblyZone = Rect.fromLTWH(
      centerX - gridWidth / 2,
      centerY - gridHeight / 2,
      gridWidth,
      gridHeight,
    );
  }

  void _startShakeDetection() {
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      final magnitude = math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      if (magnitude > _shakeThreshold) {
        final now = DateTime.now();
        if (_lastShakeTime == null || now.difference(_lastShakeTime!) > const Duration(seconds: 1)) {
          _lastShakeTime = now;
          _onShakeDetected();
        }
      }
    });
  }

  void _onShakeDetected() {
    setState(() {
      final random = math.Random();
      final screenWidth = 400.0;
      final screenHeight = 600.0;

      for (var tile in _tiles) {
        if (!tile.isPlaced) {
          double randomX, randomY;
          do {
            randomX = random.nextDouble() * (screenWidth - _tileSize);
            randomY = random.nextDouble() * (screenHeight - _tileSize);
          } while (_assemblyZone.contains(Offset(randomX + _tileSize / 2, randomY + _tileSize / 2)));

          tile.currentPosition = Offset(randomX, randomY);
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('흔들림 감지! 타일들이 무너졌습니다 😱'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _initializePuzzle() {
    final random = math.Random(widget.puzzle.id.hashCode);
    _tiles = [];

    // 난이도별 색상 생성
    final colors = _generateColorsForDifficulty(widget.puzzle.difficulty);

    // 타일 생성
    int colorIndex = 0;
    for (int row = 0; row < widget.puzzle.gridRows; row++) {
      for (int col = 0; col < widget.puzzle.gridColumns; col++) {
        final correctX = _assemblyZone.left + col * _tileSize;
        final correctY = _assemblyZone.top + row * _tileSize;

        final tile = ColorTile(
          row: row,
          column: col,
          color: colors[colorIndex % colors.length],
          colorGroupId: colorIndex % colors.length,
          currentPosition: Offset(correctX, correctY),
          correctPosition: Offset(correctX, correctY),
        );

        _tiles.add(tile);
        colorIndex++;
      }
    }

    // 타일 섞기
    _shuffleTiles(random);
  }

  List<Color> _generateColorsForDifficulty(int difficulty) {
    switch (difficulty) {
      case 1: // 쉬움: 4가지 뚜렷한 색상
        return [
          Colors.red.shade400,
          Colors.blue.shade400,
          Colors.green.shade400,
          Colors.yellow.shade600,
        ];

      case 2: // 일반: 3가지 색상 + 그라데이션
        return [
          Colors.purple.shade300,
          Colors.purple.shade500,
          Colors.purple.shade700,
          Colors.orange.shade300,
          Colors.orange.shade500,
          Colors.orange.shade700,
          Colors.teal.shade300,
          Colors.teal.shade500,
          Colors.teal.shade700,
        ];

      case 3: // 어려움: 2가지 색상 + 그라데이션
        return [
          Colors.pink.shade200,
          Colors.pink.shade300,
          Colors.pink.shade400,
          Colors.pink.shade500,
          Colors.pink.shade600,
          Colors.indigo.shade200,
          Colors.indigo.shade300,
          Colors.indigo.shade400,
          Colors.indigo.shade500,
          Colors.indigo.shade600,
        ];

      case 4: // 지옥: 1가지 색상 + 투명도 그라데이션
        final baseColor = Colors.deepPurple;
        return [
          baseColor.withOpacity(0.3),
          baseColor.withOpacity(0.4),
          baseColor.withOpacity(0.5),
          baseColor.withOpacity(0.6),
          baseColor.withOpacity(0.7),
          baseColor.withOpacity(0.8),
          baseColor.withOpacity(0.9),
          baseColor.withOpacity(1.0),
        ];

      default:
        return [Colors.grey];
    }
  }

  void _shuffleTiles(math.Random random) {
    final screenWidth = 400.0;
    final screenHeight = 700.0;

    for (var tile in _tiles) {
      if (tile.isPlaced) continue;

      double randomX, randomY;
      do {
        randomX = random.nextDouble() * (screenWidth - _tileSize);
        randomY = random.nextDouble() * (screenHeight - _tileSize);
      } while (_assemblyZone.contains(Offset(randomX + _tileSize / 2, randomY + _tileSize / 2)));

      tile.currentPosition = Offset(randomX, randomY);
    }
  }

  void _onTileDragEnd(ColorTile tile, DraggableDetails details) {
    setState(() {
      final renderBox = context.findRenderObject() as RenderBox;
      tile.currentPosition = renderBox.globalToLocal(details.offset);

      final tileCenterX = tile.currentPosition.dx + _tileSize / 2;
      final tileCenterY = tile.currentPosition.dy + _tileSize / 2;
      final isInZone = _assemblyZone.contains(Offset(tileCenterX, tileCenterY));

      if (isInZone && tile.isInCorrectPosition(_snapTolerance)) {
        tile.currentPosition = tile.correctPosition;
        tile.isPlaced = true;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('타일이 맞춰졌습니다! 🎉'),
            duration: Duration(milliseconds: 500),
          ),
        );

        _checkPuzzleCompletion();
      }
    });
  }

  void _checkPuzzleCompletion() {
    final allPlaced = _tiles.every((tile) => tile.isPlaced);

    if (allPlaced) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _showSuccessDialog();
      });
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
              '퍼즐 완성!',
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
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('다음 스테이지로'),
          ),
        ],
      ),
    );
  }

  Widget _buildColorblindPattern(Color color, int groupId) {
    // 색약 모드: 패턴으로 구분
    if (!_isColorblindMode) return Container();

    final patterns = [
      Icons.circle,
      Icons.square,
      Icons.star,
      Icons.hexagon,
      Icons.change_history, // 삼각형
    ];

    return Icon(
      patterns[groupId % patterns.length],
      color: Colors.white,
      size: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzle.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_isColorblindMode ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isColorblindMode = !_isColorblindMode;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isColorblindMode ? '색약 모드 활성화' : '색약 모드 비활성화'),
                  duration: const Duration(milliseconds: 500),
                ),
              );
            },
            tooltip: '색약 모드',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _initializePuzzle();
              });
            },
            tooltip: '퍼즐 다시 섞기',
          ),
        ],
      ),
      body: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.5,
        maxScale: 3.0,
        child: Stack(
          children: [
            // A구역 (조립 영역) 표시
            Positioned(
              left: _assemblyZone.left,
              top: _assemblyZone.top,
              child: Container(
                width: _assemblyZone.width,
                height: _assemblyZone.height,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.5),
                    width: 3,
                  ),
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            // 배경 (올바른 위치 표시)
            ..._tiles.map((tile) {
              return Positioned(
                left: tile.correctPosition.dx,
                top: tile.correctPosition.dy,
                child: Container(
                  width: _tileSize,
                  height: _tileSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }),

            // 드래그 가능한 타일들
            ..._tiles.map((tile) {
              if (tile.isPlaced) {
                return Positioned(
                  left: tile.currentPosition.dx,
                  top: tile.currentPosition.dy,
                  child: Container(
                    width: _tileSize,
                    height: _tileSize,
                    decoration: BoxDecoration(
                      color: tile.color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade700, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _buildColorblindPattern(tile.color, tile.colorGroupId),
                    ),
                  ),
                );
              }

              return Positioned(
                left: tile.currentPosition.dx,
                top: tile.currentPosition.dy,
                child: Draggable<ColorTile>(
                  data: tile,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: _tileSize,
                      height: _tileSize,
                      decoration: BoxDecoration(
                        color: tile.color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _buildColorblindPattern(tile.color, tile.colorGroupId),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    width: _tileSize,
                    height: _tileSize,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onDragEnd: (details) => _onTileDragEnd(tile, details),
                  child: Container(
                    width: _tileSize,
                    height: _tileSize,
                    decoration: BoxDecoration(
                      color: tile.color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _buildColorblindPattern(tile.color, tile.colorGroupId),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              if (_revealedHints.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...(_revealedHints.take(1).map((hint) => Text(
                      hint,
                      style: Theme.of(context).textTheme.bodySmall,
                    ))),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _useHint,
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text('힌트 사용하기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
