import 'lib/src/events/event.dart';
import 'dart:convert';

void main() {
  print('🔍 Testing NostrEvent.verify() with REJECTED event\n');
  
  // Event 9d348da1... ที่ relay reject บอกว่า "invalid: signature is invalid"
  final eventJson = {
    "id": "9d348da1aa0b14dc7d758cb149eb0a6ece589ff13d69a4d8804bc5f5da529344",
    "pubkey": "f09fc4263541c87b0e88d4969c46ba1c3c3aca91770c1416bbf7a4b7153bdae9",
    "created_at": 1762622076,
    "kind": 24133,
    "tags": [["p", "76981d9eacb4f8f3a67d7821f80fba69003fce74ed1d2dc55214028d01fd7c46"]],
    "content": "An8GN5R0XvXRC35osotwDcGdGqYRgiJTVjXOovapLBtajSc9kQjGSTJtAEhtIcjKj1/o3iuuIk/ASB6zNU7RTenR0bXC13bsaUd5rwUTkABIZSWNC2xAi8xnoxR42esc4UE+fSSALoXgUa5vE4ZeSoBXljIowZac4ib5CYBg89SF+GsKdUyFs+sKKOY8CT+Nb2SUuG5l3hW6s4Jlxi3RdnsoZKc/MjstsUjnX5YcMvcVK8pAXGhpejeOsj+LE23HKBPMYorl1jE93M8=",
    "sig": "99b253ca15c0b4443ac0ae82a8c9ddf2657481f0fc5d427ca1cd78f8b39a2e53ef95274261e196971f8395523b93a87c520c07cb656a01330a581397ad5d5243"
  };
  
  print('Event ID: ${eventJson["id"]}');
  print('Pubkey:   ${eventJson["pubkey"]}');
  print('Sig:      ${eventJson["sig"]}\n');
  
  // Parse to NostrEvent
  final event = NostrEvent.fromJson(eventJson);
  
  // Verify using NostrEvent.verify()
  print('🔐 Calling NostrEvent.verify()...\n');
  final valid = event.verify();
  
  if (valid) {
    print('✅ ✅ ✅ SIGNATURE IS VALID! ✅ ✅ ✅');
    print('\nRelay is WRONG! The signature is mathematically correct!');
  } else {
    print('❌ ❌ ❌ SIGNATURE IS INVALID! ❌ ❌ ❌');
    print('\nRelay is RIGHT! The signature is actually broken!');
    print('\nPossible causes:');
    print('1. Event ID calculation is wrong');
    print('2. Public key does not match private key used to sign');
    print('3. Schnorr signature implementation has a bug');
  }
}
