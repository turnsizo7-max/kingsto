import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Admin Panel Service
/// Master key: david orata anglex ambuch elderman makaveli
/// Used for administrative functions and emergency access

class AdminService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Master key hash (SHA-256 of the combined key)
  static const String _masterKeyHash = '8f7c9a2e5d3b4f6a8c1e7d9b2a4f5c6e8d1a3b5c7e9f0a2b4d6c8e0f2a4'; // Placeholder
  
  // Admin log storage
  static const String _adminLogKey = 'admin_activity_log';
  
  // Your provided keys
  static const List<String> validKeys = [
    'david',
    'orata',
    'anglex',
    'ambuch',
    'elderman',
    'makaveli',
  ];

  /// Verify master key (any of the valid keys)
  bool verifyMasterKey(String key) {
    return validKeys.contains(key.toLowerCase());
  }

  /// Authenticate with master key
  Future<bool> authenticate(String key) async {
    if (!verifyMasterKey(key)) {
      await _logActivity('FAILED_ADMIN_LOGIN', 'Invalid key attempt');
      return false;
    }
    await _logActivity('ADMIN_LOGIN', 'Successful admin login');
    return true;
  }

  /// Grant admin access (store admin session)
  Future<void> grantAdminAccess(String key) async {
    final hashedKey = _hashData(key);
    await _secureStorage.write(key: 'admin_session', value: hashedKey);
    await _logActivity('ADMIN_ACCESS_GRANTED', 'Admin access granted');
  }

  /// Check if admin session is active
  Future<bool> isAdminAuthenticated() async {
    final session = await _secureStorage.read(key: 'admin_session');
    return session != null;
  }

  /// Revoke admin access
  Future<void> revokeAdminAccess() async {
    await _secureStorage.delete(key: 'admin_session');
    await _logActivity('ADMIN_ACCESS_REVOKED', 'Admin access revoked');
  }

  /// Get user security status (for admin panel)
  Future<Map<String, dynamic>> getSecurityStatus() async {
    final phases = await _secureStorage.read(key: 'security_phase_progress');
    final deviceFp = await _secureStorage.read(key: 'device_fingerprint');
    final antiTheft = await _secureStorage.read(key: 'antitheft_enabled');
    
    return {
      'currentPhase': int.tryParse(phases ?? '0') ?? 0,
      'deviceFingerprintConfigured': deviceFp != null,
      'antiTheftEnabled': antiTheft == 'true',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Unlock user account (admin override)
  Future<void> unlockUserAccount() async {
    await _secureStorage.write(key: 'account_locked', value: 'false');
    await _logActivity('ACCOUNT_UNLOCKED', 'Admin unlocked user account');
  }

  /// Lock user account (admin override)
  Future<void> lockUserAccount() async {
    await _secureStorage.write(key: 'account_locked', value: 'true');
    await _logActivity('ACCOUNT_LOCKED', 'Admin locked user account');
  }

  /// Reset user PIN (admin override)
  Future<void> resetUserPin() async {
    await _secureStorage.delete(key: 'security_pin');
    await _logActivity('PIN_RESET', 'Admin reset user PIN');
  }

  /// Get admin activity log
  Future<List<Map<String, dynamic>>> getActivityLog() async {
    final logJson = await _secureStorage.read(key: _adminLogKey);
    if (logJson == null) return [];
    final List<dynamic> logs = jsonDecode(logJson);
    return logs.cast<Map<String, dynamic>>();
  }

  /// Log admin activity
  Future<void> _logActivity(String action, String details) async {
    final logs = await getActivityLog();
    logs.add({
      'action': action,
      'details': details,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    // Keep only last 100 entries
    if (logs.length > 100) {
      logs.removeRange(0, logs.length - 100);
    }
    
    await _secureStorage.write(key: _adminLogKey, value: jsonEncode(logs));
  }

  /// Clear all user security (admin override - dangerous!)
  Future<void> clearAllSecurity() async {
    await _logActivity('SECURITY_CLEARED', 'Admin cleared all security settings');
    await _secureStorage.deleteAll();
  }

  // Hash data using SHA-256
  String _hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}