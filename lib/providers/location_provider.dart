import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../models/landmark_collection_model.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();
  final StorageService _storageService = StorageService();

  LocationModel? _currentLocation;
  bool _isTracking = false;
  List<LandmarkModel> _landmarks = [];
  LandmarkCollectionModel _collection = LandmarkCollectionModel();

  LocationModel? get currentLocation => _currentLocation;
  bool get isTracking => _isTracking;
  List<LandmarkModel> get landmarks => _landmarks;
  LandmarkCollectionModel get collection => _collection;

  Future<void> initialize() async {
    await getCurrentLocation();
    await _loadCollection();
    _initializeLandmarks();
  }

  Future<void> _loadCollection() async {
    final data = await _storageService.getLandmarkCollection();
    if (data != null) {
      _collection = LandmarkCollectionModel.fromJson(data);
    }
  }

  Future<void> _saveCollection() async {
    await _storageService.saveLandmarkCollection(_collection.toJson());
  }

  void _initializeLandmarks() {
    _landmarks = [
      // 한국 랜드마크
      LandmarkModel(
        id: 'kr_n_seoul_tower',
        name: 'N서울타워',
        description: '서울의 상징적인 타워',
        latitude: 37.5512,
        longitude: 126.9882,
        radius: 200.0,
        country: '한국',
        countryCode: 'KR',
        icon: '🗼',
      ),
      LandmarkModel(
        id: 'kr_gyeongbokgung',
        name: '경복궁',
        description: '조선시대 궁궐',
        latitude: 37.5796,
        longitude: 126.9770,
        radius: 200.0,
        country: '한국',
        countryCode: 'KR',
        icon: '🏯',
      ),
      LandmarkModel(
        id: 'kr_bukchon',
        name: '북촌한옥마을',
        description: '전통 한옥 마을',
        latitude: 37.5826,
        longitude: 126.9836,
        radius: 200.0,
        country: '한국',
        countryCode: 'KR',
        icon: '🏘️',
      ),
      LandmarkModel(
        id: 'kr_hallasan',
        name: '한라산',
        description: '제주도 최고봉',
        latitude: 33.3617,
        longitude: 126.5292,
        radius: 500.0,
        country: '한국',
        countryCode: 'KR',
        icon: '🏔️',
      ),
      LandmarkModel(
        id: 'kr_haeundae',
        name: '해운대해수욕장',
        description: '부산 대표 해변',
        latitude: 35.1587,
        longitude: 129.1603,
        radius: 200.0,
        country: '한국',
        countryCode: 'KR',
        icon: '🏖️',
      ),
      // 일본 랜드마크
      LandmarkModel(
        id: 'jp_tokyo_tower',
        name: '도쿄타워',
        description: '도쿄의 상징',
        latitude: 35.6586,
        longitude: 139.7454,
        radius: 200.0,
        country: '일본',
        countryCode: 'JP',
        icon: '🗼',
      ),
      LandmarkModel(
        id: 'jp_mount_fuji',
        name: '후지산',
        description: '일본 최고봉',
        latitude: 35.3606,
        longitude: 138.7274,
        radius: 500.0,
        country: '일본',
        countryCode: 'JP',
        icon: '🗻',
      ),
      LandmarkModel(
        id: 'jp_kiyomizu',
        name: '키요미즈데라',
        description: '교토 대표 사찰',
        latitude: 34.9949,
        longitude: 135.7850,
        radius: 200.0,
        country: '일본',
        countryCode: 'JP',
        icon: '⛩️',
      ),
      // 미국 랜드마크
      LandmarkModel(
        id: 'us_statue_liberty',
        name: '자유의 여신상',
        description: '뉴욕의 상징',
        latitude: 40.6892,
        longitude: -74.0445,
        radius: 200.0,
        country: '미국',
        countryCode: 'US',
        icon: '🗽',
      ),
      LandmarkModel(
        id: 'us_golden_gate',
        name: '금문교',
        description: '샌프란시스코 명소',
        latitude: 37.8199,
        longitude: -122.4783,
        radius: 200.0,
        country: '미국',
        countryCode: 'US',
        icon: '🌉',
      ),
      // 프랑스 랜드마크
      LandmarkModel(
        id: 'fr_eiffel_tower',
        name: '에펠탑',
        description: '파리의 상징',
        latitude: 48.8584,
        longitude: 2.2945,
        radius: 200.0,
        country: '프랑스',
        countryCode: 'FR',
        icon: '🗼',
      ),
      LandmarkModel(
        id: 'fr_louvre',
        name: '루브르박물관',
        description: '세계 최대 박물관',
        latitude: 48.8606,
        longitude: 2.3376,
        radius: 200.0,
        country: '프랑스',
        countryCode: 'FR',
        icon: '🏛️',
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
        // 아직 수집하지 않은 랜드마크만 반환
        if (!_collection.hasLandmark(landmark.id)) {
          return landmark;
        }
      }
    }
    return null;
  }

  Future<bool> collectLandmark(String landmarkId) async {
    if (_collection.hasLandmark(landmarkId)) {
      return false; // 이미 수집됨
    }

    final landmark = _landmarks.firstWhere(
      (l) => l.id == landmarkId,
      orElse: () => throw Exception('Landmark not found'),
    );

    // 랜드마크 수집
    _collection.collectedLandmarkIds.add(landmarkId);

    // 해당 국가의 모든 랜드마크를 수집했는지 확인
    final countryLandmarks =
        _landmarks.where((l) => l.countryCode == landmark.countryCode);
    final allCollected = countryLandmarks.every(
      (l) => _collection.hasLandmark(l.id),
    );

    if (allCollected && !_collection.hasCountry(landmark.countryCode)) {
      _collection.collectedCountryCodes.add(landmark.countryCode);
    }

    await _saveCollection();
    notifyListeners();
    return true;
  }

  Map<String, List<LandmarkModel>> getLandmarksByCountry() {
    final Map<String, List<LandmarkModel>> result = {};
    for (final landmark in _landmarks) {
      if (!result.containsKey(landmark.countryCode)) {
        result[landmark.countryCode] = [];
      }
      result[landmark.countryCode]!.add(landmark);
    }
    return result;
  }

  String getCountryFlag(String countryCode) {
    const Map<String, String> flags = {
      'KR': '🇰🇷',
      'JP': '🇯🇵',
      'US': '🇺🇸',
      'FR': '🇫🇷',
    };
    return flags[countryCode] ?? '🏳️';
  }

  Future<void> setProfileIcon(String landmarkId) async {
    _collection = _collection.copyWith(selectedProfileIcon: landmarkId);
    await _saveCollection();
    notifyListeners();
  }

  String getProfileIcon() {
    if (_collection.selectedProfileIcon != null &&
        _collection.hasLandmark(_collection.selectedProfileIcon!)) {
      final landmark = _landmarks.firstWhere(
        (l) => l.id == _collection.selectedProfileIcon,
      );
      return landmark.icon;
    }
    return '👤'; // 기본 아이콘
  }

  Future<void> markAllAsViewed() async {
    _collection = _collection.copyWith(
      viewedLandmarkIds: Set.from(_collection.collectedLandmarkIds),
    );
    await _saveCollection();
    notifyListeners();
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
