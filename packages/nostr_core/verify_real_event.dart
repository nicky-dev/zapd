import 'lib/src/crypto/schnorr.dart';
import 'lib/src/events/event.dart';
// removed unused import

void main() {
  print('Verifying real rejected event...\n');
  
  // Event from production log
  final eventJson = {
    "id": "aa5cfb4e3a0731b5608f1e81274700b92d450d7ffc85576164739aa446e12a63",
    "pubkey": "d374a48a8118dec36244381dbb7b679723d17927ee7c0cc7db31a3f9cb9f0b67",
    "created_at": 1762621333,
    "kind": 24133,
    "tags": [["p", "76981d9eacb4f8f3a67d7821f80fba69003fce74ed1d2dc55214028d01fd7c46"]],
    "content": "AmcpScBDaSZynQkRBUxy/0Mkt+aZ0oNbbXlFhjTFRr/HKKd88wAoNLkgeCz3Qx/PYX+zOEd8/dy4UylMMPP7+p3KNpyAAC7l/jc786So/6zkrfZIHOXfPJfXkAmJw9Yu113MPtPlBFtBHeLlrFFfvbdU/xA2EX02FyMyT9Q1vp+EAZopHwWGuUZlI0z6zG6aWK3KE9DNbwzkkUMpTFuRQQsdiJkTjmOnAnLTEGvZuBXmhcAIAzk/0lKqD05DziDfX9LPzcMT3mMcCtI=",
    "sig": "00782841b51aa143ca4878d452a0f59c514dc4855bdda837d1cc864d1f272dd509827719bef602732352697a635cd70898bfb74ea50b223c0d42c5015450fe52"
  };
  
  print('Event ID: ${eventJson["id"]}');
  print('Pubkey:   ${eventJson["pubkey"]}');
  print('Sig:      ${eventJson["sig"]}\n');
  
  // Step 1: Verify event ID is correct
  print('Step 1: Verify event ID calculation...');
  final computedId = NostrEvent.computeId(
    pubkey: eventJson["pubkey"] as String,
    createdAt: eventJson["created_at"] as int,
    kind: eventJson["kind"] as int,
    tags: (eventJson["tags"] as List).cast<List<dynamic>>().map((t) => t.cast<String>()).toList(),
    content: eventJson["content"] as String,
  );
  
  print('Computed ID: $computedId');
  print('Event ID:    ${eventJson["id"]}');
  print('Match: ${computedId == eventJson["id"]}\n');
  
  if (computedId != eventJson["id"]) {
    print('❌ Event ID mismatch! Event ID calculation is wrong.');
    return;
  }
  
  // Step 2: Verify signature
  print('Step 2: Verify Schnorr signature...');
  final valid = Schnorr.verify(
    eventJson["sig"] as String,
    eventJson["id"] as String,
    eventJson["pubkey"] as String,
  );
  
  if (valid) {
    print('✅ ✅ ✅ SIGNATURE IS VALID! ✅ ✅ ✅');
    print('\nBut relay rejected it - this is a relay bug or protocol mismatch!');
  } else {
    print('❌ ❌ ❌ SIGNATURE IS INVALID! ❌ ❌ ❌');
    print('\nThis is why relay rejected the event.');
    print('\nPossible causes:');
    print('1. Public key in event does not match private key used to sign');
    print('2. Schnorr.sign() implementation is wrong');
    print('3. Event ID calculation is different from what was signed');
  }
}
