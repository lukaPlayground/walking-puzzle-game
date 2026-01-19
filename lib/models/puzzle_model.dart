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

  PuzzleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.difficulty,
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
      isLocationBased: isLocationBased ?? this.isLocationBased,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      requiredSteps: requiredSteps ?? this.requiredSteps,
      hintsAvailable: hintsAvailable ?? this.hintsAvailable,
    );
  }
}
