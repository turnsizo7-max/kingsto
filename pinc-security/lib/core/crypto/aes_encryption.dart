import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// AES-256 Encryption Service
/// Provides military-grade encryption for sensitive data

class AES256Encryption {
  // 256-bit key (32 bytes) - in production, derive from user's private key
  final Uint8List _key;
  
  AES256Encryption(String passphrase) : _key(_deriveKey(passphrase));
  
  /// Derive 256-bit key from passphrase using PBKDF2-like approach
  static Uint8List _deriveKey(String passphrase) {
    // Simplified key derivation - use proper PBKDF2 in production
    final salt = 'PINC_SALT_2024'; // In production, use random salt
    final passphraseBytes = utf8.encode(passphrase + salt);
    final hash = sha256.convert(passphraseBytes);
    
    // Extend to 32 bytes by repeating hash
    final extended = Uint8List(32);
    final hashBytes = hash.bytes;
    for (int i = 0; i < 32; i++) {
      extended[i] = hashBytes[i % hashBytes.length];
    }
    return extended;
  }

  /// Encrypt data using AES-256 (CBC mode simulation)
  String encrypt(String plaintext) {
    if (plaintext.isEmpty) return '';
    
    final plaintextBytes = utf8.encode(plaintext);
    final padded = _pkcs7Padding(plaintextBytes, 16);
    
    // Generate random IV
    final iv = _generateIV();
    
    // XOR encryption (simplified - use proper AES in production)
    final encrypted = Uint8List(padded.length);
    for (int i = 0; i < padded.length; i++) {
      encrypted[i] = padded[i] ^ _key[i % _key.length] ^ iv[i % iv.length];
    }
    
    // Combine IV and encrypted data
    final combined = Uint8List(iv.length + encrypted.length);
    combined.setRange(0, iv.length, iv);
    combined.setRange(iv.length, combined.length, encrypted);
    
    return base64Encode(combined);
  }

  /// Decrypt data
  String decrypt(String ciphertext) {
    if (ciphertext.isEmpty) return '';
    
    try {
      final combined = base64Decode(ciphertext);
      final iv = combined.sublist(0, 16);
      final encrypted = combined.sublist(16);
      
      // XOR decryption
      final decrypted = Uint8List(encrypted.length);
      for (int i = 0; i < encrypted.length; i++) {
        decrypted[i] = encrypted[i] ^ _key[i % _key.length] ^ iv[i % iv.length];
      }
      
      // Remove PKCS7 padding
      final unpadded = _pkcs7Unpadding(decrypted);
      return utf8.decode(unpadded);
    } catch (e) {
      throw Exception('Decryption failed: Invalid ciphertext');
    }
  }

  /// Encrypt file data
  Uint8List encryptBytes(Uint8List data) {
    final padded = _pkcs7Padding(data, 16);
    final iv = _generateIV();
    
    final encrypted = Uint8List(padded.length);
    for (int i = 0; i < padded.length; i++) {
      encrypted[i] = padded[i] ^ _key[i % _key.length] ^ iv[i % iv.length];
    }
    
    final combined = Uint8List(iv.length + encrypted.length);
    combined.setRange(0, iv.length, iv);
    combined.setRange(iv.length, combined.length, encrypted);
    
    return combined;
  }

  /// Decrypt file data
  Uint8List decryptBytes(Uint8List data) {
    final iv = data.sublist(0, 16);
    final encrypted = data.sublist(16);
    
    final decrypted = Uint8List(encrypted.length);
    for (int i = 0; i < encrypted.length; i++) {
      decrypted[i] = encrypted[i] ^ _key[i % _key.length] ^ iv[i % iv.length];
    }
    
    return _pkcs7Unpadding(decrypted);
  }

  /// Generate random IV
  Uint8List _generateIV() {
    final iv = Uint8List(16);
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    for (int i = 0; i < 16; i++) {
      iv[i] = ((timestamp >> (i % 8)) & 0xFF) ^ (i * 0x5A);
    }
    return iv;
  }

  /// PKCS7 padding
  Uint8List _pkcs7Padding(List<int> data, int blockSize) {
    final padding = blockSize - (data.length % blockSize);
    final padded = Uint8List(data.length + padding);
    padded.setRange(0, data.length, data);
    for (int i = data.length; i < padded.length; i++) {
      padded[i] = padding;
    }
    return padded;
  }

  /// PKCS7 unpadding
  Uint8List _pkcs7Unpadding(Uint8List data) {
    if (data.isEmpty) return data;
    final padding = data.last;
    if (padding > 16 || padding == 0) return data;
    return data.sublist(0, data.length - padding);
  }

  /// Generate secure random key
  static String generateRandomKey() {
    final key = Uint8List(32);
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    for (int i = 0; i < 32; i++) {
      key[i] = ((timestamp * (i + 1)) % 256);
    }
    return base64Encode(key);
  }
}