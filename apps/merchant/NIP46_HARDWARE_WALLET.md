# NIP-46: Nostr Connect

## Overview
NIP-46 defines a protocol for **remote signing** of Nostr events. This allows you to keep your private key on a separate device (bunker/signer) while signing events from your main application.

## How It Works

```
┌─────────────┐         ┌──────────────┐         ┌────────────┐
│   Client    │◄───────►│    Relay     │◄───────►│   Bunker   │
│ (Merchant)  │         │   (Nostr)    │         │  (Signer)  │
└─────────────┘         └──────────────┘         └────────────┘
      │                                                  │
      │  1. Request signature                            │
      ├──────────────────────────────────────────────────►
      │                                                  │
      │  2. Approve/Deny on bunker device              │
      │  3. Sign event                                 │
      │◄──────────────────────────────────────────────────
      │  4. Return signed event                         │
```

## Supported Implementations

### 1. **nsecBunker**
- Dedicated remote signer
- Can run on a separate device/server
- URL format: `bunker://<pubkey>?relay=wss://relay.example.com`
- Open source: https://github.com/kind-0/nsecbunkerd

### 2. **Amber (Android)**
- Android app that acts as a signer
- Keeps keys secure on your phone
- Apps request signing through Nostr protocol
- https://github.com/greenart7c3/Amber

### 3. **Nsec.app**
- Web-based remote signer
- Can be self-hosted
- Works with any Nostr client
- https://nsec.app

### 4. **Hardware Wallets** ⚠️ (Experimental)

NIP-46 can theoretically work with hardware wallets, but it requires:

#### Option A: Custom Firmware
- Modify hardware wallet firmware to support Nostr signing
- Examples:
  - Ledger with custom app
  - Trezor with custom firmware
  - DIY hardware signer (Raspberry Pi + Secure Element)

#### Option B: Bridge Software
- Software that bridges between NIP-46 and hardware wallet APIs
- Example flow:
  ```
  Client → NIP-46 → Bridge → Hardware Wallet (BLE/USB) → Bridge → NIP-46 → Client
  ```
- Bridge handles:
  - NIP-46 protocol
  - Hardware wallet communication (USB/Bluetooth)
  - User confirmation on device

#### Current Reality (Nov 2025)
- **No native support yet** in major hardware wallets (Ledger, Trezor)
- **DIY solutions exist** using:
  - Raspberry Pi Zero W + Secure Element
  - Custom ESP32-based signers
  - Modified Ledger apps (unofficial)

#### Future Possibilities
- Hardware wallet vendors may add Nostr signing support
- Community may create Nostr-specific hardware signers
- Similar to how hardware wallets support multiple cryptocurrencies

## Why Use NIP-46?

### Security Benefits
1. **Private Key Never Leaves Bunker**
   - Your key stays on a dedicated device
   - Main app never has access to key

2. **Manual Approval**
   - Each signature can require manual approval
   - Prevents unauthorized signing

3. **Multi-Device Support**
   - One bunker serves multiple apps
   - Consistent identity across devices

4. **Revocable Access**
   - Can disconnect apps from bunker
   - No need to rotate keys

### Use Cases
- **Merchants**: Sign orders/events from web/desktop, key stays on phone
- **Power Users**: Central key management for multiple Nostr apps
- **Organizations**: Shared signing service for team
- **High Security**: Air-gapped signing device

## Setup Example

### Using nsecBunker

1. **Run Bunker**
   ```bash
   docker run -d \
     -v /path/to/keys:/keys \
     -e RELAY=wss://relay.damus.io \
     kind0/nsecbunkerd
   ```

2. **Get Bunker URL**
   ```
   bunker://npub1abc...xyz?relay=wss://relay.damus.io
   ```

3. **Connect in ZapD**
   - Go to Login → Nostr Connect
   - Paste bunker URL
   - Approve connection on bunker device

## Implementation in ZapD

Currently, ZapD Merchant app has the UI for NIP-46, but the actual protocol implementation requires:

1. **Establish Connection**
   - Parse bunker URL
   - Connect to specified relay
   - Send connection request

2. **Request Signature**
   - Create unsigned event
   - Send to bunker via encrypted DM
   - Wait for response

3. **Handle Response**
   - Receive signed event
   - Validate signature
   - Use signed event

This is planned for future development after NIP-07 is fully working.

## References
- NIP-46 Spec: https://github.com/nostr-protocol/nips/blob/master/46.md
- nsecBunker: https://github.com/kind-0/nsecbunkerd
- Amber: https://github.com/greenart7c3/Amber
- Nostr Hardware Wallet Discussion: https://github.com/nostr-protocol/nips/issues/123
