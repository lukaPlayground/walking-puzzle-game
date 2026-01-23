class PuzzleModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int difficulty;
  final bool isLocationBased;
  final double? latitude;
  final double? longitude;
  final int requiredSteps;
  final int hintsAvailable;
  final int gridRows;
  final int gridColumns;
  final String answer;
  final List<String> hints;

  PuzzleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.difficulty,
    required this.gridRows,
    required this.gridColumns,
    required this.answer,
    this.hints = const [],
    this.isLocationBased = false,
    this.latitude,
    this.longitude,
    this.requiredSteps = 0,
    this.hintsAvailable = 0,
  });

  factory PuzzleModel.fromJson(Map<String, dynamic> json) {
    return PuzzleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      difficulty: json['difficulty'] as int,
      gridRows: json['gridRows'] as int,
      gridColumns: json['gridColumns'] as int,
      answer: json['answer'] as String,
      hints: (json['hints'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      isLocationBased: json['isLocationBased'] as bool? ?? false,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      requiredSteps: json['requiredSteps'] as int? ?? 0,
      hintsAvailable: json['hintsAvailable'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'difficulty': difficulty,
      'gridRows': gridRows,
      'gridColumns': gridColumns,
      'answer': answer,
      'hints': hints,
      'isLocationBased': isLocationBased,
      'latitude': latitude,
      'longitude': longitude,
      'requiredSteps': requiredSteps,
      'hintsAvailable': hintsAvailable,
    };
  }

  PuzzleModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    int? difficulty,
    int? gridRows,
    int? gridColumns,
    String? answer,
    List<String>? hints,
    bool? isLocationBased,
    double? latitude,
    double? longitude,
    int? requiredSteps,
    int? hintsAvailable,
  }) {
    return PuzzleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      difficulty: difficulty ?? this.difficulty,
      gridRows: gridRows ?? this.gridRows,
      gridColumns: gridColumns ?? this.gridColumns,
      answer: answer ?? this.answer,
      hints: hints ?? this.hints,
      isLocationBased: isLocationBased ?? this.isLocationBased,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      requiredSteps: requiredSteps ?? this.requiredSteps,
      hintsAvailable: hintsAvailable ?? this.hintsAvailable,
    );
  }

  int get totalPieces => gridRows * gridColumns;
}
