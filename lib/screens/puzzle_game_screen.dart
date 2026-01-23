import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/puzzle_model.dart';
import '../models/puzzle_piece.dart';
import '../providers/game_provider.dart';
import '../widgets/puzzle_piece_painter.dart';

class PuzzleGameScreen extends StatefulWidget {
  final PuzzleModel puzzle;

  const PuzzleGameScreen({
    super.key,
    required this.puzzle,
  });

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  List<PuzzlePiece> _pieces = [];
  final double _pieceSize = 80.0;
  final double _snapTolerance = 20.0;
  final List<String> _revealedHints = [];

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
    // A구역: 화면 중앙에 퍼즐이 완성될 영역
    final gridWidth = widget.puzzle.gridColumns * _pieceSize;
    final gridHeight = widget.puzzle.gridRows * _pieceSize;
    final centerX = 200.0; // 대략적인 화면 중심
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
      // 고정되지 않은 조각들을 A구역 바깥으로 흩어뜨림
      final random = math.Random();
      final screenWidth = 400.0;
      final screenHeight = 600.0;

      for (var piece in _pieces) {
        if (!piece.isPlaced) {
          // A구역 바깥으로 랜덤 배치
          double randomX, randomY;
          do {
            randomX = random.nextDouble() * (screenWidth - _pieceSize);
            randomY = random.nextDouble() * (screenHeight - _pieceSize);
          } while (_assemblyZone.contains(Offset(randomX + _pieceSize / 2, randomY + _pieceSize / 2)));

          piece.currentPosition = Offset(randomX, randomY);
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('흔들림 감지! 조각들이 무너졌습니다 😱'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _initializePuzzle() {
    final random = math.Random(widget.puzzle.id.hashCode);
    _pieces = [];

    // 엣지 타입 저장용 (인접 조각과 맞물리게)
    final horizontalEdges = <int, List<EdgeType>>{};
    final verticalEdges = <int, List<EdgeType>>{};

    // 퍼즐 조각 생성
    for (int row = 0; row < widget.puzzle.gridRows; row++) {
      for (int col = 0; col < widget.puzzle.gridColumns; col++) {
        final piece = _createPuzzlePiece(row, col, random, horizontalEdges, verticalEdges);
        _pieces.add(piece);
      }
    }

    // 조각 섞기
    _shufflePieces(random);
  }

  PuzzlePiece _createPuzzlePiece(
    int row,
    int col,
    math.Random random,
    Map<int, List<EdgeType>> horizontalEdges,
    Map<int, List<EdgeType>> verticalEdges,
  ) {
    // 위쪽 엣지: 첫 행이면 flat, 아니면 위 조각의 아래 엣지의 반대
    EdgeType topEdge;
    if (row == 0) {
      topEdge = EdgeType.flat;
    } else {
      final aboveEdgeList = horizontalEdges[row - 1]!;
      topEdge = _getOppositeEdge(aboveEdgeList[col]);
    }

    // 왼쪽 엣지: 첫 열이면 flat, 아니면 왼쪽 조각의 오른쪽 엣지의 반대
    EdgeType leftEdge;
    if (col == 0) {
      leftEdge = EdgeType.flat;
    } else {
      final leftEdgeList = verticalEdges[col - 1]!;
      leftEdge = _getOppositeEdge(leftEdgeList[row]);
    }

    // 아래쪽 엣지: 마지막 행이면 flat, 아니면 랜덤
    EdgeType bottomEdge;
    if (row == widget.puzzle.gridRows - 1) {
      bottomEdge = EdgeType.flat;
    } else {
      bottomEdge = random.nextBool() ? EdgeType.tab : EdgeType.slot;
    }

    // 오른쪽 엣지: 마지막 열이면 flat, 아니면 랜덤
    EdgeType rightEdge;
    if (col == widget.puzzle.gridColumns - 1) {
      rightEdge = EdgeType.flat;
    } else {
      rightEdge = random.nextBool() ? EdgeType.tab : EdgeType.slot;
    }

    // 엣지 정보 저장
    if (!horizontalEdges.containsKey(row)) {
      horizontalEdges[row] = [];
    }
    horizontalEdges[row]!.add(bottomEdge);

    if (!verticalEdges.containsKey(col)) {
      verticalEdges[col] = [];
    }
    verticalEdges[col]!.add(rightEdge);

    // 색상 생성
    final hue = ((row * widget.puzzle.gridColumns + col) * 137.5) % 360;
    final color = HSLColor.fromAHSL(1.0, hue, 0.6, 0.7).toColor();

    // 올바른 위치 (A구역 내)
    final correctX = _assemblyZone.left + col * _pieceSize;
    final correctY = _assemblyZone.top + row * _pieceSize;

    // 초기 투명도 (난이도별)
    final initialOpacity = _getInitialOpacity();

    return PuzzlePiece(
      row: row,
      column: col,
      topEdge: topEdge,
      rightEdge: rightEdge,
      bottomEdge: bottomEdge,
      leftEdge: leftEdge,
      color: color,
      currentPosition: Offset(correctX, correctY), // 초기에는 올바른 위치
      correctPosition: Offset(correctX, correctY),
      opacity: initialOpacity,
    );
  }

  EdgeType _getOppositeEdge(EdgeType edge) {
    if (edge == EdgeType.flat) return EdgeType.flat;
    if (edge == EdgeType.tab) return EdgeType.slot;
    return EdgeType.tab;
  }

  double _getInitialOpacity() {
    switch (widget.puzzle.difficulty) {
      case 1:
        return 0.7;
      case 2:
        return 0.8;
      case 3:
        return 0.85;
      case 4:
        return 0.9;
      default:
        return 0.8;
    }
  }

  void _shufflePieces(math.Random random) {
    final screenWidth = 400.0; // 대략적인 화면 너비
    final screenHeight = 700.0; // 대략적인 화면 높이

    for (var piece in _pieces) {
      if (piece.isPlaced) continue;

      // A구역 바깥에 랜덤 배치
      double randomX, randomY;
      do {
        randomX = random.nextDouble() * (screenWidth - _pieceSize);
        randomY = random.nextDouble() * (screenHeight - _pieceSize);
      } while (_assemblyZone.contains(Offset(randomX + _pieceSize / 2, randomY + _pieceSize / 2)));

      piece.currentPosition = Offset(randomX, randomY);
    }
  }

  void _onPieceDragEnd(PuzzlePiece piece, DraggableDetails details) {
    setState(() {
      // 드래그 종료 시 현재 위치 업데이트
      final renderBox = context.findRenderObject() as RenderBox;
      piece.currentPosition = renderBox.globalToLocal(details.offset);

      // A구역에 있는지 확인
      final pieceCenterX = piece.currentPosition.dx + _pieceSize / 2;
      final pieceCenterY = piece.currentPosition.dy + _pieceSize / 2;
      final isInZone = _assemblyZone.contains(Offset(pieceCenterX, pieceCenterY));

      if (isInZone) {
        piece.isInAssemblyZone = true;

        // A구역 내에서 올바른 위치 근처인지 확인
        if (piece.isInCorrectPosition(_snapTolerance)) {
          piece.currentPosition = piece.correctPosition;
          piece.isPlaced = true;
          piece.placedColor = Colors.green.withOpacity(0.7); // 고정 시 초록색으로 변경

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('조각이 맞춰졌습니다! 🎉'),
              duration: Duration(milliseconds: 500),
            ),
          );

          // 모든 조각이 맞춰졌는지 확인
          _checkPuzzleCompletion();
        }
      } else {
        piece.isInAssemblyZone = false;
      }
    });
  }

  void _checkPuzzleCompletion() {
    final allPlaced = _pieces.every((piece) => piece.isPlaced);

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

      // 랜덤 조각의 투명도 감소
      final unplacedPieces = _pieces.where((p) => !p.isPlaced).toList();
      if (unplacedPieces.isNotEmpty) {
        final random = math.Random();
        final randomPiece = unplacedPieces[random.nextInt(unplacedPieces.length)];
        randomPiece.opacity = (randomPiece.opacity - 0.2).clamp(0.0, 1.0);
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzle.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
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
            ..._pieces.map((piece) {
              return Positioned(
                left: piece.correctPosition.dx,
                top: piece.correctPosition.dy,
                child: Container(
                  width: _pieceSize,
                  height: _pieceSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
              );
            }).toList(),

            // 드래그 가능한 퍼즐 조각들
            ..._pieces.map((piece) {
            if (piece.isPlaced) {
              // 이미 배치된 조각
              return Positioned(
                left: piece.currentPosition.dx,
                top: piece.currentPosition.dy,
                child: CustomPaint(
                  size: Size(_pieceSize, _pieceSize),
                  painter: PuzzlePiecePainter(
                    piece: piece,
                    pieceSize: _pieceSize,
                  ),
                ),
              );
            }

            // 드래그 가능한 조각
            return Positioned(
              left: piece.currentPosition.dx,
              top: piece.currentPosition.dy,
              child: Draggable<PuzzlePiece>(
                data: piece,
                feedback: CustomPaint(
                  size: Size(_pieceSize, _pieceSize),
                  painter: PuzzlePiecePainter(
                    piece: piece,
                    pieceSize: _pieceSize,
                  ),
                ),
                childWhenDragging: Container(),
                onDragEnd: (details) => _onPieceDragEnd(piece, details),
                child: CustomPaint(
                  size: Size(_pieceSize, _pieceSize),
                  painter: PuzzlePiecePainter(
                    piece: piece,
                    pieceSize: _pieceSize,
                  ),
                ),
              ),
            );
          }).toList(),
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
