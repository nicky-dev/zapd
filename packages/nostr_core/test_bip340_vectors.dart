import 'lib/src/crypto/schnorr.dart';
import 'lib/src/crypto/key_pair.dart';

void main() {
  print('�� Testing BIP-340 Schnorr with official test vectors\n');
  
  // Test vector from BIP-340
  // https://github.com/bitcoin/bips/blob/master/bip-0340/test-vectors.csv
  
  print('Test 1: Basic signature');
  final privkey1 = '0000000000000000000000000000000000000000000000000000000000000003';
  final message1 = '0000000000000000000000000000000000000000000000000000000000000000';
  final expectedSig1 = 'E907831F80848D1069A5371B402410364BDF1C5F8307B0084C55F1CE2DCA821525F66A4A85EA8B71E482A74F382D2CE5EBEEE8FDB2172F477DF4900D310536C0';
  
  final sig1 = Schnorr.sign(message1, privkey1);
  print('Generated:  $sig1');
  print('Expected:   ${expectedSig1.toLowerCase()}');
  print('Match: ${sig1.toLowerCase() == expectedSig1.toLowerCase()}\n');
  
  if (sig1.toLowerCase() != expectedSig1.toLowerCase()) {
    print('❌ SIGNATURE MISMATCH!');
    print('Our Schnorr implementation is WRONG!');
  } else {
    print('✅ Signature matches BIP-340 test vector!');
  }
}
