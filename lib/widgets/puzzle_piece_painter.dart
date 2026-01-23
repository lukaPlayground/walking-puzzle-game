import 'package:flutter/material.dart';
import '../models/puzzle_piece.dart';

class PuzzlePiecePainter extends CustomPainter {
  final PuzzlePiece piece;
  final double pieceSize;

  PuzzlePiecePainter({
    required this.piece,
    required this.pieceSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 고정된 조각은 placedColor 사용, 아니면 원래 색상
    final displayColor = piece.isPlaced && piece.placedColor != null
        ? piece.placedColor!
        : piece.color.withOpacity(1.0 - piece.opacity);

    final paint = Paint()
      ..color = displayColor
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = _createPuzzlePiecePath();

    // 그림자
    canvas.drawPath(path.shift(const Offset(2, 2)), shadowPaint);

    // 조각 채우기
    canvas.drawPath(path, paint);

    // 테두리
    canvas.drawPath(path, borderPaint);
  }

  Path _createPuzzlePiecePath() {
    final path = Path();
    final tabSize = pieceSize * 0.15; // 돌출부 크기

    // 시작점 (왼쪽 위)
    path.moveTo(0, 0);

    // 위쪽 가장자리
    _addEdge(path, piece.topEdge, tabSize, pieceSize, EdgeDirection.top);

    // 오른쪽 위 모서리
    path.lineTo(pieceSize, 0);

    // 오른쪽 가장자리
    _addEdge(path, piece.rightEdge, tabSize, pieceSize, EdgeDirection.right);

    // 오른쪽 아래 모서리
    path.lineTo(pieceSize, pieceSize);

    // 아래쪽 가장자리
    _addEdge(path, piece.bottomEdge, tabSize, pieceSize, EdgeDirection.bottom);

    // 왼쪽 아래 모서리
    path.lineTo(0, pieceSize);

    // 왼쪽 가장자리
    _addEdge(path, piece.leftEdge, tabSize, pieceSize, EdgeDirection.left);

    path.close();
    return path;
  }

  void _addEdge(Path path, EdgeType edgeType, double tabSize, double pieceSize, EdgeDirection direction) {
    if (edgeType == EdgeType.flat) {
      return; // 평평한 가장자리는 그대로 직선
    }

    final center = pieceSize / 2;
    final tabDepth = tabSize;

    switch (direction) {
      case EdgeDirection.top:
        if (edgeType == EdgeType.tab) {
          // 돌출부
          path.lineTo(center - tabSize, 0);
          path.quadraticBezierTo(
            center - tabSize, -tabDepth,
            center, -tabDepth,
          );
          path.quadraticBezierTo(
            center + tabSize, -tabDepth,
            center + tabSize, 0,
          );
        } else {
          // 홈
          path.lineTo(center - tabSize, 0);
          path.quadraticBezierTo(
            center - tabSize, tabDepth,
            center, tabDepth,
          );
          path.quadraticBezierTo(
            center + tabSize, tabDepth,
            center + tabSize, 0,
          );
        }
        break;

      case EdgeDirection.right:
        if (edgeType == EdgeType.tab) {
          path.lineTo(pieceSize, center - tabSize);
          path.quadraticBezierTo(
            pieceSize + tabDepth, center - tabSize,
            pieceSize + tabDepth, center,
          );
          path.quadraticBezierTo(
            pieceSize + tabDepth, center + tabSize,
            pieceSize, center + tabSize,
          );
        } else {
          path.lineTo(pieceSize, center - tabSize);
          path.quadraticBezierTo(
            pieceSize - tabDepth, center - tabSize,
            pieceSize - tabDepth, center,
          );
          path.quadraticBezierTo(
            pieceSize - tabDepth, center + tabSize,
            pieceSize, center + tabSize,
          );
        }
        break;

      case EdgeDirection.bottom:
        if (edgeType == EdgeType.tab) {
          path.lineTo(center + tabSize, pieceSize);
          path.quadraticBezierTo(
            center + tabSize, pieceSize + tabDepth,
            center, pieceSize + tabDepth,
          );
          path.quadraticBezierTo(
            center - tabSize, pieceSize + tabDepth,
            center - tabSize, pieceSize,
          );
        } else {
          path.lineTo(center + tabSize, pieceSize);
          path.quadraticBezierTo(
            center + tabSize, pieceSize - tabDepth,
            center, pieceSize - tabDepth,
          );
          path.quadraticBezierTo(
            center - tabSize, pieceSize - tabDepth,
            center - tabSize, pieceSize,
          );
        }
        break;

      case EdgeDirection.left:
        if (edgeType == EdgeType.tab) {
          path.lineTo(0, center + tabSize);
          path.quadraticBezierTo(
            -tabDepth, center + tabSize,
            -tabDepth, center,
          );
          path.quadraticBezierTo(
            -tabDepth, center - tabSize,
            0, center - tabSize,
          );
        } else {
          path.lineTo(0, center + tabSize);
          path.quadraticBezierTo(
            tabDepth, center + tabSize,
            tabDepth, center,
          );
          path.quadraticBezierTo(
            tabDepth, center - tabSize,
            0, center - tabSize,
          );
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant PuzzlePiecePainter oldDelegate) {
    return oldDelegate.piece.opacity != piece.opacity ||
        oldDelegate.piece.currentPosition != piece.currentPosition;
  }
}

enum EdgeDirection {
  top,
  right,
  bottom,
  left,
}
