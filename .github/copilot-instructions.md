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

## NIP-XX: Food Delivery Extension (added)

The repository now includes a specification draft for NIP-XX, a Food Delivery extension built on top of NIP-15 (Marketplace).

Summary (copied from `NIP-XX-FOOD-DELIVERY.md`):

- Purpose: Extend marketplace events and flows to support food delivery specifics such as order lifecycle, delivery zones, rider assignment, and privacy for addresses.
- New stall and product tags: `stall_type`, `cuisine`, `accepts_orders`, `preparation_time`, `operating_hours`, `location_encrypted`, `delivery_zone`, `min_order`, `delivery_fee`, `category`, `spicy_level`, `available`, `daily_limit`, `customization`.
- Orders: Public status events use kind `30078` (parameterized replaceable) with statuses (pending, accepted, preparing, ready, delivering, completed, cancelled). Private order details use kind `14` with NIP-44 encryption.
- Rider assignment and delivery coordination are handled via encrypted DMs (kind `14`) between merchant and rider.
- Subscriptions:
  - Merchant: subscribe to kinds `[14, 30078]` with `#p` merchant pubkey filter.
  - Customer: subscribe to kind `30078` by author and `#d` order id.
  - Rider: subscribe to kind `14` with `#p` rider pubkey.
- Payments: integrate NIP-57 Lightning invoices and require verification of preimage before accepting orders.
- Privacy: public delivery zones via geohash, exact addresses encrypted via NIP-44.

Where to find it:
- `NIP-XX-FOOD-DELIVERY.md` at repository root — contains full spec, examples, and implementation notes.

Repository context update
- Apps: `apps/merchant`, `apps/customer`, `apps/rider` (Flutter).
- Packages: `packages/nostr_core`, `packages/zapd_models`, `packages/zapd_ui`, `packages/zapd_services`.
- Notes: The merchant app includes a reference implementation for stall, product, order management and uses NIP-44 encryption for private payloads. The NIP-XX spec is intended to guide further development across these apps and packages.

Please review `NIP-XX-FOOD-DELIVERY.md` for details and link the spec to any PRs that implement the described behaviors.
