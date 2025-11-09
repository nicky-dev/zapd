# ZapD - Decentralized Food Delivery Platform

A decentralized food delivery platform built on the Nostr protocol using Flutter.

## 🏗️ Project Structure

```
zapd/
├── apps/
│   ├── merchant/          # Merchant web/desktop app
│   ├── rider/             # Rider mobile app  
│   └── customer/          # Customer mobile app + web
│
├── packages/
│   ├── nostr_core/        # Nostr protocol implementation
│   ├── zapd_models/       # Shared data models
│   ├── zapd_ui/           # Shared UI components
│   └── zapd_services/     # Business logic & services
│
└── melos.yaml            # Monorepo configuration
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Melos CLI

### Installation

1. **Install Melos**:
   ```bash
   dart pub global activate melos
   ```

2. **Bootstrap the project**:
   ```bash
   melos bootstrap
   ```

3. **Get dependencies**:
   ```bash
   melos get
   ```

## 📦 Packages

### nostr_core
Complete Nostr protocol implementation with NIP-44 encryption.
- NIP-01: Basic protocol flow
- NIP-44: Modern encryption (XChaCha20-Poly1305)
- WebSocket relay connections
- Event signing and verification

### zapd_models
Shared data models for the platform:
- Restaurant, MenuItem, Order
- User, Location
- All models support JSON serialization

### zapd_ui
Shared UI components across all apps (coming soon).

### zapd_services
Business logic and services (coming soon).

## 🎯 Apps

### Merchant App (Web/Desktop)
Restaurant management dashboard.
```bash
melos run run:merchant
```

### Rider App (Mobile)
Delivery rider app with GPS tracking.
```bash
melos run run:rider
```

### Customer App (Mobile + Web)
Customer ordering app.
```bash
melos run run:customer
```

## 🔧 Development Commands

```bash
# Bootstrap all packages
melos bootstrap

# Run tests
melos test

# Analyze code
melos analyze

# Format code
melos format

# Clean all packages
melos clean

# Build web apps
melos build:web

# Build mobile apps (Android)
melos build:apk

# Build mobile apps (iOS)
melos build:ios
```

## 🔐 Architecture

### Nostr Protocol
- Decentralized messaging via Nostr relays
- NIP-44 encryption for sensitive data (addresses, phone numbers)
- Public events for order status tracking
- Private events for order details

### Data Flow
```
Customer → Nostr Event → Relay → Merchant
                                ↓
                              Rider
```

### Event Types
- `kind: 30000` - Restaurant profiles
- `kind: 30001` - Menu items
- `kind: 30002` - Order status (public)
- `kind: 4` - Order details (encrypted, NIP-44)
- `kind: 30003` - Rider location (encrypted)

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Protocol**: Nostr
- **Encryption**: NIP-44 (XChaCha20-Poly1305)
- **Payment**: Lightning Network
- **Monorepo**: Melos

## 📝 TODO

### Critical
- [ ] Implement secp256k1 (Schnorr signatures, ECDH)
- [ ] Implement proper XChaCha20-Poly1305
- [ ] NIP-19 bech32 encoding
- [ ] Lightning Network integration
- [ ] Create Flutter apps (merchant, rider, customer)

### Nice to have
- [ ] NIP-57 (Lightning Zaps)
- [ ] Relay health monitoring
- [ ] Event caching
- [ ] Real-time location tracking
- [ ] Push notifications

## 🤝 Contributing

This is a monorepo project. To add a new package:

1. Create package in `packages/` directory
2. Add to `melos.yaml`
3. Run `melos bootstrap`

## 📄 License

MIT

## 🔗 References

- [Nostr Protocol](https://github.com/nostr-protocol/nostr)
- [NIP-44 Specification](https://github.com/nostr-protocol/nips/blob/master/44.md)
- [Flutter](https://flutter.dev)
- [Melos](https://melos.invertase.dev)
