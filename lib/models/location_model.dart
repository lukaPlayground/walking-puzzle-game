import 'dart:math';

class LocationModel {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final DateTime timestamp;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.timestamp,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      accuracy: json['accuracy'] as double?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  double distanceTo(LocationModel other) {
    const double earthRadius = 6371000;
    final double lat1Rad = latitude * pi / 180;
    final double lat2Rad = other.latitude * pi / 180;
    final double deltaLat = (other.latitude - latitude) * pi / 180;
    final double deltaLon = (other.longitude - longitude) * pi / 180;

    final double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);
    final double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  LocationModel copyWith({
    double? latitude,
    double? longitude,
    double? accuracy,
    DateTime? timestamp,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class LandmarkModel {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final double radius;
  final String? imageUrl;

  LandmarkModel({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.radius = 100.0,
    this.imageUrl,
  });

  factory LandmarkModel.fromJson(Map<String, dynamic> json) {
    return LandmarkModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      radius: json['radius'] as double? ?? 100.0,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'imageUrl': imageUrl,
    };
  }

  bool isUserNearby(LocationModel userLocation) {
    final landmarkLocation = LocationModel(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
    );
    final distance = userLocation.distanceTo(landmarkLocation);
    return distance <= radius;
  }
}
