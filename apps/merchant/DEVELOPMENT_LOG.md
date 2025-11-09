# Merchant App Development Log

## Status: ✅ Running Successfully

The ZapD Merchant app is now running on `http://localhost:8080` in Chrome!

## Features Implemented

### 1. Authentication System ✅
- **Location**: `features/auth/presentation/`
- **Files**:
  - `pages/auth_page.dart` - Material Design 3 authentication UI
  - `providers/auth_provider.dart` - Riverpod state management
  
**Features**:
- Generate new Nostr key pair (placeholder - needs secp256k1)
- Import existing private key (64-char hex validation)
- Secure storage using flutter_secure_storage
- Auto-login on app restart
- Navigation to dashboard after authentication
- Material Design 3 styling with Google Fonts (Inter)

### 2. Dashboard ✅
- **Location**: `features/dashboard/presentation/pages/dashboard_page.dart`
- **Features**:
  - Welcome screen with public key display
  - Logout functionality
  - Protected route (requires authentication)
  - Material Design 3 styling

### 3. Router & Navigation ✅
- **Location**: `core/router/app_router.dart`
- **Features**:
  - go_router integration with Riverpod
  - Auth state-based redirects
  - Protected routes
  - Routes:
    - `/auth` - Authentication page
    - `/dashboard` - Main dashboard (protected)

### 4. Core App Structure ✅
- **Files**:
  - `lib/main.dart` - Entry point with ProviderScope
  - `lib/app.dart` - Root app widget with Material 3 theme
  
**Features**:
- Material Design 3 theming
- Dark/light theme support
- Google Fonts (Inter typography)
- Riverpod state management

## Tech Stack

- **Framework**: Flutter 3.9.2
- **State Management**: Riverpod 2.6.1 (without code generation)
- **Router**: go_router 14.6.2
- **Secure Storage**: flutter_secure_storage 9.2.2
- **Fonts**: google_fonts 6.2.1
- **Design**: Material Design 3
- **Local Packages**: nostr_core, zapd_models

## Known Limitations

### 1. Placeholder Key Generation
- Currently using random hex string
- **TODO**: Implement secp256k1 for proper key generation
- **TODO**: Derive public key from private key

### 2. Build Runner Compatibility
- Encountered analyzer_plugin compatibility issue with Dart 3.9.2
- **Workaround**: Manually implemented providers instead of using code generation
- **Impact**: No @riverpod annotations, using manual Provider definitions

### 3. Missing Features
- No Nostr relay connection yet
- No order management
- No menu management
- No real-time updates

## How to Run

```bash
# From project root
cd apps/merchant

# Run on Chrome
flutter run -d chrome --web-port 8080

# Or run on macOS (desktop)
flutter run -d macos

# Or run on Windows (desktop)
flutter run -d windows
```

## Next Steps

### Phase 1: Core Nostr Integration
1. **Implement secp256k1**
   - Add `flutter_rust_bridge` or use `pointycastle` for ECC
   - Generate proper Nostr key pairs
   - Derive public key from private key
   - Sign Nostr events

2. **Connect to Nostr Relays**
   - Initialize NostrClient from nostr_core
   - Connect to default relays
   - Subscribe to restaurant-specific events
   - Display connection status

### Phase 2: Restaurant Profile
3. **Create Restaurant Profile Page**
   - Restaurant name, description, location
   - Operating hours
   - Contact information
   - Profile image upload

4. **Publish Restaurant Profile**
   - Create NIP-01 event with restaurant data
   - Store restaurant ID in local storage
   - Display published profile

### Phase 3: Menu Management
5. **Create Menu Management UI**
   - Add/edit/delete menu items
   - Categories organization
   - Pricing and descriptions
   - Item images

6. **Publish Menu to Nostr**
   - Create custom events for menu items
   - Update existing items
   - Handle deletions

### Phase 4: Order Management
7. **Order Monitoring Dashboard**
   - Real-time order subscription
   - Order list with filters (new, preparing, ready, delivered)
   - Order details view
   - Status update buttons

8. **Order Processing**
   - Accept/reject orders
   - Update order status
   - NIP-44 encrypted communication with customers
   - Estimated preparation time

### Phase 5: Advanced Features
9. **Analytics Dashboard**
   - Sales statistics
   - Popular items
   - Order trends
   - Revenue tracking

10. **Notifications**
    - Desktop notifications for new orders
    - Sound alerts
    - Push notifications (mobile)

## File Structure

```
apps/merchant/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── app.dart                     # Root app widget
│   ├── core/
│   │   └── router/
│   │       └── app_router.dart      # Router configuration
│   └── features/
│       ├── auth/
│       │   └── presentation/
│       │       ├── pages/
│       │       │   └── auth_page.dart
│       │       └── providers/
│       │           └── auth_provider.dart
│       └── dashboard/
│           └── presentation/
│               └── pages/
│                   └── dashboard_page.dart
├── pubspec.yaml                     # Dependencies
└── DEVELOPMENT_LOG.md              # This file
```

## Testing

### Try the Auth Flow
1. Open `http://localhost:8080`
2. Click "Generate New Key" (generates placeholder key)
3. Should redirect to Dashboard
4. See your "public key" displayed
5. Click logout - should return to auth page
6. Try importing a key:
   - Enter 64 hex characters (e.g., `1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef`)
   - Click "Import Private Key"
   - Should redirect to dashboard

### Verify Secure Storage
1. Login with a key
2. Close browser tab
3. Reopen `http://localhost:8080`
4. Should automatically redirect to dashboard (key persisted)

## Dependencies Overview

### Production Dependencies
- `flutter_riverpod: ^2.6.1` - State management
- `go_router: ^14.6.2` - Navigation
- `flutter_secure_storage: ^9.2.2` - Secure key storage
- `google_fonts: ^6.2.1` - Inter typography
- `intl: ^0.19.0` - Internationalization
- `uuid: ^4.5.1` - UUID generation

### Dev Dependencies
- `flutter_test: sdk: flutter` - Testing
- `flutter_lints: ^5.0.0` - Linting rules

### Local Packages
- `nostr_core: path: ../../packages/nostr_core` - Nostr protocol
- `zapd_models: path: ../../packages/zapd_models` - Data models

## Notes

- Material Design 3 provides modern, accessible UI components
- Riverpod separates business logic from UI effectively
- flutter_secure_storage works across web, mobile, and desktop
- No code generation means faster iteration during development
- Authentication flow is complete but needs real cryptography
- Router automatically handles auth state changes
