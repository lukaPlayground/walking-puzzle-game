import 'dart:async';
import 'package:pedometer/pedometer.dart';

class PedometerService {
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;

  final StreamController<int> _stepCountController =
      StreamController<int>.broadcast();
  final StreamController<String> _pedestrianStatusController =
      StreamController<String>.broadcast();

  Stream<int> get stepCountStream => _stepCountController.stream;
  Stream<String> get pedestrianStatusStream =>
      _pedestrianStatusController.stream;

  int _todaySteps = 0;
  int _initialSteps = 0;
  bool _isFirstReading = true;

  void startStepCounting() {
    _stepCountSubscription = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
      cancelOnError: false,
    );

    _pedestrianStatusSubscription = Pedometer.pedestrianStatusStream.listen(
      _onPedestrianStatusChanged,
      onError: _onPedestrianStatusError,
      cancelOnError: false,
    );
  }

  void _onStepCount(StepCount event) {
    if (_isFirstReading) {
      _initialSteps = event.steps;
      _isFirstReading = false;
    }

    _todaySteps = event.steps - _initialSteps;
    _stepCountController.add(_todaySteps);
  }

  void _onStepCountError(error) {
    _stepCountController.addError(error);
  }

  void _onPedestrianStatusChanged(PedestrianStatus event) {
    _pedestrianStatusController.add(event.status);
  }

  void _onPedestrianStatusError(error) {
    _pedestrianStatusController.addError(error);
  }

  void stopStepCounting() {
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    _stepCountSubscription = null;
    _pedestrianStatusSubscription = null;
  }

  int get currentSteps => _todaySteps;

  double stepsToKilometers(int steps) {
    const double averageStepLengthInMeters = 0.762;
    return (steps * averageStepLengthInMeters) / 1000;
  }

  double stepsToCalories(int steps) {
    const double caloriesPerStep = 0.04;
    return steps * caloriesPerStep;
  }

  void resetDailySteps() {
    _isFirstReading = true;
    _todaySteps = 0;
    _initialSteps = 0;
  }

  void dispose() {
    stopStepCounting();
    _stepCountController.close();
    _pedestrianStatusController.close();
  }
}
