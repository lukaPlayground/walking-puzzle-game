import 'package:flutter/material.dart';

enum EdgeType {
  flat,   // 평평한 가장자리 (외곽선)
  tab,    // 돌출부
  slot,   // 홈
}

class PuzzlePiece {
  final int row;
  final int column;
  final EdgeType topEdge;
  final EdgeType rightEdge;
  final EdgeType bottomEdge;
  final EdgeType leftEdge;
  final Color color;

  Offset currentPosition;
  final Offset correctPosition;
  bool isPlaced;
  double opacity;
  bool isInAssemblyZone; // A구역에 있는지 여부
  Color? placedColor; // 고정되었을 때의 색상

  PuzzlePiece({
    required this.row,
    required this.column,
    required this.topEdge,
    required this.rightEdge,
    required this.bottomEdge,
    required this.leftEdge,
    required this.color,
    required this.currentPosition,
    required this.correctPosition,
    this.isPlaced = false,
    this.opacity = 0.9,
    this.isInAssemblyZone = false,
    this.placedColor,
  });

  PuzzlePiece copyWith({
    Offset? currentPosition,
    bool? isPlaced,
    double? opacity,
    bool? isInAssemblyZone,
    Color? placedColor,
  }) {
    return PuzzlePiece(
      row: row,
      column: column,
      topEdge: topEdge,
      rightEdge: rightEdge,
      bottomEdge: bottomEdge,
      leftEdge: leftEdge,
      color: color,
      currentPosition: currentPosition ?? this.currentPosition,
      correctPosition: correctPosition,
      isPlaced: isPlaced ?? this.isPlaced,
      opacity: opacity ?? this.opacity,
      isInAssemblyZone: isInAssemblyZone ?? this.isInAssemblyZone,
      placedColor: placedColor ?? this.placedColor,
    );
  }

  bool isInCorrectPosition(double tolerance) {
    final dx = (currentPosition.dx - correctPosition.dx).abs();
    final dy = (currentPosition.dy - correctPosition.dy).abs();
    return dx < tolerance && dy < tolerance;
  }
}
