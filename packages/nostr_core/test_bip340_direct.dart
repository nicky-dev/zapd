import 'package:bip340/bip340.dart' as bip340;

void main() {
  print('🧪 Testing BIP-340 directly\n');
  
  final privkey = '0000000000000000000000000000000000000000000000000000000000000003';
  final message = '0000000000000000000000000000000000000000000000000000000000000000';
  final expected = 'e907831f80848d1069a5371b402410364bdf1c5f8307b0084c55f1ce2dca821525f66a4a85ea8b71e482a74f382d2ce5ebeee8fdb2172f477df4900d310536c0';
  
  final aux = '0000000000000000000000000000000000000000000000000000000000000000';
  final sig = bip340.sign(privkey, message, aux);
  print('Generated: $sig');
  print('Expected:  $expected');
  print('Match: ${sig.toLowerCase() == expected.toLowerCase()}');
  
  if (sig.toLowerCase() == expected.toLowerCase()) {
    print('\n✅ PERFECT! bip340 package works correctly!');
  } else {
    print('\n❌ Still wrong!');
  }
}
