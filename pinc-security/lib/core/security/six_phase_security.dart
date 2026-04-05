import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 6-Phase Security System
/// Phase 1: PIN
/// Phase 2: Password
/// Phase 3: Seed Phrase
/// Phase 4: Private Key
/// Phase 5: Pattern
/// Phase 6: Security Questions

class SecurityPhase {
  final int phaseNumber;
  final String name;
  final bool isCompleted;
  final DateTime? completedAt;

  SecurityPhase({
    required this.phaseNumber,
    required this.name,
    this.isCompleted = false,
    this.completedAt,
  });
}

class SixPhaseSecurityService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  static const String _pinKey = 'security_pin';
  static const String _passwordKey = 'security_password';
  static const String _seedKey = 'security_seed';
  static const String _privateKeyKey = 'security_private_key';
  static const String _patternKey = 'security_pattern';
  static const String _questionsKey = 'security_questions';
  static const String _phaseProgressKey = 'security_phase_progress';
  static const String _deviceIdKey = 'device_fingerprint';

  // Get current phase progress
  Future<int> getCurrentPhase() async {
    final phase = await _secureStorage.read(key: _phaseProgressKey);
    return int.tryParse(phase ?? '0') ?? 0;
  }

  // Phase 1: PIN Authentication
  Future<bool> setPin(String pin) async {
    if (pin.length < 4 || pin.length > 8) return false;
    final hashedPin = _hashData(pin);
    await _secureStorage.write(key: _pinKey, value: hashedPin);
    return true;
  }

  Future<bool> verifyPin(String pin) async {
    final stored = await _secureStorage.read(key: _pinKey);
    if (stored == null) return false;
    return stored == _hashData(pin);
  }

  // Phase 2: Password Authentication
  Future<bool> setPassword(String password) async {
    if (password.length < 8) return false;
    final hashedPassword = _hashData(password);
    await _secureStorage.write(key: _passwordKey, value: hashedPassword);
    return true;
  }

  Future<bool> verifyPassword(String password) async {
    final stored = await _secureStorage.read(key: _passwordKey);
    if (stored == null) return false;
    return stored == _hashData(password);
  }

  // Phase 3: Seed Phrase (12-24 words)
  Future<bool> setSeedPhrase(String seedPhrase) async {
    final words = seedPhrase.split(' ');
    if (words.length < 12 || words.length > 24) return false;
    final encrypted = _encrypt(seedPhrase);
    await _secureStorage.write(key: _seedKey, value: encrypted);
    return true;
  }

  Future<String?> getSeedPhrase() async {
    final encrypted = await _secureStorage.read(key: _seedKey);
    if (encrypted == null) return null;
    return _decrypt(encrypted);
  }

  // Phase 4: Private Key
  Future<bool> setPrivateKey(String privateKey) async {
    if (privateKey.length < 64) return false; // 256-bit key
    final encrypted = _encrypt(privateKey);
    await _secureStorage.write(key: _privateKeyKey, value: encrypted);
    return true;
  }

  Future<String?> getPrivateKey() async {
    final encrypted = await _secureStorage.read(key: _privateKeyKey);
    if (encrypted == null) return null;
    return _decrypt(encrypted);
  }

  // Phase 5: Pattern Lock
  Future<bool> setPattern(List<int> pattern) async {
    if (pattern.length < 4) return false;
    final patternString = pattern.join(',');
    final hashedPattern = _hashData(patternString);
    await _secureStorage.write(key: _patternKey, value: hashedPattern);
    return true;
  }

  Future<bool> verifyPattern(List<int> pattern) async {
    final stored = await _secureStorage.read(key: _patternKey);
    if (stored == null) return false;
    final patternString = pattern.join(',');
    return stored == _hashData(patternString);
  }

  // Phase 6: Security Questions
  Future<bool> setSecurityQuestions(Map<String, String> questions) async {
    if (questions.length < 3) return false;
    final jsonQuestions = jsonEncode(questions);
    final encrypted = _encrypt(jsonQuestions);
    await _secureStorage.write(key: _questionsKey, value: encrypted);
    return true;
  }

  Future<Map<String, String>?> getSecurityQuestions() async {
    final encrypted = await _secureStorage.read(key: _questionsKey);
    if (encrypted == null) return null;
    final decrypted = _decrypt(encrypted);
    return Map<String, String>.from(jsonDecode(decrypted));
  }

  // Complete a phase
  Future<void> completePhase(int phase) async {
    await _secureStorage.write(key: _phaseProgressKey, value: phase.toString());
  }

  // Get all phases status
  Future<List<SecurityPhase>> getPhasesStatus() async {
    final currentPhase = await getCurrentPhase();
    return [
      SecurityPhase(
        phaseNumber: 1,
        name: 'PIN',
        isCompleted: currentPhase >= 1,
      ),
      SecurityPhase(
        phaseNumber: 2,
        name: 'Password',
        isCompleted: currentPhase >= 2,
      ),
      SecurityPhase(
        phaseNumber: 3,
        name: 'Seed Phrase',
        isCompleted: currentPhase >= 3,
      ),
      SecurityPhase(
        phaseNumber: 4,
        name: 'Private Key',
        isCompleted: currentPhase >= 4,
      ),
      SecurityPhase(
        phaseNumber: 5,
        name: 'Pattern',
        isCompleted: currentPhase >= 5,
      ),
      SecurityPhase(
        phaseNumber: 6,
        name: 'Security Questions',
        isCompleted: currentPhase >= 6,
      ),
    ];
  }

  // Hash data using SHA-256
  String _hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // AES-256 Encryption (using simple XOR for demo - replace with proper AES in production)
  String _encrypt(String data) {
    // Note: This is a placeholder. In production, use a proper AES-256 library
    final key = 'pinc_secure_key_256bit_aes_encryption';
    final bytes = utf8.encode(data);
    final keyBytes = utf8.encode(key);
    final encrypted = List<int>.generate(
      bytes.length,
      (i) => bytes[i] ^ keyBytes[i % keyBytes.length],
    );
    return base64Encode(encrypted);
  }

  String _decrypt(String encryptedData) {
    final key = 'pinc_secure_key_256bit_aes_encryption';
    final encryptedBytes = base64Decode(encryptedData);
    final keyBytes = utf8.encode(key);
    final decrypted = List<int>.generate(
      encryptedBytes.length,
      (i) => encryptedBytes[i] ^ keyBytes[i % keyBytes.length],
    );
    return utf8.decode(decrypted);
  }

  // Reset all security
  Future<void> resetSecurity() async {
    await _secureStorage.deleteAll();
  }
}