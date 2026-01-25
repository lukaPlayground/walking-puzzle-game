import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../services/health_service.dart';
import '../services/storage_service.dart';

class StepCounterProvider with ChangeNotifier {
  final HealthService _healthService = HealthService();
  final StorageService _storageService = StorageService();

  int _todaySteps = 0;
  int _totalSteps = 0;
  bool _isTracking = false;
  bool _hasPermission = false;
  Timer? _updateTimer;

  // 흔들기 감지를 위한 변수들
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  double _accumulatedSteps = 0.0; // 누적된 소수점 걸음 수
  static const double _shakeThreshold = 15.0; // 흔들기 감지 임계값
  static const int _shakeCooldownMs = 500; // 0.5초 쿨다운
  static const double _stepsPerShake = 0.5; // 흔들기 한 번당 0.5보

  int get todaySteps => _todaySteps;
  int get totalSteps => _totalSteps;
  bool get isTracking => _isTracking;
  bool get hasPermission => _hasPermission;
  double get todayDistanceKm => _healthService.stepsToKilometers(_todaySteps);
  double get todayCalories => _healthService.stepsToCalories(_todaySteps);

  /// 초기화: 저장된 데이터 로드 및 권한 확인
  Future<void> initialize() async {
    await _loadStoredData();
    await _checkAndResetDailySteps();
    await requestPermissions();
  }

  /// 저장된 총 걸음 수 로드
  Future<void> _loadStoredData() async {
    _totalSteps = await _storageService.loadTotalSteps();
    notifyListeners();
  }

  /// 자정이 지났는지 확인하고 일일 걸음 수 리셋
  Future<void> _checkAndResetDailySteps() async {
    final shouldReset = await _storageService.shouldResetDailySteps();
    if (shouldReset) {
      _todaySteps = 0;
      await _storageService.saveLastStepResetDate(DateTime.now());
      notifyListeners();
    }
  }

  /// Health 권한 요청
  Future<bool> requestPermissions() async {
    try {
      _hasPermission = await _healthService.requestHealthPermissions();
      notifyListeners();

      if (_hasPermission) {
        // 권한이 있으면 바로 오늘 걸음 수 가져오기
        await fetchTodaySteps();
      }

      return _hasPermission;
    } catch (e) {
      print('Error requesting health permissions: $e');
      return false;
    }
  }

  /// 오늘 걸음 수 가져오기 (HealthKit/Health Connect에서)
  Future<void> fetchTodaySteps() async {
    if (!_hasPermission) {
      print('No health permission granted');
      return;
    }

    try {
      final steps = await _healthService.getTodaySteps();

      // 오늘 걸음 수 업데이트
      final stepsDifference = steps - _todaySteps;
      if (stepsDifference > 0) {
        _totalSteps += stepsDifference;
        await _storageService.saveTotalSteps(_totalSteps);
      }

      _todaySteps = steps;
      notifyListeners();
    } catch (e) {
      print('Error fetching today steps: $e');
    }
  }

  /// 추적 시작: 주기적으로 걸음 수 업데이트 (30초마다)
  void startTracking() {
    if (_isTracking) return;

    _isTracking = true;
    notifyListeners();

    // 즉시 한 번 가져오기
    fetchTodaySteps();

    // 30초마다 걸음 수 업데이트
    _updateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchTodaySteps();
    });

    // 흔들기 감지 시작 (실내 테스트용)
    _startShakeDetection();
  }

  /// 흔들기 감지 시작 (디버그/실내 테스트용)
  void _startShakeDetection() {
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      final now = DateTime.now();

      // 쿨다운 체크
      if (_lastShakeTime != null &&
          now.difference(_lastShakeTime!).inMilliseconds < _shakeCooldownMs) {
        return;
      }

      // 가속도 크기 계산
      final acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      // 흔들기 감지
      if (acceleration > _shakeThreshold) {
        _lastShakeTime = now;
        _simulateSteps(_stepsPerShake); // 0.5보 추가
        print('흔들기 감지! 0.5보 추가됨 (총: $_todaySteps보)');
      }
    });
  }

  /// 시뮬레이션 걸음 수 추가 (테스트용)
  void _simulateSteps(double steps) {
    _accumulatedSteps += steps;

    // 1보 이상 누적되면 실제 걸음 수에 추가
    if (_accumulatedSteps >= 1.0) {
      int wholSteps = _accumulatedSteps.floor();
      _todaySteps += wholSteps;
      _totalSteps += wholSteps;
      _accumulatedSteps -= wholSteps;
      _storageService.saveTotalSteps(_totalSteps);
      notifyListeners();
    }
  }

  /// 추적 중지
  void stopTracking() {
    if (!_isTracking) return;

    _updateTimer?.cancel();
    _updateTimer = null;
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    _isTracking = false;
    notifyListeners();
  }

  /// 특정 거리(km)에 필요한 걸음 수 계산
  int getStepsForDistance(double kilometers) {
    return (kilometers * 1000 / 0.762).round();
  }

  /// 특정 거리를 걸었는지 확인
  bool hasWalkedDistance(double kilometers) {
    return todayDistanceKm >= kilometers;
  }

  /// 어제 걸음 수 가져오기
  Future<int> getYesterdaySteps() async {
    return await _healthService.getYesterdaySteps();
  }

  /// 지난 7일 걸음 수 가져오기
  Future<int> getWeekSteps() async {
    return await _healthService.getWeekSteps();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }
}
