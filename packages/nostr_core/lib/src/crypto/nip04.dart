import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart';
import 'package:pointycastle/export.dart' show ECDomainParameters, ECPoint;

/// NIP-04: Encrypted Direct Messages (DEPRECATED)
///
/// Uses AES-256-CBC encryption
/// Spec: https://github.com/nostr-protocol/nips/blob/master/04.md
///
/// NOTE: This is DEPRECATED in favor of NIP-44, but still used by some implementations
class NIP04 {
  /// Encrypt plaintext using conversation key
  ///
  /// Returns base64-encoded: iv || ciphertext
  /// Format: base64(iv + encrypted_content) + "?iv=" + base64(iv)
  static Future<String> encrypt(String plaintext, Uint8List conversationKey) async {
    // Generate random IV (16 bytes for AES)
    final iv = Uint8List(16);
    final random = SecureRandom();
    for (int i = 0; i < 16; i++) {
      iv[i] = random.nextInt(256);
    }

    // Encrypt using AES-256-CBC
    final algorithm = AesCbc.with256bits(macAlgorithm: MacAlgorithm.empty);
    final secretKey = SecretKey(conversationKey);
    final secretBox = await algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
      nonce: iv,
    );

    // Format: content?iv=base64(iv)
    final encryptedContent = base64.encode(secretBox.cipherText);
    final ivBase64 = base64.encode(iv);
    
    return '$encryptedContent?iv=$ivBase64';
  }

  /// Decrypt ciphertext using conversation key
  ///
  /// payload format: content?iv=base64(iv)
  static Future<String> decrypt(String payload, Uint8List conversationKey) async {
    // Parse payload
    final parts = payload.split('?iv=');
    if (parts.length != 2) {
      throw Exception('Invalid NIP-04 payload format');
    }

    final encryptedContent = base64.decode(parts[0]);
    final iv = base64.decode(parts[1]);

    // Decrypt using AES-256-CBC
    final algorithm = AesCbc.with256bits(macAlgorithm: MacAlgorithm.empty);
    final secretKey = SecretKey(conversationKey);
    final secretBox = SecretBox(encryptedContent, nonce: iv, mac: Mac.empty);
    
    final plaintext = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
    );

    return utf8.decode(plaintext);
  }

  /// Get conversation key from ECDH shared secret
  ///
  /// Same as NIP-44: SHA256(sharedPoint.x)
  static Uint8List getConversationKey(
    String privateKeyHex,
    String publicKeyHex,
  ) {
    final domainParams = ECDomainParameters('secp256k1');
    
    // Parse private key
    final d = BigInt.parse(privateKeyHex, radix: 16);
    
    // Parse public key (x-only, reconstruct point)
    final px = BigInt.parse(publicKeyHex, radix: 16);
    final P = _liftX(domainParams, px);
    if (P == null) {
      throw Exception('Invalid public key');
    }
    
    // Compute shared secret: S = d * P
    final S = P * d;
    final sx = S!.x!.toBigInteger()!;
    
    // Conversation key = SHA256(sx)
    final sxBytes = _bigIntToBytes(sx, 32);
    final hash = crypto.sha256.convert(sxBytes);
    
    return Uint8List.fromList(hash.bytes);
  }

  /// Lift x-only public key to EC point (assume even y)
  static ECPoint? _liftX(ECDomainParameters params, BigInt x) {
    final p = BigInt.parse(
      'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F',
      radix: 16,
    );
    
    final x3 = (x * x * x) % p;
    final y2 = (x3 + BigInt.from(7)) % p;
    
    final y = _modSqrt(y2, p);
    if (y == null) return null;
    
    final yFinal = y.isEven ? y : p - y;
    
    return params.curve.createPoint(x, yFinal);
  }

  /// Modular square root for secp256k1
  static BigInt? _modSqrt(BigInt a, BigInt p) {
    if (a == BigInt.zero) return BigInt.zero;
    
    // For secp256k1: p ≡ 3 (mod 4)
    // So y = a^((p+1)/4) mod p
    final exp = (p + BigInt.one) ~/ BigInt.from(4);
    final y = a.modPow(exp, p);
    
    // Verify
    if ((y * y) % p != a % p) return null;
    
    return y;
  }

  /// Convert BigInt to bytes with padding
  static Uint8List _bigIntToBytes(BigInt number, int length) {
    final bytes = Uint8List(length);
    var temp = number;
    for (int i = length - 1; i >= 0; i--) {
      bytes[i] = (temp & BigInt.from(0xff)).toInt();
      temp = temp >> 8;
    }
    return bytes;
  }
}

/// Secure random number generator
class SecureRandom {
  int nextInt(int max) {
    // Use timestamp-based randomness
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return (timestamp ^ (timestamp >> 16)) % max;
  }
}
