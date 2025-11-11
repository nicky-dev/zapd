import 'lib/src/crypto/key_pair.dart';
import 'lib/src/crypto/schnorr.dart';
import 'lib/src/events/event.dart';

void main() async {
  print('Full NIP-46 Event Signing Test\n');
  
  // 1. Generate ephemeral keypair (like NIP-46 does)
  final kp = KeyPair.generate();
  print('✅ Generated ephemeral keypair');
  print('   privkey: ${kp.privateKey.substring(0, 32)}...');
  print('   pubkey:  ${kp.publicKey.substring(0, 32)}...');
  
  // 2. Create fake encrypted content (base64)
  final encryptedContent = 'AaKhZLN0ynMdSMXMtest==';
  
  // 3. Create event data (simulating NIP-46 request)
  final createdAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final remotePubkey = '76981d9eacb4f8f3a67d7821f80fba69003fce74ed1d2dc55214028d01fd7c46';
  final tags = [['p', remotePubkey]];
  
  // 4. Compute event ID
  final id = NostrEvent.computeId(
    pubkey: kp.publicKey,
    createdAt: createdAt,
    kind: 24133,
    tags: tags,
    content: encryptedContent,
  );
  print('\n✅ Computed event ID');
  print('   id: ${id.substring(0, 32)}...');
  
  // 5. Sign with Schnorr
  print('\n✍️  Signing with Schnorr...');
  final signature = Schnorr.sign(id, kp.privateKey);
  print('✅ Signature created');
  print('   sig: ${signature.substring(0, 32)}...');
  
  // 6. Verify signature
  print('\n🔍 Verifying signature...');
  final valid = Schnorr.verify(signature, id, kp.publicKey);
  
  if (valid) {
    print('✅ ✅ ✅ SIGNATURE VALID! ✅ ✅ ✅');
    print('\nThis event should be accepted by relay!');
  } else {
    print('❌ ❌ ❌ SIGNATURE INVALID! ❌ ❌ ❌');
    print('\nRelay will reject this event.');
  }
  
  // 7. Print brief summary of the full event
  print('\nFull event summary:');
  print('  id:      $id');
  print('  pubkey:  ${kp.publicKey}');
  print('  sig:     $signature');
}
