import 'dart:async';
import 'dart:js' as js;

/// NIP-07: window.nostr capability for web browsers
/// Supports browser extensions like nos2x, Alby, Flamingo
class Nip07Service {
  /// Check if window.nostr is available
  static bool isAvailable() {
    try {
      return js.context.hasProperty('nostr');
    } catch (e) {
      return false;
    }
  }

  /// Get public key from extension
  /// Returns hex public key
  static Future<String> getPublicKey() async {
    if (!isAvailable()) {
      throw Exception('Nostr extension not found');
    }

    try {
      final nostr = js.context['nostr'];
      final promise = nostr.callMethod('getPublicKey', []);
      final pubkey = await _promiseToFuture<String>(promise);
      return pubkey;
    } catch (e) {
      throw Exception('Failed to get public key: $e');
    }
  }

  /// Sign event with extension
  /// Returns signed event as Map
  static Future<Map<String, dynamic>> signEvent(
    Map<String, dynamic> event,
  ) async {
    if (!isAvailable()) {
      throw Exception('Nostr extension not found');
    }

    try {
      final nostr = js.context['nostr'];
      final eventJs = js.JsObject.jsify(event);
      final promise = nostr.callMethod('signEvent', [eventJs]);
      final signedEvent = await _promiseToFuture<js.JsObject>(promise);
      return _jsObjectToMap(signedEvent);
    } catch (e) {
      throw Exception('Failed to sign event: $e');
    }
  }

  /// Encrypt message with NIP-04 (deprecated but still supported)
  static Future<String> nip04Encrypt(String pubkey, String plaintext) async {
    if (!isAvailable()) {
      throw Exception('Nostr extension not found');
    }

    try {
      final nostr = js.context['nostr'];
      final nip04 = nostr['nip04'];
      final promise = nip04.callMethod('encrypt', [pubkey, plaintext]);
      final encrypted = await _promiseToFuture<String>(promise);
      return encrypted;
    } catch (e) {
      throw Exception('Failed to encrypt: $e');
    }
  }

  /// Decrypt message with NIP-04
  static Future<String> nip04Decrypt(String pubkey, String ciphertext) async {
    if (!isAvailable()) {
      throw Exception('Nostr extension not found');
    }

    try {
      final nostr = js.context['nostr'];
      final nip04 = nostr['nip04'];
      final promise = nip04.callMethod('decrypt', [pubkey, ciphertext]);
      final decrypted = await _promiseToFuture<String>(promise);
      return decrypted;
    } catch (e) {
      throw Exception('Failed to decrypt: $e');
    }
  }

  /// Encrypt message with NIP-44 (modern encryption)
  static Future<String> nip44Encrypt(String pubkey, String plaintext) async {
    if (!isAvailable()) {
      throw Exception('Nostr extension not found');
    }

    try {
      final nostr = js.context['nostr'];
      if (!nostr.hasProperty('nip44')) {
        throw Exception('NIP-44 not supported by this extension');
      }
      final nip44 = nostr['nip44'];
      final promise = nip44.callMethod('encrypt', [pubkey, plaintext]);
      final encrypted = await _promiseToFuture<String>(promise);
      return encrypted;
    } catch (e) {
      throw Exception('Failed to encrypt with NIP-44: $e');
    }
  }

  /// Decrypt message with NIP-44
  static Future<String> nip44Decrypt(String pubkey, String ciphertext) async {
    if (!isAvailable()) {
      throw Exception('Nostr extension not found');
    }

    try {
      final nostr = js.context['nostr'];
      if (!nostr.hasProperty('nip44')) {
        throw Exception('NIP-44 not supported by this extension');
      }
      final nip44 = nostr['nip44'];
      final promise = nip44.callMethod('decrypt', [pubkey, ciphertext]);
      final decrypted = await _promiseToFuture<String>(promise);
      return decrypted;
    } catch (e) {
      throw Exception('Failed to decrypt with NIP-44: $e');
    }
  }

  // Helper to convert JS Promise to Dart Future
  static Future<T> _promiseToFuture<T>(js.JsObject promise) {
    final completer = Completer<T>();
    
    promise.callMethod('then', [
      (result) {
        completer.complete(result as T);
      }
    ]);
    
    promise.callMethod('catch', [
      (error) {
        completer.completeError(error.toString());
      }
    ]);
    
    return completer.future;
  }

  // Helper to convert JsObject to Map
  static Map<String, dynamic> _jsObjectToMap(js.JsObject jsObject) {
    final map = <String, dynamic>{};
    final keys = js.context['Object'].callMethod('keys', [jsObject]) as List;
    
    for (final key in keys) {
      final value = jsObject[key];
      if (value is js.JsObject) {
        map[key as String] = _jsObjectToMap(value);
      } else {
        map[key as String] = value;
      }
    }
    
    return map;
  }
}

