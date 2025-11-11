import 'dart:typed_data';
import 'dart:math';
import 'package:pointycastle/export.dart';

/// Key pair for Nostr (secp256k1)
class KeyPair {
  final String privateKey;
  final String publicKey;

  const KeyPair({
    required this.privateKey,
    required this.publicKey,
  });

  /// Generate new key pair using secp256k1
  factory KeyPair.generate() {
    final random = FortunaRandom();
    final seed = _generateSeed();
    random.seed(KeyParameter(seed));

    final domainParams = ECDomainParameters('secp256k1');
    final keyGen = ECKeyGenerator();
    keyGen.init(ParametersWithRandom(
      ECKeyGeneratorParameters(domainParams),
      random,
    ));

    final keyPair = keyGen.generateKeyPair();
  final privateKey = keyPair.privateKey;
  final publicKey = keyPair.publicKey;

    var privateKeyBigInt = privateKey.d!;
    var publicKeyPoint = publicKey.Q!;
    
    // BIP-340: Ensure public key has even y-coordinate
    // If y is odd, negate the private key
    final y = publicKeyPoint.y!.toBigInteger()!;
    if (y.isOdd) {
      privateKeyBigInt = domainParams.n - privateKeyBigInt;
      // Recompute public key with negated private key
      publicKeyPoint = (domainParams.G * privateKeyBigInt)!;
    }

    final privateKeyHex = privateKeyBigInt.toRadixString(16).padLeft(64, '0');
    final publicKeyHex = _encodePublicKey(publicKeyPoint);

    return KeyPair(
      privateKey: privateKeyHex,
      publicKey: publicKeyHex,
    );
  }

  /// Create key pair from private key hex
  factory KeyPair.fromPrivateKey(String privateKeyHex) {
    final domainParams = ECDomainParameters('secp256k1');
    var d = BigInt.parse(privateKeyHex, radix: 16);
    var Q = (domainParams.G * d)!;

    // BIP-340: Ensure public key has even y-coordinate
    final y = Q.y!.toBigInteger()!;
    if (y.isOdd) {
      d = domainParams.n - d;
      Q = (domainParams.G * d)!;
    }

    final finalPrivateKeyHex = d.toRadixString(16).padLeft(64, '0');
    final publicKeyHex = _encodePublicKey(Q);

    return KeyPair(
      privateKey: finalPrivateKeyHex,
      publicKey: publicKeyHex,
    );
  }

  /// Generate secure random seed
  static Uint8List _generateSeed() {
    final random = Random.secure();
    return Uint8List.fromList(
      List.generate(32, (_) => random.nextInt(256)),
    );
  }

  /// Encode EC point to x-only public key (32 bytes)
  static String _encodePublicKey(ECPoint point) {
    final x = point.x!.toBigInteger()!;
    return x.toRadixString(16).padLeft(64, '0');
  }

  /// Get public key from hex string
  static String publicKeyFromHex(String hex) {
    return hex;
  }

  /// Convert to hex format
  Map<String, String> toHex() => {
        'privateKey': privateKey,
        'publicKey': publicKey,
      };

  @override
  String toString() => 'KeyPair(pubkey: ${publicKey.substring(0, 8)}...)';
}
