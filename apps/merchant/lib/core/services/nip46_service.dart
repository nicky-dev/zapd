import 'package:ndk/ndk.dart' as ndk;
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html show window;
import '../storage/nip46_session_storage.dart';

/// Service for NIP-46 (Nostr Connect) remote signing using NDK
///
/// Provides simple API for merchant app to use NIP-46 protocol
class Nip46Service {
  static ndk.Ndk? _ndk;
  static ndk.BunkerConnection? _bunkerConnection;
  static ndk.EventSigner? _signer; // Use EventSigner interface instead

  /// Initialize NDK instance with minimal relays
  static Future<void> _ensureNdk() async {
    if (_ndk == null) {
      _ndk = ndk.Ndk(
        ndk.NdkConfig(
          eventVerifier: ndk.Bip340EventVerifier(),
          cache: ndk.MemCacheManager(), // In-memory cache
          // Only use relay from bunker URL - NDK will extract it
          bootstrapRelays: [], // Empty - bunker URL has relay info
        ),
      );
    }
  }

  /// Open auth URL based on platform
  /// - Web: Open in popup window
  /// - Mobile: Try to open as deep link (nostrconnect://)
  static void _openAuthUrl(String authUrl) {
  debugPrint('[NIP-46] Opening auth URL: $authUrl');
    
    if (kIsWeb) {
      // Web: Open in popup
      final width = 500;
      final height = 600;
      final left = (html.window.screen!.width! - width) ~/ 2;
      final top = (html.window.screen!.height! - height) ~/ 2;
      
      html.window.open(
        authUrl,
        'NIP-46 Authorization',
        'width=$width,height=$height,left=$left,top=$top,menubar=no,toolbar=no,location=no',
      );
      debugPrint('[NIP-46] Opened popup window');
    } else {
      // Mobile: Open as deep link or in browser
      launchUrl(
        Uri.parse(authUrl),
        mode: LaunchMode.externalApplication,
      ).then((success) {
        if (success) {
          debugPrint('[NIP-46] Opened URL in external app');
        } else {
          debugPrint('[NIP-46] Failed to open URL');
        }
      }).catchError((e) {
        debugPrint('[NIP-46] Error opening URL: $e');
      });
    }
  }

  /// Connect to remote signer using bunker URL
  ///
  /// Returns bunker connection that can be used for signing
  static Future<ndk.BunkerConnection> connect(
    String bunkerUrl, {
    Function(String authUrl)? onAuthRequired,
  }) async {
    await _ensureNdk();

    // Parse bunker URL to show details
    final uri = Uri.parse(bunkerUrl);
    final remotePubkey = uri.host;
    final relays = uri.queryParametersAll['relay'] ?? [];
    final hasSecret = uri.queryParameters['secret']?.isNotEmpty ?? false;

  debugPrint('[NIP-46] Connecting with NDK...');
  debugPrint('  Bunker URL: $bunkerUrl');
  debugPrint('  Remote Pubkey: $remotePubkey');
  debugPrint('  Relays: ${relays.join(", ")}');
  debugPrint('  Has Secret: $hasSecret');
  debugPrint('  If no response: Check https://nsec.app for approval!');
  debugPrint('');

    try {
      // Connect using NDK's Bunkers
      // NDK extracts relay URL from bunker:// URL automatically
  debugPrint('[NIP-46] Sending connect request...');
      final connection = await _ndk!.bunkers.connectWithBunkerUrl(
        bunkerUrl,
        authCallback: (authUrl) {
          debugPrint('[NIP-46] AUTH REQUIRED: $authUrl');
          
          // Open auth URL based on platform
          _openAuthUrl(authUrl);
          
          if (onAuthRequired != null) {
            onAuthRequired(authUrl);
          }
        },
      );

      if (connection == null) {
        throw Exception('Failed to connect to bunker - connection returned null');
      }

  debugPrint('[NIP-46] Connected successfully!');
  debugPrint('  Remote pubkey: ${connection.remotePubkey}');

      // Create signer
      _signer = _ndk!.bunkers.createSigner(
        connection,
        authCallback: onAuthRequired,
      );

      _bunkerConnection = connection;

      // Note: Session storage with Nip46Session requires BunkerConnection
      // and ephemeral keys which are managed by NDK internally.
      // For simplicity, we rely on the auth provider to store the public key.
      
      return connection;
    } catch (e, stackTrace) {
  debugPrint('[NIP-46] Connection failed: $e');
  debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Try to restore previous session
  ///
  /// Returns true if session was restored successfully
  static Future<bool> tryRestoreSession() async {
    try {
      final session = await Nip46SessionStorage.loadSession();
      if (session == null) {
        return false;
      }

      // Session restoration with NIP-46 requires full reconnection flow
      // because ephemeral keys and connection state are not easily serializable
      // User needs to scan QR code or paste bunker URL again
      debugPrint('[NIP-46] Previous session found but requires reconnection');
      if (session.remotePublicKey != null) {
        debugPrint('[NIP-46] Last connected to: ${session.remotePublicKey}');
      }
      return false;
    } catch (e) {
      debugPrint('[NIP-46] Session check failed: $e');
      return false;
    }
  }

  /// Get public key from remote signer
  static Future<String> getPublicKey() async {
    if (_bunkerConnection == null) {
      throw StateError('Not connected. Call connect() first.');
    }

    return _bunkerConnection!.remotePubkey;
  }

  /// Sign event using remote signer
  static Future<ndk.Nip01Event> signEvent(ndk.Nip01Event unsignedEvent) async {
    if (_signer == null) {
      throw StateError('Not connected. Call connect() first.');
    }

    // Use NDK signer to sign the event (mutates event in-place)
    await _signer!.sign(unsignedEvent);
    return unsignedEvent; // Return the now-signed event
  }

  /// Disconnect from remote signer and clear session
  static Future<void> disconnect() async {
    // NDK manages connections internally
    _bunkerConnection = null;
    _signer = null;
    await Nip46SessionStorage.deleteSession();
  }

  /// Check if currently connected
  static bool get isConnected => _bunkerConnection != null && _signer != null;
}
