import 'package:flutter/material.dart';

class ColorTile {
  final int row;
  final int column;
  final Color color;
  final int colorGroupId; // 같은 색상 그룹 식별자

  Offset currentPosition;
  final Offset correctPosition;
  bool isPlaced;

  ColorTile({
    required this.row,
    required this.column,
    required this.color,
    required this.colorGroupId,
    required this.currentPosition,
    required this.correctPosition,
    this.isPlaced = false,
  });

  bool isInCorrectPosition(double tolerance) {
    final dx = (currentPosition.dx - correctPosition.dx).abs();
    final dy = (currentPosition.dy - correctPosition.dy).abs();
    return dx < tolerance && dy < tolerance;
  }
}
