import 'dart:math' as math;
import 'package:flutter/material.dart';

class PuzzleGridPainter extends CustomPainter {
  final int rows;
  final int columns;
  final double opacity;

  PuzzleGridPainter({
    required this.rows,
    required this.columns,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pieceWidth = size.width / columns;
    final pieceHeight = size.height / rows;

    final random = math.Random(42); // 시드 고정으로 일관된 랜덤

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        final x = col * pieceWidth;
        final y = row * pieceHeight;

        _drawPuzzlePiece(
          canvas,
          Offset(x, y),
          pieceWidth,
          pieceHeight,
          random,
          row,
          col,
        );
      }
    }
  }

  void _drawPuzzlePiece(
    Canvas canvas,
    Offset position,
    double width,
    double height,
    math.Random random,
    int row,
    int col,
  ) {
    // 각 조각의 배경색 (랜덤한 파스텔 톤)
    final hue = ((row * columns + col) * 137.5) % 360; // 황금각으로 색상 분산
    final color = HSLColor.fromAHSL(1.0, hue, 0.6, 0.7).toColor();

    // 투명도 적용된 페인트
    final paint = Paint()
      ..color = color.withOpacity(1.0 - opacity)
      ..style = PaintingStyle.fill;

    // 조각 경로 생성 (직사각형 기본 + 약간의 변형)
    final path = Path();
    path.moveTo(position.dx, position.dy);
    path.lineTo(position.dx + width, position.dy);
    path.lineTo(position.dx + width, position.dy + height);
    path.lineTo(position.dx, position.dy + height);
    path.close();

    // 배경 그리기
    canvas.drawPath(path, paint);

    // 그림자 효과 (외곽선)
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(path, shadowPaint);

    // 조각 테두리 (더 진한 외곽선)
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant PuzzleGridPainter oldDelegate) {
    return oldDelegate.opacity != opacity ||
        oldDelegate.rows != rows ||
        oldDelegate.columns != columns;
  }
}
