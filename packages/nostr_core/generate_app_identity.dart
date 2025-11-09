import 'package:nostr_core/nostr_core.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Script to generate ZapD app keypair and publish NIP-89 metadata
///
/// Run this ONCE to create the official ZapD Merchant app identity
/// 
/// Usage:
/// ```
/// cd packages/nostr_core
/// dart run generate_app_identity.dart
/// ```

Future<void> main() async {
  print('🔑 Generating ZapD Merchant App Identity...');
  print('');
  
  // Generate keypair
  print('⚙️  Generating secp256k1 keypair...');
  final keyPair = KeyPair.generate();
  
  print('✅ Keypair generated!');
  print('');
  print('📋 App Public Key (npub):');
  print('   ${keyPair.publicKey}');
  print('');
  print('🔐 App Private Key (nsec):');
  print('   ${keyPair.privateKey}');
  print('');
  print('⚠️  IMPORTANT: Copy these keys to zapd_app_identity.dart!');
  print('');
  
  // Create NIP-89 metadata
  final identifier = DateTime.now().millisecondsSinceEpoch.toString();
  final metadata = {
    'name': 'ZapD Merchant',
    'display_name': 'ZapD - Restaurant Management',
    'about': 'ZapD decentralized food delivery platform - Restaurant management app',
    'picture': 'https://zapd.io/icon-merchant.png',
    'platforms': ['web', 'macos', 'windows'],
  };
  
  print('📱 Creating NIP-89 metadata event...');
  
  // Create kind 31990 event
  final createdAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final tags = [
    ['d', identifier],
    ['name', 'ZapD Merchant'],
    ['display_name', 'ZapD - Restaurant Management'],
    ['picture', 'https://zapd.io/icon-merchant.png'],
    ['about', 'ZapD decentralized food delivery platform - Restaurant management app'],
  ];
  
  final content = jsonEncode(metadata);
  
  // Compute event ID
  final id = NostrEvent.computeId(
    pubkey: keyPair.publicKey,
    createdAt: createdAt,
    kind: 31990,
    tags: tags,
    content: content,
  );
  
  // Sign event
  final signature = Schnorr.sign(id, keyPair.privateKey);
  
  final event = {
    'id': id,
    'pubkey': keyPair.publicKey,
    'created_at': createdAt,
    'kind': 31990,
    'tags': tags,
    'content': content,
    'sig': signature,
  };
  
  print('✅ Event created and signed!');
  print('');
  print('📋 Event JSON:');
  print(jsonEncode(event));
  print('');
  
  // Publish to major relays
  final relays = [
    'wss://relay.damus.io',
    'wss://relay.nostr.band',
    'wss://nos.lol',
    'wss://relay.nsec.app',
  ];
  
  print('📡 Publishing to relays...');
  
  for (final relayUrl in relays) {
    try {
      print('   Connecting to $relayUrl...');
      final channel = WebSocketChannel.connect(Uri.parse(relayUrl));
      
      // Send event
      channel.sink.add(jsonEncode(['EVENT', event]));
      
      // Wait for OK response
      await for (final message in channel.stream.timeout(
        const Duration(seconds: 5),
        onTimeout: (sink) => sink.close(),
      )) {
        final response = jsonDecode(message) as List;
        if (response[0] == 'OK') {
          final accepted = response[2] as bool;
          if (accepted) {
            print('   ✅ Published to $relayUrl');
          } else {
            print('   ❌ Rejected by $relayUrl: ${response[3]}');
          }
          break;
        }
      }
      
      await channel.sink.close();
    } catch (e) {
      print('   ⚠️  Failed to publish to $relayUrl: $e');
    }
  }
  
  print('');
  print('✅ Done! Update zapd_app_identity.dart with:');
  print('');
  print('  static const String appPubkey = \'${keyPair.publicKey}\';');
  print('  static const String appPrivkey = \'${keyPair.privateKey}\';');
  print('  static const String identifier = \'$identifier\';');
  print('');
  print('🏷️  Client Tag: [\'client\', \'ZapD Merchant\', \'31990:${keyPair.publicKey}:$identifier\']');
}
