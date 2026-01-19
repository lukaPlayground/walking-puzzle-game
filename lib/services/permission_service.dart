import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  Future<bool> requestActivityRecognitionPermission() async {
    final status = await Permission.activityRecognition.request();
    return status.isGranted;
  }

  Future<bool> checkLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  Future<bool> checkActivityRecognitionPermission() async {
    final status = await Permission.activityRecognition.status;
    return status.isGranted;
  }

  Future<Map<String, bool>> requestAllPermissions() async {
    final locationGranted = await requestLocationPermission();
    final activityGranted = await requestActivityRecognitionPermission();

    return {
      'location': locationGranted,
      'activityRecognition': activityGranted,
    };
  }

  Future<Map<String, bool>> checkAllPermissions() async {
    final locationGranted = await checkLocationPermission();
    final activityGranted = await checkActivityRecognitionPermission();

    return {
      'location': locationGranted,
      'activityRecognition': activityGranted,
    };
  }

  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }
}
