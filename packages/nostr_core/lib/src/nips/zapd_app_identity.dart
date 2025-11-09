import 'nip89_models.dart';

/// ZapD App Identity - FIXED app keypair and metadata
///
/// This is the official identity of the ZapD Merchant app on Nostr.
/// The private key is included here for signing the NIP-89 metadata event.
///
/// ⚠️  SECURITY NOTE: This is for app identification only, NOT for user data!
/// User data is encrypted with NIP-46 ephemeral keys and bunker signatures.
class ZapdAppIdentity {
  /// ZapD Merchant App Public Key (FIXED)
  /// This identifies our app across all Nostr relays
  static const String appPubkey = 
      'ad60e6290106e7fecb63e1275094e0dfdd2abb12c2ae8c4391c30d0cd6d11cef';
  
  /// ZapD Merchant App Private Key (FIXED)
  /// Used ONLY to sign the NIP-89 app metadata event
  /// ⚠️  This is NOT a secret - it's for app identification only
  static const String appPrivkey = 
      '7b485be6f04a904fcd3013350b1d08c06f68346764ad815d8cce4c8009d5e3af';
  
  /// App metadata identifier (FIXED timestamp)
  static const String identifier = '1762665108099'; // When we generated the keypair
  
  /// Get app reference for NIP-89 client tags
  static Nip89AppReference get appReference => Nip89AppReference(
        pubkey: appPubkey,
        identifier: identifier,
        name: 'ZapD Merchant',
      );
  
  /// Get app metadata for NIP-89 event
  static Nip89AppMetadata get appMetadata => const Nip89AppMetadata(
        name: 'ZapD Merchant',
        displayName: 'ZapD - Restaurant Management',
        about: 'ZapD decentralized food delivery platform - Restaurant management app',
        picture: 'https://zapd.io/icon-merchant.png',
        platforms: ['web', 'macos', 'windows'],
      );
  
  /// ✅ NIP-89 Event Published!
  /// 
  /// Event ID: 2fbf90d9fb4baa507d3f763ea06388b312149f13be48bf844fb95a7d3d9b03a7
  /// Published to:
  /// - ✅ wss://relay.damus.io
  /// - ✅ wss://nos.lol
  /// 
  /// Client Tag: ['client', 'ZapD Merchant', '31990:ad60e6290106e7fecb63e1275094e0dfdd2abb12c2ae8c4391c30d0cd6d11cef:1762665108099']
}
