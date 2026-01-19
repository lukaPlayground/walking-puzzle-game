import 'package:flutter/foundation.dart';
import '../services/pedometer_service.dart';
import '../services/storage_service.dart';

class StepCounterProvider with ChangeNotifier {
  final PedometerService _pedometerService = PedometerService();
  final StorageService _storageService = StorageService();

  int _todaySteps = 0;
  int _totalSteps = 0;
  String _pedestrianStatus = 'stopped';
  bool _isTracking = false;

  int get todaySteps => _todaySteps;
  int get totalSteps => _totalSteps;
  String get pedestrianStatus => _pedestrianStatus;
  bool get isTracking => _isTracking;
  double get todayDistanceKm => _pedometerService.stepsToKilometers(_todaySteps);
  double get todayCalories => _pedometerService.stepsToCalories(_todaySteps);

  Future<void> initialize() async {
    await _loadStoredData();
    await _checkAndResetDailySteps();
  }

  Future<void> _loadStoredData() async {
    _totalSteps = await _storageService.loadTotalSteps();
    notifyListeners();
  }

  Future<void> _checkAndResetDailySteps() async {
    final shouldReset = await _storageService.shouldResetDailySteps();
    if (shouldReset) {
      _todaySteps = 0;
      await _storageService.saveLastStepResetDate(DateTime.now());
      _pedometerService.resetDailySteps();
      notifyListeners();
    }
  }

  void startTracking() {
    if (_isTracking) return;

    _pedometerService.startStepCounting();
    _isTracking = true;

    _pedometerService.stepCountStream.listen((steps) {
      _todaySteps = steps;
      _totalSteps += 1;
      _storageService.saveTotalSteps(_totalSteps);
      notifyListeners();
    });

    _pedometerService.pedestrianStatusStream.listen((status) {
      _pedestrianStatus = status;
      notifyListeners();
    });

    notifyListeners();
  }

  void stopTracking() {
    if (!_isTracking) return;

    _pedometerService.stopStepCounting();
    _isTracking = false;
    notifyListeners();
  }

  int getStepsForDistance(double kilometers) {
    return (kilometers * 1000 / 0.762).round();
  }

  bool hasWalkedDistance(double kilometers) {
    return todayDistanceKm >= kilometers;
  }

  @override
  void dispose() {
    _pedometerService.dispose();
    super.dispose();
  }
}
