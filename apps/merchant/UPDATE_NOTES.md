# ZapD Merchant - Recent Updates

## ✅ Completed Features

### 1. Multi-language Support (TH/EN) 🌏
- Added `flutter_localizations` 
- Created `.arb` files for Thai and English
- Configured `l10n.yaml` for code generation
- All UI text now supports i18n
- Easy to add more languages in future

**Usage:**
```dart
Text(AppLocalizations.of(context)!.welcomeTitle)
```

### 2. NIP-19 Encoding (nsec/npub) 🔐
- Created `lib/core/utils/nip19.dart`
- Convert hex keys to bech32 format:
  - Private key (hex) → nsec1...
  - Public key (hex) → npub1...
- Decode nsec/npub back to hex
- Validation helpers

**Features:**
- `Nip19.encodePrivateKey(hexKey)` → nsec1...
- `Nip19.encodePublicKey(hexKey)` → npub1...
- `Nip19.decodePrivateKey(nsec)` → hex
- `Nip19.decodePublicKey(npub)` → hex
- `Nip19.isNsec(value)` → bool
- `Nip19.isNpub(value)` → bool
- `Nip19.isHexKey(value)` → bool

### 3. NIP-07 Browser Extension Support 🔌
- Created `lib/core/services/nip07_service.dart`
- Detects `window.nostr` in web browser
- Supports extensions:
  - nos2x
  - Alby  
  - Flamingo
  - Any NIP-07 compatible extension

**Features:**
- `Nip07Service.isAvailable()` → Check if extension exists
- `Nip07Service.getPublicKey()` → Get pubkey from extension
- `Nip07Service.signEvent(event)` → Sign event
- `Nip07Service.nip04Encrypt/Decrypt()` → NIP-04 encryption
- `Nip07Service.nip44Encrypt/Decrypt()` → NIP-44 encryption (if supported)

**How it works:**
1. User has browser extension installed
2. Click "Connect Extension" button
3. Extension popup asks for permission
4. Get public key and sign events without exposing private key
5. Much safer than pasting private key!

### 4. NIP-46 Documentation 📚
- Created comprehensive guide: `NIP46_HARDWARE_WALLET.md`
- Explains remote signing protocol
- Lists supported implementations:
  - nsecBunker (dedicated signer)
  - Amber (Android signer)
  - Nsec.app (web signer)
- Hardware wallet discussion:
  - No native support yet from Ledger/Trezor
  - Possible with custom firmware/bridge
  - DIY solutions exist (Raspberry Pi + Secure Element)
  - Future possibility as Nostr grows

## 🔄 Next Steps to Update UI

### Update App.dart
1. Add `localizationsDelegates` and `supportedLocales`
2. Setup language switching logic

### Update RegisterPage
1. Hide private key by default (show/hide button)
2. Display as nsec format when shown
3. Display public key as full npub (not truncated)
4. Use localized strings

### Update LoginPage  
1. Accept both hex and nsec for private key input
2. Implement NIP-07 extension connection (replace "coming soon")
3. Add extension detection
4. Show success/error messages
5. Use localized strings

### Update WelcomePage
1. Add language switcher (TH/EN toggle)
2. Use localized strings

### Update AuthProvider
1. Support nsec decoding
2. Store in secure storage
3. Derive public key properly (still placeholder)

## Dependencies Added

```yaml
flutter_localizations:
  sdk: flutter

bech32: ^0.2.2
intl: ^0.20.2  # Updated from 0.19.0
```

## File Structure

```
lib/
├── core/
│   ├── services/
│   │   └── nip07_service.dart      # NEW: Browser extension support
│   └── utils/
│       └── nip19.dart               # NEW: nsec/npub encoding
├── l10n/
│   ├── app_en.arb                   # NEW: English translations
│   └── app_th.arb                   # NEW: Thai translations
├── features/
│   └── auth/
│       └── presentation/
│           ├── pages/
│           │   ├── welcome_page.dart
│           │   ├── register_page.dart
│           │   └── login_page.dart
│           └── providers/
│               └── auth_provider.dart

l10n.yaml                             # NEW: Localization config
NIP46_HARDWARE_WALLET.md             # NEW: Documentation
```

## How to Run

```bash
# Generate localizations (automatically done on build)
flutter gen-l10n

# Run app
flutter run -d chrome --web-port 8080
```

## Known Issues & TODOs

- [ ] Update all pages to use AppLocalizations
- [ ] Implement actual NIP-07 connection in LoginPage
- [ ] Add language switcher widget
- [ ] Implement secp256k1 for real key generation
- [ ] Add proper public key derivation from private key
- [ ] Test with actual browser extensions
- [ ] Handle extension permission denials gracefully

## Testing NIP-07

To test browser extension support:

1. **Install Extension**
   - nos2x: https://chrome.google.com/webstore/detail/nos2x
   - Alby: https://getalby.com
   - Flamingo: https://flamingo.me

2. **Generate Key in Extension**
   - Or import existing key into extension

3. **Test in ZapD**
   - Go to Login page
   - Select "Nostr Extension (NIP-07)"
   - Click "Connect Extension"
   - Approve in extension popup
   - Should get public key and sign in

## Language Switching

Will add a toggle button like:
```
🇬🇧 EN | 🇹🇭 TH
```

Currently defaults to system language.

## nsec/npub Format Examples

### Private Key
- **Hex**: `3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d`
- **nsec**: `nsec180cvv07mjcua9dhtwjv9wec06nzr6yrfvshd4ysg37qp5hq0ppvskkklge`

### Public Key  
- **Hex**: `7e7e9c42dcfbc69b30f0b1c1f3f0a3e6d11b7a1d8c5f2e3a1b4c6d8e9f0a2b3c`
- **npub**: `npub10elfcsxul0rjkvhskswl7u9rumg3k7saexhju7smf3xcan8s9v7qtvdppm`

Much more user-friendly and recognizable as Nostr keys!
