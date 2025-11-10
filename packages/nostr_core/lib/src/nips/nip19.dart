import 'package:bech32/bech32.dart';
import 'package:convert/convert.dart';

/// NIP-19: bech32-encoded entities
///
/// Specification: https://github.com/nostr-protocol/nips/blob/master/19.md
///
/// Supports encoding/decoding for:
/// - npub: public keys
/// - nsec: private keys
/// - note: note ids
class NIP19 {
  static const _nsecPrefix = 'nsec';
  static const _npubPrefix = 'npub';
  static const _notePrefix = 'note';

  /// Encode public key to npub
  static String encodePublicKey(String pubkeyHex) {
    try {
      final bytes = hex.decode(pubkeyHex);
      final fiveBitData = _convertBits(bytes, 8, 5, true);
      final bech32Data = Bech32(_npubPrefix, fiveBitData);
      return bech32.encode(bech32Data);
    } catch (e) {
      throw Exception('Failed to encode public key: $e');
    }
  }

  /// Decode npub to public key
  static String decodePublicKey(String npub) {
    try {
      final bech32Data = bech32.decode(npub);
      
      if (bech32Data.hrp != _npubPrefix) {
        throw Exception('Invalid npub prefix');
      }

      final eightBitData = _convertBits(bech32Data.data, 5, 8, false);
      return hex.encode(eightBitData);
    } catch (e) {
      throw Exception('Failed to decode npub: $e');
    }
  }

  /// Encode private key to nsec
  static String encodePrivateKey(String privkeyHex) {
    try {
      final bytes = hex.decode(privkeyHex);
      final fiveBitData = _convertBits(bytes, 8, 5, true);
      final bech32Data = Bech32(_nsecPrefix, fiveBitData);
      return bech32.encode(bech32Data);
    } catch (e) {
      throw Exception('Failed to encode private key: $e');
    }
  }

  /// Decode nsec to private key
  static String decodePrivateKey(String nsec) {
    try {
      final bech32Data = bech32.decode(nsec);
      
      if (bech32Data.hrp != _nsecPrefix) {
        throw Exception('Invalid nsec prefix');
      }

      final eightBitData = _convertBits(bech32Data.data, 5, 8, false);
      return hex.encode(eightBitData);
    } catch (e) {
      throw Exception('Failed to decode nsec: $e');
    }
  }

  /// Encode note id to note
  static String encodeNote(String noteIdHex) {
    try {
      final bytes = hex.decode(noteIdHex);
      final fiveBitData = _convertBits(bytes, 8, 5, true);
      final bech32Data = Bech32(_notePrefix, fiveBitData);
      return bech32.encode(bech32Data);
    } catch (e) {
      throw Exception('Failed to encode note: $e');
    }
  }

  /// Decode note to note id
  static String decodeNote(String note) {
    try {
      final bech32Data = bech32.decode(note);
      
      if (bech32Data.hrp != _notePrefix) {
        throw Exception('Invalid note prefix');
      }

      final eightBitData = _convertBits(bech32Data.data, 5, 8, false);
      return hex.encode(eightBitData);
    } catch (e) {
      throw Exception('Failed to decode note: $e');
    }
  }

  /// Check if a string is a valid nsec
  static bool isNsec(String value) {
    try {
      final bech32Data = bech32.decode(value);
      return bech32Data.hrp == _nsecPrefix;
    } catch (e) {
      return false;
    }
  }

  /// Check if a string is a valid npub
  static bool isNpub(String value) {
    try {
      final bech32Data = bech32.decode(value);
      return bech32Data.hrp == _npubPrefix;
    } catch (e) {
      return false;
    }
  }

  /// Check if a string is a valid note
  static bool isNote(String value) {
    try {
      final bech32Data = bech32.decode(value);
      return bech32Data.hrp == _notePrefix;
    } catch (e) {
      return false;
    }
  }

  /// Check if a string is a valid hex key (64 characters)
  static bool isHexKey(String value) {
    return RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(value);
  }

  /// Convert bits from one base to another
  static List<int> _convertBits(
    List<int> data,
    int fromBits,
    int toBits,
    bool pad,
  ) {
    var acc = 0;
    var bits = 0;
    final result = <int>[];
    final maxv = (1 << toBits) - 1;

    for (final value in data) {
      if (value < 0 || (value >> fromBits) != 0) {
        throw Exception('Invalid data');
      }
      acc = (acc << fromBits) | value;
      bits += fromBits;
      while (bits >= toBits) {
        bits -= toBits;
        result.add((acc >> bits) & maxv);
      }
    }

    if (pad) {
      if (bits > 0) {
        result.add((acc << (toBits - bits)) & maxv);
      }
    } else if (bits >= fromBits || ((acc << (toBits - bits)) & maxv) != 0) {
      throw Exception('Invalid padding');
    }

    return result;
  }
}
