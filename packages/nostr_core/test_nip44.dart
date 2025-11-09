import 'dart:math';
import 'dart:typed_data';
import 'package:ndk/shared/nips/nip44/nip44.dart';
import 'package:bip340/bip340.dart' as bip340;
import 'package:hex/hex.dart';

String generatePrivateKey() {
  final random = Random.secure();
  final bytes = Uint8List(32);
  for (int i = 0; i < 32; i++) {
    bytes[i] = random.nextInt(256);
  }
  return HEX.encode(bytes);
}

void main() async {
  print('🔒 Testing NIP-44 Encryption...\n');
  
  // Generate two keypairs
  final privateKey1 = generatePrivateKey();
  final publicKey1 = bip340.getPublicKey(privateKey1);
  
  final privateKey2 = generatePrivateKey();
  final publicKey2 = bip340.getPublicKey(privateKey2);
  
  print('Key 1 Private: $privateKey1');
  print('Key 1 Public:  $publicKey1');
  print('Key 2 Private: $privateKey2');
  print('Key 2 Public:  $publicKey2\n');
  
  // Test message
  final message = '{"id":"test123","method":"connect","params":["pubkey","secret"]}';
  print('Original: $message\n');
  
  // Encrypt: Key1 -> Key2
  print('🔐 Encrypting with Key1 to Key2...');
  final encrypted = await Nip44.encryptMessage(
    message,
    privateKey1,
    publicKey2,
  );
  print('Encrypted: $encrypted\n');
  
  // Decrypt: Key2 <- Key1
  print('🔓 Decrypting with Key2 from Key1...');
  final decrypted = await Nip44.decryptMessage(
    encrypted,
    privateKey2,
    publicKey1,
  );
  print('Decrypted: $decrypted\n');
  
  // Verify
  if (decrypted == message) {
    print('✅ NIP-44 Encryption/Decryption WORKS!');
  } else {
    print('❌ NIP-44 Encryption/Decryption FAILED!');
    print('Expected: $message');
    print('Got:      $decrypted');
  }
  
  // Test conversation key consistency
  print('\n🔑 Testing Conversation Key Consistency...');
  final sharedSecret1 = Nip44.computeSharedSecret(privateKey1, publicKey2);
  final sharedSecret2 = Nip44.computeSharedSecret(privateKey2, publicKey1);
  final convKey1 = Nip44.deriveConversationKey(sharedSecret1);
  final convKey2 = Nip44.deriveConversationKey(sharedSecret2);
  
  print('Shared Secret 1: ${sharedSecret1.sublist(0, 8).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}...');
  print('Shared Secret 2: ${sharedSecret2.sublist(0, 8).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}...');
  print('Conv Key 1:      ${convKey1.sublist(0, 8).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}...');
  print('Conv Key 2:      ${convKey2.sublist(0, 8).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}...');
  
  if (sharedSecret1.toString() == sharedSecret2.toString() &&
      convKey1.toString() == convKey2.toString()) {
    print('✅ Conversation Keys Match!');
  } else {
    print('❌ Conversation Keys DO NOT Match!');
  }
}
