import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Hardware Device Fingerprinting Service
/// Generates unique device identifiers for security purposes

class DeviceFingerprint {
  final String deviceId;
  final String deviceModel;
  final String deviceManufacturer;
  final String osVersion;
  final String platform;
  final bool isPhysicalDevice;
  final DateTime generatedAt;

  DeviceFingerprint({
    required this.deviceId,
    required this.deviceModel,
    required this.deviceManufacturer,
    required this.osVersion,
    required this.platform,
    required this.isPhysicalDevice,
    required this.generatedAt,
  });

  Map<String, dynamic> toJson() => {
    'deviceId': deviceId,
    'deviceModel': deviceModel,
    'deviceManufacturer': deviceManufacturer,
    'osVersion': osVersion,
    'platform': platform,
    'isPhysicalDevice': isPhysicalDevice,
    'generatedAt': generatedAt.toIso8601String(),
  };
}

class HardwareFingerprintService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  
  DeviceFingerprint? _cachedFingerprint;

  /// Generate unique device fingerprint
  Future<DeviceFingerprint> generateFingerprint() async {
    if (_cachedFingerprint != null) {
      return _cachedFingerprint!;
    }

    String deviceId;
    String deviceModel;
    String deviceManufacturer;
    String osVersion;
    String platform;
    bool isPhysicalDevice;

    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      deviceId = androidInfo.id; // Hardware serial
      deviceModel = androidInfo.model;
      deviceManufacturer = androidInfo.manufacturer;
      osVersion = 'Android ${androidInfo.version.release}';
      platform = 'Android';
      isPhysicalDevice = androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? '';
      deviceModel = iosInfo.utsname.machine;
      deviceManufacturer = 'Apple';
      osVersion = 'iOS ${iosInfo.systemVersion}';
      platform = 'iOS';
      isPhysicalDevice = iosInfo.isPhysicalDevice;
    } else {
      deviceId = 'unknown';
      deviceModel = 'unknown';
      deviceManufacturer = 'unknown';
      osVersion = 'unknown';
      platform = 'unknown';
      isPhysicalDevice = false;
    }

    // Generate hash-based device ID for privacy
    final fingerprintData = '$deviceId:$deviceModel:$deviceManufacturer';
    final hash = sha256.convert(utf8.encode(fingerprintData));
    deviceId = hash.toString();

    _cachedFingerprint = DeviceFingerprint(
      deviceId: deviceId,
      deviceModel: deviceModel,
      deviceManufacturer: deviceManufacturer,
      osVersion: osVersion,
      platform: platform,
      isPhysicalDevice: isPhysicalDevice,
      generatedAt: DateTime.now(),
    );

    return _cachedFingerprint!;
  }

  /// Verify if current device matches stored fingerprint
  Future<bool> verifyDevice(String storedFingerprintId) async {
    final current = await generateFingerprint();
    return current.deviceId == storedFingerprintId;
  }

  /// Get device threat level (basic detection)
  Future<int> getThreatLevel() async {
    int threatLevel = 0;
    
    final fp = await generateFingerprint();
    
    // Check if running on physical device
    if (!fp.isPhysicalDevice) {
      threatLevel += 30; // Emulator detected
    }
    
    // Check for rooted/jailbroken (basic check)
    // In production, use packages like root_checker
    
    return threatLevel;
  }

  void clearCache() {
    _cachedFingerprint = null;
  }
}