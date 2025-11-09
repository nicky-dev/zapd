import 'lib/src/crypto/schnorr.dart';

void main() {
  print('🧪 Testing Schnorr Sign-Verify Roundtrip\n');
  
  final privkey = '0000000000000000000000000000000000000000000000000000000000000003';
  final pubkey = Schnorr.getPublicKey(privkey);
  final message = '0000000000000000000000000000000000000000000000000000000000000000';
  
  print('Private key: $privkey');
  print('Public key:  $pubkey');
  print('Message:     $message\n');
  
  // Sign
  final sig = Schnorr.sign(message, privkey);
  print('Signature:   $sig\n');
  
  // Verify
  final valid = Schnorr.verify(sig, message, pubkey);
  print('Verification: ${valid ? "✅ VALID" : "❌ INVALID"}');
  
  if (valid) {
    print('\n🎉 SUCCESS! Schnorr sign+verify works correctly!');
  } else {
    print('\n❌ FAILED! Signature verification failed!');
  }
}
