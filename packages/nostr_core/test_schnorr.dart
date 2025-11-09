import 'lib/src/crypto/schnorr.dart';
import 'lib/src/crypto/key_pair.dart';
import 'lib/src/events/event.dart';
import 'dart:convert';

void main() {
  print('Testing Schnorr Signature...\n');
  
  // Test 1: Generate keypair
  final kp = KeyPair.generate();
  print('Generated keypair:');
  print('  privkey: ${kp.privateKey.substring(0, 16)}...');
  print('  pubkey: ${kp.publicKey}');
  
  // Test 2: Compute event ID
  final createdAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final tags = [['p', 'test']];
  final content = 'test content';
  final kind = 1;
  
  final id = NostrEvent.computeId(
    pubkey: kp.publicKey,
    createdAt: createdAt,
    kind: kind,
    tags: tags,
    content: content,
  );
  
  print('\nEvent ID: $id');
  
  // Test 3: Sign
  print('\nSigning event...');
  final sig = Schnorr.sign(id, kp.privateKey);
  print('Signature: $sig');
  
  // Test 4: Verify
  print('\nVerifying signature...');
  final valid = Schnorr.verify(sig, id, kp.publicKey);
  print('Valid: $valid');
  
  if (!valid) {
    print('\n❌ SIGNATURE VERIFICATION FAILED!');
    print('This is why relay rejects events.');
  } else {
    print('\n✅ Signature verification passed!');
  }
}
