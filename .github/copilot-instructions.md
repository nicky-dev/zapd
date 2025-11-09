# ZapD Flutter Monorepo - Copilot Instructions

## Project Overview
ZapD is a decentralized food delivery platform built on the Nostr protocol using Flutter for cross-platform development.

## Architecture
- **Monorepo Structure**: Managed with Melos
- **Apps**:
  - `merchant`: Flutter Web/Desktop for restaurant management
  - `rider`: Flutter Mobile for delivery riders
  - `customer`: Flutter Mobile + Web for customers
- **Packages**:
  - `nostr_core`: Nostr protocol implementation with NIP-44 encryption
  - `zapd_models`: Shared data models
  - `zapd_ui`: Shared UI components
  - `zapd_services`: Business logic and services

## Tech Stack
- **Language**: Dart
- **Framework**: Flutter
- **Protocol**: Nostr (decentralized messaging)
- **Encryption**: NIP-44 (XChaCha20-Poly1305)
- **Payment**: Lightning Network
- **Monorepo**: Melos

## Development Guidelines

### Code Style
- Use Dart effective dart guidelines
- Follow Flutter best practices
- Prefer immutable data structures
- Use dependency injection

### Nostr Implementation
- Implement NIPs (Nostr Implementation Possibilities) correctly
- NIP-01: Basic protocol
- NIP-04: Deprecated encryption (for reference only)
- NIP-44: Modern encryption (primary focus)
- NIP-57: Lightning Zaps for payments
- NIP-19: bech32 encoding for keys

### Privacy & Security
- All sensitive data (addresses, phone numbers, payment info) must use NIP-44 encryption
- Public events for order status tracking
- Private events for order details
- Implement proper key management

### Package Dependencies
- `pointycastle`: Cryptography (ECC, XChaCha20-Poly1305)
- `crypto`: Hashing (SHA256, HMAC)
- `web_socket_channel`: WebSocket connections
- `convert`, `hex`: Encoding/decoding
- `bech32`: NIP-19 encoding

## Coding Patterns

### Nostr Events
```dart
// Public order status
kind: 30078 (custom)
tags: [["d", "order_id"], ["status", "preparing"]]
content: "" (no sensitive data)

// Private order details
kind: 4 (encrypted DM)
content: NIP44.encrypt(orderDetails, conversationKey)
```

### State Management
- Use appropriate state management (Provider, Riverpod, or Bloc)
- Keep business logic separate from UI

### Testing
- Write unit tests for nostr_core
- Test encryption/decryption thoroughly
- Integration tests for critical flows

## Project Commands

### Melos Commands
- `melos bootstrap`: Link all packages
- `melos clean`: Clean all packages
- `melos run test`: Run all tests
- `melos run analyze`: Analyze all packages

### Development
- Run specific app: `cd apps/customer && flutter run`
- Test package: `cd packages/nostr_core && flutter test`

## Important Notes
- This is a decentralized app - no central server for core functionality
- Relay infrastructure is critical for message delivery
- Lightning Network for instant payments
- Focus on privacy using NIP-44 encryption
