import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Anti-Theft Service
/// Features: Shutdown protection, SIM detection, unauthorized access alerts

class AntiTheftService {
  static const String _enabledKey = 'antitheft_enabled';
  static const String _simStateKey = 'antitheft_sim_state';
  static const String _shutdownProtectedKey = 'antitheft_shutdown_protected';
  static const String _trustedNumbersKey = 'antitheft_trusted_numbers';
  
  SharedPreferences? _prefs;

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Enable anti-theft protection
  Future<void> enableAntiTheft({
    required bool shutdownProtection,
    required bool simChangeDetection,
  }) async {
    await _init();
    await _prefs!.setBool(_enabledKey, true);
    await _prefs!.setBool(_shutdownProtectedKey, shutdownProtection);
    await _prefs!.setBool(_simStateKey, simChangeDetection);
  }

  /// Disable anti-theft protection
  Future<void> disableAntiTheft() async {
    await _init();
    await _prefs!.setBool(_enabledKey, false);
  }

  /// Check if anti-theft is enabled
  Future<bool> isEnabled() async {
    await _init();
    return _prefs!.getBool(_enabledKey) ?? false;
  }

  /// Check if shutdown protection is enabled
  Future<bool> isShutdownProtected() async {
    await _init();
    return _prefs!.getBool(_shutdownProtectedKey) ?? false;
  }

  /// Add trusted phone number for alerts
  Future<void> addTrustedNumber(String phoneNumber) async {
    await _init();
    final numbers = await getTrustedNumbers();
    if (!numbers.contains(phoneNumber)) {
      numbers.add(phoneNumber);
      await _prefs!.setStringList(_trustedNumbersKey, numbers);
    }
  }

  /// Remove trusted phone number
  Future<void> removeTrustedNumber(String phoneNumber) async {
    await _init();
    final numbers = await getTrustedNumbers();
    numbers.remove(phoneNumber);
    await _prefs!.setStringList(_trustedNumbersKey, numbers);
  }

  /// Get list of trusted numbers
  Future<List<String>> getTrustedNumbers() async {
    await _init();
    return _prefs!.getStringList(_trustedNumbersKey) ?? [];
  }

  /// Store SIM card info for comparison
  Future<void> storeSimState(String simInfo) async {
    await _init();
    await _prefs!.setString('current_sim_state', simInfo);
  }

  /// Check if SIM card has changed
  Future<bool> hasSimChanged(String newSimInfo) async {
    await _init();
    final stored = _prefs!.getString('current_sim_state');
    if (stored == null) return false;
    return stored != newSimInfo;
  }

  /// Trigger anti-theft alarm (would send SMS in production)
  Future<void> triggerAlarm(String reason) async {
    // In production: Send SMS to trusted numbers
    // Send push notification
    // Log to server
    print('ANTI-THEFT ALARM: $reason');
    
    // Could optionally:
    // - Take photo of intruder
    // - Send location
    // - Lock device
  }

  /// Get device lock status
  Future<bool> isDeviceLocked() async {
    await _init();
    return _prefs!.getBool('device_locked') ?? false;
  }

  /// Lock device remotely
  Future<void> lockDevice() async {
    await _init();
    await _prefs!.setBool('device_locked', true);
  }

  /// Unlock device
  Future<void> unlockDevice() async {
    await _init();
    await _prefs!.setBool('device_locked', false);
  }

  /// Wipe device data (factory reset)
  Future<void> wipeDeviceData() async {
    await _init();
    // In production: This would trigger factory reset
    // Use flutter_device_reset or platform channels
    await _prefs!.clear();
  }
}