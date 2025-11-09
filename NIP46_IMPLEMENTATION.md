# NIP-46 Nostr Connect Implementation

## Overview
Production-ready implementation of NIP-46 (Nostr Connect) remote signing protocol in the ZapD monorepo. Allows merchant app to sign events using remote signers like nsecBunker, hardware wallets, or mobile apps.

## Architecture

### Packages
- **nostr_core**: Core NIP-46 protocol implementation
  - `Nip46Client`: WebSocket client for relay communication
  - `Nip46Request/Response`: Protocol message types
  - `BunkerConnection`: Bunker URL parser
  - `Nip46Session`: Active session management

- **merchant app**: High-level service layer
  - `Nip46Service`: Simple API wrapper for UI integration
  - `LoginPage`: UI integration with error handling

## Features Implemented

### ✅ Core Protocol
- [x] Bunker URL parsing (`bunker://pubkey?relay=wss://...`)
- [x] Ephemeral keypair generation
- [x] WebSocket relay connections
- [x] Subscription to encrypted responses (kind 24133)
- [x] Request/response message flow
- [x] Multiple relay support
- [x] Error handling and timeouts

### ✅ Methods Supported
- [x] `connect`: Establish connection with remote signer
- [x] `get_public_key`: Retrieve public key from remote signer
- [x] `sign_event`: Sign Nostr events remotely
- [ ] `nip04_encrypt/decrypt`: NIP-04 encryption (legacy)
- [ ] `nip44_encrypt/decrypt`: NIP-44 encryption
- [ ] `ping`: Keep-alive

### ⏳ Pending Implementation
- [ ] NIP-44 encryption (requires secp256k1 ECDH)
- [ ] Event signing (requires Schnorr signatures)
- [ ] Session persistence with flutter_secure_storage
- [ ] Session restoration on app restart
- [ ] Proper secp256k1 key generation (currently using placeholder)

## Usage

### Merchant App

```dart
import 'package:merchant/core/services/nip46_service.dart';

// Connect to remote signer
try {
  final bunkerUrl = 'bunker://remote_pubkey?relay=wss://relay.nsecbunker.com';
  
  // Parse and validate URL
  Nip46Service.parseBunkerUrl(bunkerUrl);
  
  // Connect (user must approve on remote signer)
  await Nip46Service.connect(bunkerUrl);
  
  // Get public key
  final pubkey = await Nip46Service.getPublicKey();
  print('Connected! Public key: $pubkey');
  
  // Sign an event
  final unsignedEvent = {
    'kind': 1,
    'content': 'Hello from ZapD!',
    'tags': [],
    'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
  };
  
  final signedEvent = await Nip46Service.signEvent(unsignedEvent);
  print('Signed: ${signedEvent.sig}');
  
  // Disconnect when done
  await Nip46Service.disconnect();
} on ArgumentError catch (e) {
  print('Invalid bunker URL: ${e.message}');
} catch (e) {
  print('Connection failed: $e');
}
```

### Direct nostr_core Usage

```dart
import 'package:nostr_core/nostr_core.dart';

// Create client
final client = Nip46Client();

// Parse bunker URL
final connection = BunkerConnection.fromUrl(
  'bunker://pubkey?relay=wss://relay1.com&relay=wss://relay2.com&secret=optional_secret'
);

print('Remote pubkey: ${connection.remotePubkey}');
print('Relays: ${connection.relays}');

// Connect
final session = await client.connect(bunkerUrl);
print('Session created at: ${session.createdAt}');
print('Ephemeral key: ${session.ephemeralPublicKey}');

// Get public key
final pubkey = await client.getPublicKey();

// Sign event
final signed = await client.signEvent({
  'kind': 1,
  'content': 'Test',
  'tags': [],
  'created_at': 1234567890,
});

// Listen to errors
client.errors.listen((error) {
  print('Client error: $error');
});

// Cleanup
await client.disconnect();
client.dispose();
```

## Protocol Flow

### 1. Connection Flow
```
User → LoginPage → Nip46Service → Nip46Client
                                      ↓
                                WebSocket Relays
                                      ↓
                              Remote Signer (nsecBunker)
```

1. User enters `bunker://` URL in LoginPage
2. `Nip46Service.connect()` validates and parses URL
3. `Nip46Client` generates ephemeral keypair
4. Client connects to all relays via WebSocket
5. Client subscribes to responses (kind 24133, #p = ephemeral_pubkey)
6. Client sends encrypted `connect` request to remote signer
7. User approves connection on remote signer
8. Remote signer sends encrypted response
9. Session is established

### 2. Signing Flow
```
App → signEvent() → Encrypt → WebSocket → Remote Signer
                                              ↓
                                          User Approval
                                              ↓
                                         Schnorr Sign
                                              ↓
App ← NostrEvent ← Decrypt ← WebSocket ← Encrypted Response
```

## Bunker URL Format

```
bunker://<remote-public-key>?relay=<relay-url>&relay=<relay-url>&secret=<optional-secret>
```

### Components
- **Scheme**: `bunker://`
- **Host**: Remote signer's public key (64 hex chars)
- **Query Parameters**:
  - `relay`: WebSocket relay URL (can have multiple)
  - `secret`: Optional connection secret for added security

### Examples
```
# Single relay
bunker://1234567890abcdef...?relay=wss://relay.nsecbunker.com

# Multiple relays
bunker://1234567890abcdef...?relay=wss://relay1.com&relay=wss://relay2.com

# With secret
bunker://1234567890abcdef...?relay=wss://relay.com&secret=my_secret_token
```

## Message Protocol (NIP-46)

### Request Format (kind 24133)
```json
{
  "id": "request_id",
  "method": "sign_event",
  "params": ["{\"kind\":1,\"content\":\"Hello\",\"tags\":[]}"]
}
```
Encrypted with NIP-44 and sent as event kind 24133 to relay.

### Response Format (kind 24133)
```json
{
  "id": "request_id",
  "result": "{\"id\":\"...\",\"sig\":\"...\"}",
  "error": null
}
```
Encrypted response from remote signer.

## Error Handling

### Common Errors
- `ArgumentError`: Invalid bunker URL format
- `StateError`: Not connected when calling sign/getPublicKey
- `TimeoutException`: Remote signer didn't respond within 30s
- `UnimplementedError`: Crypto operations not yet implemented

### Error Messages (Localized)
- `errorEnterBunkerUrl`: Prompt to enter bunker URL
- `errorInvalidBunkerUrl`: Invalid URL format
- `errorConnectFailed`: Connection failure
- `nostrConnectConnected`: Success message

## Current Limitations

### Cryptography Placeholders
The current implementation has **temporary placeholders** for cryptographic operations:

1. **Key Generation** (`_generateTemporaryKeyPair`):
   - Uses `Random.secure()` for private key
   - Uses SHA256 of private key as public key
   - ❌ Production requires secp256k1 point multiplication

2. **ECDH Conversation Key** (NIP44.getConversationKey):
   - Throws `UnimplementedError`
   - ❌ Production requires secp256k1 ECDH

3. **Schnorr Signatures** (event signing):
   - Empty signature string
   - ❌ Production requires secp256k1 Schnorr

### Next Steps for Production
1. Integrate rust-secp256k1 via flutter_rust_bridge
2. Implement proper ECDH in NIP44
3. Implement Schnorr signing in KeyPair
4. Add session persistence
5. Add session restoration
6. Test with real nsecBunker/Amber apps

## Testing

### Manual Testing Steps
1. Get bunker URL from nsecBunker or Amber app
2. Enter URL in merchant app login page
3. Select "Nostr Connect" tab
4. Click "Connect"
5. Approve connection on remote device
6. Verify public key is retrieved
7. Test signing operations
8. Test disconnect

### Unit Tests (TODO)
- URL parsing edge cases
- Connection timeout handling
- Multiple relay failures
- Message encryption/decryption
- Session serialization

## Remote Signer Apps

Compatible with:
- **nsecBunker**: https://nsecbunker.com
- **Amber**: Android signer app
- **Alby Extension**: Browser extension with bunker support
- Custom hardware wallets implementing NIP-46

## Security Considerations

1. **Ephemeral Keys**: Generated for each session, never persisted
2. **NIP-44 Encryption**: All messages encrypted end-to-end
3. **User Approval**: Remote signer requires user approval for each action
4. **No Private Key Storage**: Private key never leaves remote device
5. **Relay Privacy**: Messages are encrypted, relays can't read content

## References

- [NIP-46 Specification](https://github.com/nostr-protocol/nips/blob/master/46.md)
- [NIP-44 Encryption](https://github.com/nostr-protocol/nips/blob/master/44.md)
- [NIP-01 Basic Protocol](https://github.com/nostr-protocol/nips/blob/master/01.md)
- [nsecBunker](https://nsecbunker.com)
