import 'package:bip340/bip340.dart' as bip340;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:convert/convert.dart';

/// Schnorr signature implementation for Nostr (BIP-340)
/// Using official bip340 package with correct BIP-340 implementation
class Schnorr {
  /// Sign message hash with private key
  /// Returns Schnorr signature (64 bytes hex)
  static String sign(String messageHash, String privateKeyHex) {
    // Use random auxiliary bytes (can be all zeros or random)
    final aux = _getRandomAux();
    return bip340.sign(privateKeyHex, messageHash, aux);
  }

  /// Verify Schnorr signature
  static bool verify(String signature, String messageHash, String publicKeyHex) {
    try {
      return bip340.verify(publicKeyHex, messageHash, signature);
    } catch (e) {
      print('❌ Schnorr verify error: $e');
      return false;
    }
  }

  /// Get public key from private key (x-only, 32 bytes)
  static String getPublicKey(String privateKeyHex) {
    return bip340.getPublicKey(privateKeyHex);
  }

  /// Get random auxiliary bytes for signing (32 bytes)
  /// This is used for nonce generation in BIP-340
  static String _getRandomAux() {
    // Generate deterministic but unpredictable auxiliary randomness
    // Use combination of timestamp and private key material
    final timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    final random = DateTime.now().millisecondsSinceEpoch % 1000000;
    final combined = '$timestamp-$random';
    final hash = sha256.convert(utf8.encode(combined));
    return hex.encode(hash.bytes);
  }
}
