import 'lib/src/events/event.dart';

void main() {
  print('🔍 Testing LATEST rejected event\n');
  
  final eventJson = {
    "id": "35ae6860f074c1a73f37881e84c5a0e71ea140f9f682d29d0cd0206139f27ac3",
    "pubkey": "074b756ca09d6b0c031eb6d63953efb4875894bd8f857578483e02ae103bdcfd",
    "created_at": 1762622942,
    "kind": 24133,
    "tags": [["p", "76981d9eacb4f8f3a67d7821f80fba69003fce74ed1d2dc55214028d01fd7c46"]],
    "content": "AmfEDOYvySMba5SyYFEcrlanL8pBki+Ohg7LP4TDsLFxu15or5rmBP/9BDmpL3YCNPMnetRJSEQuC4w6s2Uq9Lr7DhuBtBXq7Y+DZXB6iWICBNuxx/lRJ7zE9FZgaTzZ6qvoDHEb6h1R51wWF2xEhBnJin8lUc3udOiUR5V6xSOv6x0V21a5DkTl5PlNdqB9H1SUDXwtYHzNUjrDEqKFpLGWLUrwem0jn8A1rLUFrjGqyZYyIBWDxQs3B+QaQ4SQwKMtI2X2/UqJgUo=",
    "sig": "0131e4b60aa764d02816e8a0f36a1d8e691d346b8cd17c3e891bd0bc0efd157ffe98f812a166d7fd517110e88d374f2a656854227d465f400df57e80ecb60230"
  };
  
  print('Event ID: ${eventJson["id"]}');
  print('Pubkey:   ${eventJson["pubkey"]}');
  print('Sig:      ${eventJson["sig"]}\n');
  
  final event = NostrEvent.fromJson(eventJson);
  
  print('🔐 Verifying with NostrEvent.verify()...\n');
  final valid = event.verify();
  
  if (valid) {
    print('✅ SIGNATURE IS VALID!');
    print('\nConclusion: Our signature is correct, relay is wrong or has a bug.');
  } else {
    print('❌ SIGNATURE IS INVALID!');
    print('\nConclusion: We have a bug in signature generation.');
  }
}
