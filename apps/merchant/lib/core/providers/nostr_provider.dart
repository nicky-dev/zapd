import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostr_core/nostr_core.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Default Nostr relays for ZapD
const defaultRelays = [
  'wss://relay.damus.io',
  'wss://relay.nostr.band',
  'wss://nos.lol',
  'wss://relay.snort.social',
];

/// Provider for NostrClient instance

final nostrClientProvider = Provider<NostrClient>((ref) {
  final client = NostrClient();

  // Allow disabling relay connections at compile/run time to aid local dev
  // and crash isolation. Set via: `--dart-define=DISABLE_RELAY=true` when
  // running (or CI) to skip adding/connect.
  const disableRelays = bool.fromEnvironment('DISABLE_RELAY', defaultValue: false);

  if (!disableRelays) {
    // Add default relays
    for (final relayUrl in defaultRelays) {
      client.addRelay(Relay(url: relayUrl));
    }

    // Auto-connect
    client.connect();
  } else {
    if (kDebugMode) {
      // Use debugPrint to avoid analyzer 'avoid_print' lint in debug builds.
      debugPrint('[nostr] Relay connections are disabled (DISABLE_RELAY=true)');
    }
  }

  // Cleanup on dispose
  ref.onDispose(() {
    client.disconnect();
    client.dispose();
  });

  return client;
});

/// Provider for current user's public key
final currentUserPubkeyProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.when(
    data: (state) => state.publicKey,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider for current user's private key (use with caution)
final currentUserPrivateKeyProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.when(
    data: (state) => state.privateKey,
    loading: () => null,
    error: (_, __) => null,
  );
});
