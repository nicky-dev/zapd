# ZapD Setup Guide

## ✅ What's Been Created

The ZapD monorepo has been initialized with the following structure:

```
zapd/
├── .github/
│   └── copilot-instructions.md    # Copilot workspace instructions
├── packages/
│   ├── nostr_core/                # ✅ Nostr protocol implementation
│   │   ├── lib/
│   │   │   ├── nostr_core.dart
│   │   │   └── src/
│   │   │       ├── client/        # WebSocket client, relay pool
│   │   │       ├── crypto/        # NIP-44 encryption, key management
│   │   │       ├── events/        # Event models, filters, builders
│   │   │       ├── nips/          # NIP implementations
│   │   │       ├── models/        # Relay, subscription models
│   │   │       └── utils/         # Helpers, constants
│   │   ├── test/                  # Unit tests
│   │   └── pubspec.yaml
│   │
│   └── zapd_models/               # ✅ Shared data models
│       ├── lib/
│       │   ├── zapd_models.dart
│       │   └── src/
│       │       ├── restaurant.dart
│       │       ├── menu_item.dart
│       │       ├── order.dart
│       │       ├── user.dart
│       │       └── location.dart
│       └── pubspec.yaml
│
├── apps/                          # ⏳ To be created with Flutter
│   ├── merchant/
│   ├── rider/
│   └── customer/
│
├── melos.yaml                     # ✅ Monorepo configuration
└── README.md                      # ✅ Project documentation
```

## 🚀 Next Steps

### 1. Install Flutter

If Flutter is not installed:

```bash
# macOS (using Homebrew)
brew install --cask flutter

# Or download from:
# https://docs.flutter.dev/get-started/install/macos
```

Verify installation:
```bash
flutter doctor
```

### 2. Install Melos

```bash
dart pub global activate melos
```

Add to PATH (if not already):
```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### 3. Create Flutter Apps

Run these commands to create the three apps:

```bash
# Merchant Web/Desktop App
flutter create --template=app --platforms=web,macos,windows \
  apps/merchant --org=com.zapd --project-name=merchant

# Rider Mobile App
flutter create --template=app --platforms=android,ios \
  apps/rider --org=com.zapd --project-name=rider

# Customer Mobile + Web App
flutter create --template=app --platforms=android,ios,web \
  apps/customer --org=com.zapd --project-name=customer
```

### 4. Update App Dependencies

After creating the apps, add the shared packages to each app's `pubspec.yaml`:

**apps/merchant/pubspec.yaml:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  nostr_core:
    path: ../../packages/nostr_core
  zapd_models:
    path: ../../packages/zapd_models
```

**apps/rider/pubspec.yaml:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  nostr_core:
    path: ../../packages/nostr_core
  zapd_models:
    path: ../../packages/zapd_models
  geolocator: ^11.0.0  # For GPS tracking
  google_maps_flutter: ^2.5.0
```

**apps/customer/pubspec.yaml:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  nostr_core:
    path: ../../packages/nostr_core
  zapd_models:
    path: ../../packages/zapd_models
  geolocator: ^11.0.0
  google_maps_flutter: ^2.5.0
```

### 5. Bootstrap the Monorepo

```bash
cd /Users/nicky-dev/workspace/zapd
melos bootstrap
```

This will:
- Link all local packages
- Get dependencies for all packages
- Generate necessary files

### 6. Run Tests

```bash
melos test
```

### 7. Run the Apps

```bash
# Merchant (Web)
melos run run:merchant

# Rider (Mobile - need emulator/device)
melos run run:rider

# Customer (Mobile - need emulator/device)
melos run run:customer
```

## 📝 Important TODOs

### Critical (Required for Production)

1. **secp256k1 Implementation**
   
   The following files have placeholder implementations:
   - `packages/nostr_core/lib/src/crypto/key_pair.dart`
   - `packages/nostr_core/lib/src/crypto/schnorr.dart`
   - `packages/nostr_core/lib/src/crypto/nip44.dart` (ECDH method)

   **Solutions:**
   
   **Option A: Flutter Rust Bridge (Recommended)**
   ```bash
   # Add to nostr_core/pubspec.yaml
   dependencies:
     flutter_rust_bridge: ^2.0.0
   
   # Create Rust bridge for secp256k1
   # Use rust-secp256k1 crate
   ```

   **Option B: Pure Dart (Not recommended)**
   - Use pointycastle with custom Schnorr implementation
   - More complex, less tested

2. **XChaCha20-Poly1305**
   
   Current implementation uses ChaCha20 (12-byte nonce).
   NIP-44 requires XChaCha20 (24-byte nonce).
   
   **Solution:**
   - Implement XChaCha20 extension
   - Or use FFI to libsodium

3. **Lightning Network Integration**
   
   For payments (NIP-57):
   ```yaml
   dependencies:
     # Research Flutter Lightning libraries
     # May need to use REST API to Lightning node
   ```

### Nice to Have

- Implement NIP-19 (bech32 encoding)
- Add relay health monitoring
- Event caching layer
- Push notifications
- State management (Riverpod/Bloc)

## 🧪 Testing

Each package has unit tests. Critical areas:

1. **nostr_core tests:**
   ```bash
   cd packages/nostr_core
   flutter test
   ```

2. **NIP-44 encryption tests:**
   - Test vectors from NIP-44 spec
   - Interoperability with other Nostr clients

3. **Integration tests:**
   - Test against real Nostr relays
   - End-to-end order flow

## 📚 Resources

- [Nostr Protocol](https://github.com/nostr-protocol/nostr)
- [NIP-44 Spec](https://github.com/nostr-protocol/nips/blob/master/44.md)
- [Flutter Docs](https://docs.flutter.dev)
- [Melos Docs](https://melos.invertase.dev)
- [Flutter Rust Bridge](https://cjycode.com/flutter_rust_bridge/)

## 🤝 Development Workflow

1. Make changes in packages or apps
2. Run `melos bootstrap` if dependencies change
3. Run `melos analyze` before committing
4. Run `melos test` to verify changes
5. Use `melos clean` if you encounter issues

## ⚠️ Known Issues

1. **Schnorr signatures not implemented** - Events cannot be signed yet
2. **ECDH not implemented** - NIP-44 encryption incomplete
3. **XChaCha20 uses ChaCha20** - Wrong nonce size
4. **Flutter not installed** - Cannot create apps yet

## 📞 Support

For questions about:
- Nostr protocol: Check NIPs documentation
- Flutter: Check Flutter documentation
- ZapD architecture: See .github/copilot-instructions.md
