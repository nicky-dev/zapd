import 'package:flutter_test/flutter_test.dart';
import 'package:nostr_core/nostr_core.dart';

void main() {
  group('NIP-19 bech32 encoding/decoding', () {
    const testPubkey = 'a1b2c3d4e5f67890a1b2c3d4e5f67890a1b2c3d4e5f67890a1b2c3d4e5f67890';
    const testPrivkey = '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef';
    const testNoteId = 'abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890';

    test('encodePublicKey produces valid npub', () {
      final npub = NIP19.encodePublicKey(testPubkey);
      
      expect(npub.startsWith('npub1'), true);
      expect(npub.length, 63);
    });

    test('decodePublicKey reverses encodePublicKey', () {
      final npub = NIP19.encodePublicKey(testPubkey);
      final decoded = NIP19.decodePublicKey(npub);
      
      expect(decoded, testPubkey);
    });

    test('encodePrivateKey produces valid nsec', () {
      final nsec = NIP19.encodePrivateKey(testPrivkey);
      
      expect(nsec.startsWith('nsec1'), true);
      expect(nsec.length, 63);
    });

    test('decodePrivateKey reverses encodePrivateKey', () {
      final nsec = NIP19.encodePrivateKey(testPrivkey);
      final decoded = NIP19.decodePrivateKey(nsec);
      
      expect(decoded, testPrivkey);
    });

    test('encodeNote produces valid note', () {
      final note = NIP19.encodeNote(testNoteId);
      
      expect(note.startsWith('note1'), true);
      expect(note.length, 63);
    });

    test('decodeNote reverses encodeNote', () {
      final note = NIP19.encodeNote(testNoteId);
      final decoded = NIP19.decodeNote(note);
      
      expect(decoded, testNoteId);
    });

    test('isNpub validates npub correctly', () {
      final npub = NIP19.encodePublicKey(testPubkey);
      
      expect(NIP19.isNpub(npub), true);
      expect(NIP19.isNpub('invalid'), false);
      expect(NIP19.isNpub('nsec1...'), false);
    });

    test('isNsec validates nsec correctly', () {
      final nsec = NIP19.encodePrivateKey(testPrivkey);
      
      expect(NIP19.isNsec(nsec), true);
      expect(NIP19.isNsec('invalid'), false);
      expect(NIP19.isNsec('npub1...'), false);
    });

    test('isNote validates note correctly', () {
      final note = NIP19.encodeNote(testNoteId);
      
      expect(NIP19.isNote(note), true);
      expect(NIP19.isNote('invalid'), false);
      expect(NIP19.isNote('npub1...'), false);
    });

    test('isHexKey validates hex keys correctly', () {
      expect(NIP19.isHexKey(testPubkey), true);
      expect(NIP19.isHexKey(testPrivkey), true);
      expect(NIP19.isHexKey('invalid'), false);
      expect(NIP19.isHexKey('tooshort'), false);
      expect(NIP19.isHexKey('toolong1234567890abcdef1234567890'), false);
    });

    test('decodePublicKey throws on invalid prefix', () {
      final nsec = NIP19.encodePrivateKey(testPrivkey);
      
      expect(
        () => NIP19.decodePublicKey(nsec),
        throwsException,
      );
    });

    test('decodePrivateKey throws on invalid prefix', () {
      final npub = NIP19.encodePublicKey(testPubkey);
      
      expect(
        () => NIP19.decodePrivateKey(npub),
        throwsException,
      );
    });

    test('decodeNote throws on invalid prefix', () {
      final npub = NIP19.encodePublicKey(testPubkey);
      
      expect(
        () => NIP19.decodeNote(npub),
        throwsException,
      );
    });
  });
}
