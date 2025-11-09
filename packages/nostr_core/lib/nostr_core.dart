/// Nostr Core Library
///
/// Complete implementation of Nostr protocol with focus on:
/// - NIP-01: Basic protocol flow
/// - NIP-04: Deprecated encryption (for reference)
/// - NIP-44: Modern encryption (XChaCha20-Poly1305)
/// - NIP-19: bech32 encoding
/// - NIP-57: Lightning Zaps
library nostr_core;

// Client
export 'src/client/nostr_client.dart';
export 'src/client/relay_pool.dart';

// Crypto
export 'src/crypto/nip04.dart';
export 'src/crypto/nip44.dart';
export 'src/crypto/key_pair.dart';
export 'src/crypto/schnorr.dart';

// Events
export 'src/events/event.dart';
export 'src/events/filter.dart';
export 'src/events/event_builder.dart';

// NIPs
export 'src/nips/nip01.dart';
export 'src/nips/nip19.dart';
export 'src/nips/nip44.dart';
export 'src/nips/nip46_models.dart';
export 'src/nips/nip46_client.dart';
export 'src/nips/nip89_models.dart';
export 'src/nips/zapd_app_identity.dart';

// Models
export 'src/models/relay.dart';
export 'src/models/subscription.dart';

// Utilities
export 'src/utils/constants.dart';
export 'src/utils/helpers.dart';
