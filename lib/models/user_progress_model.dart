class UserProgressModel {
  final String userId;
  final int totalSteps;
  final int todaySteps;
  final double totalDistance;
  final List<String> completedPuzzles;
  final List<String> unlockedPuzzles;
  final int availableHints;
  final DateTime lastUpdated;

  UserProgressModel({
    required this.userId,
    this.totalSteps = 0,
    this.todaySteps = 0,
    this.totalDistance = 0.0,
    this.completedPuzzles = const [],
    this.unlockedPuzzles = const [],
    this.availableHints = 0,
    required this.lastUpdated,
  });

  factory UserProgressModel.fromJson(Map<String, dynamic> json) {
    return UserProgressModel(
      userId: json['userId'] as String,
      totalSteps: json['totalSteps'] as int? ?? 0,
      todaySteps: json['todaySteps'] as int? ?? 0,
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0.0,
      completedPuzzles: (json['completedPuzzles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      unlockedPuzzles: (json['unlockedPuzzles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      availableHints: json['availableHints'] as int? ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalSteps': totalSteps,
      'todaySteps': todaySteps,
      'totalDistance': totalDistance,
      'completedPuzzles': completedPuzzles,
      'unlockedPuzzles': unlockedPuzzles,
      'availableHints': availableHints,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  UserProgressModel copyWith({
    String? userId,
    int? totalSteps,
    int? todaySteps,
    double? totalDistance,
    List<String>? completedPuzzles,
    List<String>? unlockedPuzzles,
    int? availableHints,
    DateTime? lastUpdated,
  }) {
    return UserProgressModel(
      userId: userId ?? this.userId,
      totalSteps: totalSteps ?? this.totalSteps,
      todaySteps: todaySteps ?? this.todaySteps,
      totalDistance: totalDistance ?? this.totalDistance,
      completedPuzzles: completedPuzzles ?? this.completedPuzzles,
      unlockedPuzzles: unlockedPuzzles ?? this.unlockedPuzzles,
      availableHints: availableHints ?? this.availableHints,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  bool isPuzzleCompleted(String puzzleId) {
    return completedPuzzles.contains(puzzleId);
  }

  bool isPuzzleUnlocked(String puzzleId) {
    return unlockedPuzzles.contains(puzzleId);
  }
}
