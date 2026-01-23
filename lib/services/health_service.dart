import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  final Health _health = Health();

  // 읽기 권한이 필요한 데이터 타입
  static final List<HealthDataType> _healthDataTypes = [
    HealthDataType.STEPS,
  ];

  // 모든 권한 (읽기 전용)
  static final List<HealthDataAccess> _permissions = [
    HealthDataAccess.READ,
  ];

  /// HealthKit/Health Connect 권한 요청
  Future<bool> requestHealthPermissions() async {
    try {
      // Activity Recognition 권한 요청 (Android)
      if (await Permission.activityRecognition.isDenied) {
        final status = await Permission.activityRecognition.request();
        if (!status.isGranted) {
          return false;
        }
      }

      // Health 데이터 권한 요청
      bool? hasPermissions = await _health.hasPermissions(
        _healthDataTypes,
        permissions: _permissions,
      );

      if (hasPermissions == null || !hasPermissions) {
        hasPermissions = await _health.requestAuthorization(
          _healthDataTypes,
          permissions: _permissions,
        );
      }

      return hasPermissions == true;
    } catch (e) {
      print('Error requesting health permissions: $e');
      return false;
    }
  }

  /// 오늘 걸음 수 가져오기
  Future<int> getTodaySteps() async {
    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      final steps = await _health.getTotalStepsInInterval(midnight, now);
      return steps ?? 0;
    } catch (e) {
      print('Error getting today steps: $e');
      return 0;
    }
  }

  /// 특정 기간의 걸음 수 가져오기
  Future<int> getStepsInInterval(DateTime startDate, DateTime endDate) async {
    try {
      final steps = await _health.getTotalStepsInInterval(startDate, endDate);
      return steps ?? 0;
    } catch (e) {
      print('Error getting steps in interval: $e');
      return 0;
    }
  }

  /// 어제 걸음 수 가져오기
  Future<int> getYesterdaySteps() async {
    try {
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      final todayMidnight = DateTime(now.year, now.month, now.day);

      final steps = await _health.getTotalStepsInInterval(
        yesterday,
        todayMidnight,
      );
      return steps ?? 0;
    } catch (e) {
      print('Error getting yesterday steps: $e');
      return 0;
    }
  }

  /// 지난 7일간 걸음 수 가져오기
  Future<int> getWeekSteps() async {
    try {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));

      final steps = await _health.getTotalStepsInInterval(weekAgo, now);
      return steps ?? 0;
    } catch (e) {
      print('Error getting week steps: $e');
      return 0;
    }
  }

  /// 걸음 수를 거리(km)로 변환
  double stepsToKilometers(int steps) {
    const double averageStepLengthInMeters = 0.762; // 평균 보폭
    return (steps * averageStepLengthInMeters) / 1000;
  }

  /// 걸음 수를 칼로리로 변환
  double stepsToCalories(int steps) {
    const double caloriesPerStep = 0.04; // 걸음당 평균 칼로리
    return steps * caloriesPerStep;
  }

  /// Health 데이터 접근 가능 여부 확인
  Future<bool> isHealthDataAvailable() async {
    try {
      final isAvailable = Health().isDataTypeAvailable(HealthDataType.STEPS);
      return isAvailable;
    } catch (e) {
      print('Error checking health data availability: $e');
      return false;
    }
  }
}
