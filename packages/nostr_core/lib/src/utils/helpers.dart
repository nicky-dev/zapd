import 'dart:convert';

/// Helper utilities for Nostr
class NostrHelpers {
  /// Convert hex string to bytes
  static List<int> hexToBytes(String hex) {
    final result = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      result.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return result;
  }

  /// Convert bytes to hex string
  static String bytesToHex(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Validate hex string
  static bool isValidHex(String hex) {
    return RegExp(r'^[0-9a-fA-F]+$').hasMatch(hex);
  }

  /// Validate public key
  static bool isValidPublicKey(String pubkey) {
    return pubkey.length == 64 && isValidHex(pubkey);
  }

  /// Validate private key
  static bool isValidPrivateKey(String privkey) {
    return privkey.length == 64 && isValidHex(privkey);
  }

  /// Validate event ID
  static bool isValidEventId(String eventId) {
    return eventId.length == 64 && isValidHex(eventId);
  }

  /// Sanitize content for JSON encoding
  static String sanitizeContent(String content) {
    return content
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  /// Get current Unix timestamp (seconds)
  static int nowTimestamp() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  /// Parse JSON safely
  static dynamic parseJson(String jsonString) {
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      return null;
    }
  }
}
