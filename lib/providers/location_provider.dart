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
        id: 'seoul_tower',
        name: 'N서울타워',
        description: '서울의 랜드마크, N서울타워',
        latitude: 37.5512,
        longitude: 126.9882,
        radius: 100.0,
        imageUrl: null,
      ),
      LandmarkModel(
        id: 'bukchon',
        name: '북촌 한옥마을',
        description: '전통 한옥이 밀집한 북촌',
        latitude: 37.5825,
        longitude: 126.9833,
        radius: 150.0,
        imageUrl: null,
      ),
      LandmarkModel(
        id: 'hallasan',
        name: '한라산',
        description: '제주도의 상징, 한라산',
        latitude: 33.3616,
        longitude: 126.5292,
        radius: 500.0,
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
