import 'lib/src/crypto/key_pair.dart';
// removed unused import
import 'package:pointycastle/export.dart';

void main() {
  print('Testing KeyPair consistency...\n');
  
  // Generate keypair
  final kp = KeyPair.generate();
  print('Generated keypair:');
  print('  privkey: ${kp.privateKey}');
  print('  pubkey:  ${kp.publicKey}');
  
  // Manually compute public key from private key
  final domainParams = ECDomainParameters('secp256k1');
  final d = BigInt.parse(kp.privateKey, radix: 16);
  final P = domainParams.G * d;
  final px = P!.x!.toBigInteger()!;
  final py = P.y!.toBigInteger()!;
  
  print('\nManual computation from private key:');
  print('  P.x: ${px.toRadixString(16).padLeft(64, '0')}');
  print('  P.y is ${py.isEven ? "EVEN" : "ODD"}');
  
  print('\nDo they match?');
  final manualPubkey = px.toRadixString(16).padLeft(64, '0');
  print('  KeyPair.publicKey: ${kp.publicKey}');
  print('  Manual pubkey:     $manualPubkey');
  print('  Match: ${kp.publicKey == manualPubkey}');
  
  if (py.isOdd) {
    print('\n❌ ERROR: Public key y-coordinate is ODD!');
    print('This violates BIP-340 requirement.');
    print('Private key should have been negated but public key is wrong.');
  } else {
    print('\n✅ OK: Public key y-coordinate is EVEN (BIP-340 compliant)');
  }
}
