import 'package:flutter/material.dart';

class WaterTube {
  final int id;
  final int capacity; // 최대 레이어 수 (보통 4)
  List<Color?> layers; // 아래에서 위로 쌓임 (null = 빈 공간)

  WaterTube({
    required this.id,
    required this.capacity,
    required this.layers,
  });

  // 현재 채워진 레이어 수
  int get filledCount => layers.where((layer) => layer != null).length;

  // 빈 공간 수
  int get emptyCount => capacity - filledCount;

  // 완전히 비어있는지
  bool get isEmpty => filledCount == 0;

  // 완전히 채워져 있는지
  bool get isFull => filledCount == capacity;

  // 단일 색상으로만 채워져 있는지 (정렬 완료)
  bool get isSorted {
    // 빈 튜브는 완료된 것이 아님
    if (isEmpty) return false;

    // 꽉 차 있지 않으면 완료된 것이 아님
    if (filledCount != capacity) return false;

    // 모든 레이어가 같은 색상인지 확인
    final firstColor = layers.firstWhere((layer) => layer != null);
    return layers.every((layer) => layer == firstColor);
  }

  // 맨 위 레이어의 색상
  Color? get topColor {
    for (int i = capacity - 1; i >= 0; i--) {
      if (layers[i] != null) return layers[i];
    }
    return null;
  }

  // 맨 위에서부터 같은 색상의 레이어 개수
  int get topColorCount {
    if (topColor == null) return 0;

    int count = 0;
    for (int i = capacity - 1; i >= 0; i--) {
      if (layers[i] == topColor) {
        count++;
      } else if (layers[i] != null) {
        break;
      }
    }
    return count;
  }

  // 물을 따를 수 있는지 확인
  bool canPourTo(WaterTube other) {
    // 자기 자신에게는 못 부음
    if (id == other.id) return false;

    // 이 튜브가 비어있으면 못 부음
    if (isEmpty) return false;

    // 대상 튜브가 꽉 차있으면 못 부음
    if (other.isFull) return false;

    // 대상 튜브가 비어있으면 부을 수 있음
    if (other.isEmpty) return true;

    // 대상 튜브의 맨 위 색상과 이 튜브의 맨 위 색상이 같아야 함
    return topColor == other.topColor;
  }

  // 물을 따르기
  int pourTo(WaterTube other) {
    if (!canPourTo(other)) return 0;

    int poured = 0;
    final colorToPour = topColor;

    // 같은 색상을 최대한 부음
    while (topColor == colorToPour && !other.isFull) {
      // 맨 위 레이어 찾아서 제거
      for (int i = capacity - 1; i >= 0; i--) {
        if (layers[i] != null) {
          final color = layers[i];
          layers[i] = null;

          // 대상 튜브에 추가
          for (int j = 0; j < other.capacity; j++) {
            if (other.layers[j] == null) {
              other.layers[j] = color;
              poured++;
              break;
            }
          }
          break;
        }
      }
    }

    return poured;
  }

  WaterTube copyWith() {
    return WaterTube(
      id: id,
      capacity: capacity,
      layers: List.from(layers),
    );
  }
}
