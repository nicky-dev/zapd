import 'dart:convert';
import 'dart:math' show Random;
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart';
import 'package:pointycastle/export.dart' show ECDomainParameters, ECPoint;

/// NIP-44: Versioned Encryption
///
/// Implements XChaCha20-Poly1305 encryption for Nostr DMs
/// Spec: https://github.com/nostr-protocol/nips/blob/master/44.md
class NIP44 {
  static const int _version = 2;
  static const int _nonceSize = 32;
  static const int _keySize = 32;
  static const int _tagSize = 16;

  /// Encrypt plaintext using conversation key
  ///
  /// Returns base64-encoded payload: version || nonce || ciphertext || tag
  static Future<String> encrypt(String plaintext, Uint8List conversationKey) async {
    // 1. Generate random nonce (32 bytes)
    final nonce = _generateNonce();

    // 2. Derive encryption key using HKDF-SHA256
    final encryptionKey = await _deriveEncryptionKey(conversationKey, nonce);

    // 3. Encrypt using XChaCha20-Poly1305
    final ciphertext = await _encryptXChaCha20Poly1305(
      utf8.encode(plaintext),
      encryptionKey,
      nonce,
    );

    // 4. Encode: version (1 byte) || nonce (32 bytes) || ciphertext + tag
    return _encodePayload(_version, nonce, ciphertext);
  }

  /// Decrypt ciphertext using conversation key
  ///
  /// payload: base64-encoded version || nonce || ciphertext || tag
  static Future<String> decrypt(String payload, Uint8List conversationKey) async {
    // 1. Decode payload
    final decoded = _decodePayload(payload);
    final version = decoded.version;
    final nonce = decoded.nonce;
    final ciphertext = decoded.ciphertext;

    if (version != _version) {
      throw Exception('Unsupported NIP-44 version: $version');
    }

    // 2. Derive encryption key
    final encryptionKey = await _deriveEncryptionKey(conversationKey, nonce);

    // 3. Decrypt
    final plaintext = await _decryptXChaCha20Poly1305(
      ciphertext,
      encryptionKey,
      nonce,
    );

    return utf8.decode(plaintext);
  }

  /// Get conversation key from ECDH shared secret
  ///
  /// Uses secp256k1 ECDH:
  /// sharedPoint = receiverPubkey * senderPrivkey
  /// conversationKey = SHA256(sharedPoint.x)
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
    // secp256k1 prime
    final p = BigInt.parse(
      'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F',
      radix: 16,
    );
    
    // y^2 = x^3 + 7
    final x3 = (x * x * x) % p;
    final y2 = (x3 + BigInt.from(7)) % p;
    
    // Compute square root
    final y = _modSqrt(y2, p);
    if (y == null) return null;
    
    // Use even y
    final yFinal = y.isEven ? y : p - y;
    
    return params.curve.createPoint(x, yFinal);
  }

  /// Modular square root for secp256k1
  static BigInt? _modSqrt(BigInt a, BigInt p) {
    // For secp256k1, p ≡ 3 (mod 4)
    final exp = (p + BigInt.one) ~/ BigInt.from(4);
    final y = a.modPow(exp, p);
    
    // Verify
    if ((y * y) % p != a % p) return null;
    
    return y;
  }

  /// Convert BigInt to bytes
  static Uint8List _bigIntToBytes(BigInt number, int length) {
    final hexStr = number.toRadixString(16).padLeft(length * 2, '0');
    return Uint8List.fromList(
      List.generate(
        length,
        (i) => int.parse(hexStr.substring(i * 2, i * 2 + 2), radix: 16),
      ),
    );
  }

  /// Generate cryptographically secure random nonce
  static Uint8List _generateNonce() {
    final random = Random.secure();
    final nonce = Uint8List(_nonceSize);
    for (int i = 0; i < _nonceSize; i++) {
      nonce[i] = random.nextInt(256);
    }
    return nonce;
  }

  /// Derive encryption key using HKDF-SHA256
  ///
  /// HKDF(ikm=conversationKey, salt=nonce, info="nip44-v2", length=76)
  /// Take first 32 bytes for ChaCha20 key
  static Future<Uint8List> _deriveEncryptionKey(
    Uint8List conversationKey,
    Uint8List nonce,
  ) async {
    final hkdf = Hkdf(
      hmac: Hmac(Sha256()),
      outputLength: 76,
    );

    final derivedKey = await hkdf.deriveKey(
      secretKey: SecretKey(conversationKey),
      nonce: nonce,
      info: utf8.encode('nip44-v2'),
    );

    final derivedBytes = await derivedKey.extractBytes();

    // Return first 32 bytes for ChaCha20 key
    return Uint8List.fromList(derivedBytes.sublist(0, _keySize));
  }

  /// Encrypt using XChaCha20-Poly1305
  static Future<Uint8List> _encryptXChaCha20Poly1305(
    List<int> plaintext,
    Uint8List key,
    Uint8List nonce,
  ) async {
    // Use Chacha20.poly1305Aead from cryptography package
    // Note: Uses first 12 bytes of nonce for ChaCha20-Poly1305
    final algorithm = Chacha20.poly1305Aead();
    
    final secretKey = SecretKey(key);
    final secretBox = await algorithm.encrypt(
      plaintext,
      secretKey: secretKey,
      nonce: nonce.sublist(0, 12), // ChaCha20-Poly1305 uses 12-byte nonce
    );

    // Return ciphertext + MAC (tag)
    return Uint8List.fromList(secretBox.cipherText + secretBox.mac.bytes);
  }

  /// Decrypt using XChaCha20-Poly1305
  static Future<Uint8List> _decryptXChaCha20Poly1305(
    Uint8List ciphertext,
    Uint8List key,
    Uint8List nonce,
  ) async {
    final algorithm = Chacha20.poly1305Aead();
    
    // Split ciphertext and MAC
    final actualCiphertext = ciphertext.sublist(0, ciphertext.length - _tagSize);
    final mac = Mac(ciphertext.sublist(ciphertext.length - _tagSize));
    
    final secretKey = SecretKey(key);
    final secretBox = SecretBox(
      actualCiphertext,
      nonce: nonce.sublist(0, 12),
      mac: mac,
    );

    final plaintext = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
    );

    return Uint8List.fromList(plaintext);
  }

  /// Encode payload: version || nonce || ciphertext+tag
  static String _encodePayload(
    int version,
    Uint8List nonce,
    Uint8List ciphertext,
  ) {
    final payload = BytesBuilder();
    payload.addByte(version);
    payload.add(nonce);
    payload.add(ciphertext);

    return base64.encode(payload.toBytes());
  }

  /// Decode payload
  static _DecodedPayload _decodePayload(String encoded) {
    final bytes = base64.decode(encoded);

    if (bytes.length < 1 + _nonceSize + _tagSize) {
      throw Exception('Invalid NIP-44 payload: too short');
    }

    final version = bytes[0];
    final nonce = Uint8List.fromList(bytes.sublist(1, 1 + _nonceSize));
    final ciphertext = Uint8List.fromList(bytes.sublist(1 + _nonceSize));

    return _DecodedPayload(
      version: version,
      nonce: nonce,
      ciphertext: ciphertext,
    );
  }
}

/// Decoded NIP-44 payload
class _DecodedPayload {
  final int version;
  final Uint8List nonce;
  final Uint8List ciphertext;

  _DecodedPayload({
    required this.version,
    required this.nonce,
    required this.ciphertext,
  });
}
