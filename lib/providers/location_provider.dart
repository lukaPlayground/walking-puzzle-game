import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();

  LocationModel? _currentLocation;
  bool _isTracking = false;
  List<LandmarkModel> _landmarks = [];

  LocationModel? get currentLocation => _currentLocation;
  bool get isTracking => _isTracking;
  List<LandmarkModel> get landmarks => _landmarks;

  Future<void> initialize() async {
    await getCurrentLocation();
    _initializeLandmarks();
  }

  void _initializeLandmarks() {
    _landmarks = [
      LandmarkModel(
        id: 'ilsan_lake_park',
        name: '일산호수공원',
        description: '고양시 일산서구의 대표 랜드마크',
        latitude: 37.6563,
        longitude: 126.7690,
        radius: 200.0,
        imageUrl: null,
      ),
      LandmarkModel(
        id: 'lafesta',
        name: '라페스타',
        description: '일산 라페스타 쇼핑몰',
        latitude: 37.6595,
        longitude: 126.7726,
        radius: 100.0,
        imageUrl: null,
      ),
      LandmarkModel(
        id: 'jungangpark',
        name: '정발산 중앙공원',
        description: '일산의 중심 공원',
        latitude: 37.6738,
        longitude: 126.7691,
        radius: 150.0,
        imageUrl: null,
      ),
    ];
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    final location = await _locationService.getCurrentLocation();
    if (location != null) {
      _currentLocation = location;
      notifyListeners();
    }
  }

  void startTracking() {
    if (_isTracking) return;

    _locationService.startLocationTracking();
    _isTracking = true;

    _locationService.locationStream.listen((location) {
      _currentLocation = location;
      notifyListeners();
    });

    notifyListeners();
  }

  void stopTracking() {
    if (!_isTracking) return;

    _locationService.stopLocationTracking();
    _isTracking = false;
    notifyListeners();
  }

  LandmarkModel? checkNearbyLandmark() {
    if (_currentLocation == null) return null;

    for (final landmark in _landmarks) {
      if (landmark.isUserNearby(_currentLocation!)) {
        return landmark;
      }
    }
    return null;
  }

  double? getDistanceToLandmark(String landmarkId) {
    if (_currentLocation == null) return null;

    final landmark = _landmarks.firstWhere(
      (l) => l.id == landmarkId,
      orElse: () => _landmarks.first,
    );

    final landmarkLocation = LocationModel(
      latitude: landmark.latitude,
      longitude: landmark.longitude,
      timestamp: DateTime.now(),
    );

    return _locationService.calculateDistance(_currentLocation!, landmarkLocation);
  }

  @override
  void dispose() {
    _locationService.dispose();
    super.dispose();
  }
}
