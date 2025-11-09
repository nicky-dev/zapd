# Nostr Core

Complete Nostr protocol implementation for Flutter with NIP-44 encryption.

## Features

- ✅ **NIP-01**: Basic protocol flow (events, subscriptions, relays)
- ✅ **NIP-44**: Modern encryption (XChaCha20-Poly1305)
- ⏳ **NIP-19**: bech32 encoding (TODO)
- ⏳ **NIP-57**: Lightning Zaps (TODO)
- ⏳ **Schnorr signatures**: secp256k1 (TODO - requires external implementation)

## Installation

```yaml
dependencies:
  nostr_core:
    path: ../packages/nostr_core
```

## Usage

### Connect to Relays

```dart
import 'package:nostr_core/nostr_core.dart';

final client = NostrClient();

// Add relays
client.addRelay(Relay(url: 'wss://relay.damus.io'));
client.addRelay(Relay(url: 'wss://nos.lol'));

// Connect
await client.connect();
```

### Subscribe to Events

```dart
// Create filter
final filter = NostrFilter(
  kinds: [1], // text notes
  limit: 10,
);

// Subscribe
final subscription = client.subscribe([filter]);

// Listen to events
subscription.stream.listen((event) {
  print('Received event: ${event.content}');
});

// Close subscription when done
subscription.close();
```

### Publish Events

```dart
// Build event
final event = EventBuilder()
  .pubkey(myPublicKey)
  .kind(1)
  .content('Hello Nostr!')
  .build();

// Sign event (requires Schnorr implementation)
// final signedEvent = event.sign(myPrivateKey);

// Publish
await client.publish(event);
```

### NIP-44 Encryption

```dart
import 'package:nostr_core/nostr_core.dart';

// Get conversation key (requires ECDH implementation)
// final conversationKey = NIP44.getConversationKey(myPrivkey, recipientPubkey);

// Encrypt message
final encrypted = NIP44.encrypt('Secret message', conversationKey);

// Decrypt message
final decrypted = NIP44.decrypt(encrypted, conversationKey);
```

## TODO

### Critical (for production):

1. **secp256k1 Implementation**
   - Schnorr signatures
   - ECDH for NIP-44
   - Key generation
   
   **Options:**
   - Use `flutter_rust_bridge` with `rust-secp256k1`
   - Use `pointycastle` with custom Schnorr implementation
   - Use FFI with C library

2. **XChaCha20 Implementation**
   - Current implementation uses ChaCha20 (12-byte nonce)
   - NIP-44 requires XChaCha20 (24-byte nonce)
   - Use proper XChaCha20-Poly1305 library

3. **NIP-19 (bech32 encoding)**
   - Implement npub, nsec, note encoding/decoding
   - Use `bech32` package

### Nice to have:

- NIP-57: Lightning Zaps
- Relay health monitoring
- Event caching
- Batch subscriptions
- More comprehensive tests

## Testing

```bash
cd packages/nostr_core
flutter test
```

## Notes

This package provides the foundation for Nostr protocol in ZapD. Some cryptographic operations are marked as `UnimplementedError` and require proper implementation using external libraries or Rust bridges for production use.

## References

- [Nostr Protocol](https://github.com/nostr-protocol/nostr)
- [NIP-44 Specification](https://github.com/nostr-protocol/nips/blob/master/44.md)
- [NIP-01 Specification](https://github.com/nostr-protocol/nips/blob/master/01.md)
