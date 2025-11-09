import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nostr_core/nostr_core.dart';

/// Session storage for NIP-46 sessions
class Nip46SessionStorage {
  static const _storage = FlutterSecureStorage();
  static const _sessionKey = 'nip46_session';

  /// Save session to secure storage
  static Future<void> saveSession(Nip46Session session) async {
    final sessionJson = jsonEncode(session.toJson());
    await _storage.write(key: _sessionKey, value: sessionJson);
  }

  /// Load session from secure storage
  static Future<Nip46Session?> loadSession() async {
    try {
      final sessionJson = await _storage.read(key: _sessionKey);
      if (sessionJson == null) {
        return null;
      }

      final sessionMap = jsonDecode(sessionJson) as Map<String, dynamic>;
      return Nip46Session.fromJson(sessionMap);
    } catch (e) {
      // Invalid session data, delete it
      await deleteSession();
      return null;
    }
  }

  /// Delete stored session
  static Future<void> deleteSession() async {
    await _storage.delete(key: _sessionKey);
  }

  /// Check if session exists
  static Future<bool> hasSession() async {
    final session = await loadSession();
    return session != null;
  }
}
