import 'package:flutter_test/flutter_test.dart';
import 'package:nostr_core/nostr_core.dart';

void main() {
  group('NostrEvent', () {
    test('should create event from JSON', () {
      final json = {
        'id': 'a' * 64,
        'pubkey': 'b' * 64,
        'created_at': 1234567890,
        'kind': 1,
        'tags': [
          ['p', 'c' * 64]
        ],
        'content': 'Hello Nostr!',
        'sig': 'd' * 128,
      };

      final event = NostrEvent.fromJson(json);

      expect(event.id, 'a' * 64);
      expect(event.pubkey, 'b' * 64);
      expect(event.kind, 1);
      expect(event.content, 'Hello Nostr!');
      expect(event.tags.length, 1);
    });

    test('should serialize event to JSON', () {
      final event = NostrEvent(
        id: 'a' * 64,
        pubkey: 'b' * 64,
        createdAt: 1234567890,
        kind: 1,
        tags: [],
        content: 'Test',
        sig: 'd' * 128,
      );

      final json = event.toJson();

      expect(json['id'], 'a' * 64);
      expect(json['kind'], 1);
      expect(json['content'], 'Test');
    });

    test('should get tag value', () {
      final event = NostrEvent(
        id: 'a' * 64,
        pubkey: 'b' * 64,
        createdAt: 1234567890,
        kind: 1,
        tags: [
          ['p', 'c' * 64],
          ['e', 'd' * 64],
        ],
        content: 'Test',
        sig: 'e' * 128,
      );

      expect(event.getTagValue('p'), 'c' * 64);
      expect(event.getTagValue('e'), 'd' * 64);
      expect(event.getTagValue('d'), null);
    });
  });

  group('NostrFilter', () {
    test('should serialize filter to JSON', () {
      final filter = NostrFilter(
        kinds: [1, 2],
        authors: ['a' * 64],
        limit: 10,
      );

      final json = filter.toJson();

      expect(json['kinds'], [1, 2]);
      expect(json['authors'], ['a' * 64]);
      expect(json['limit'], 10);
    });

    test('should serialize tag filters', () {
      final filter = NostrFilter(
        kinds: [1],
        tags: {
          'p': ['a' * 64, 'b' * 64],
        },
      );

      final json = filter.toJson();

      expect(json['#p'], ['a' * 64, 'b' * 64]);
    });
  });

  group('EventBuilder', () {
    test('should build event', () {
      final builder = EventBuilder();
      final event = builder
          .pubkey('a' * 64)
          .kind(1)
          .content('Hello')
          .tagPubkey('b' * 64)
          .build();

      expect(event.pubkey, 'a' * 64);
      expect(event.kind, 1);
      expect(event.content, 'Hello');
      expect(event.tags.length, 1);
      expect(event.tags[0][0], 'p');
      expect(event.tags[0][1], 'b' * 64);
    });

    test('should throw if missing required fields', () {
      final builder = EventBuilder();

      expect(() => builder.kind(1).build(), throwsException);
      expect(() => builder.pubkey('a' * 64).build(), throwsException);
    });
  });

  group('Helpers', () {
    test('should validate public key', () {
      expect(NostrHelpers.isValidPublicKey('a' * 64), true);
      expect(NostrHelpers.isValidPublicKey('invalid'), false);
      expect(NostrHelpers.isValidPublicKey('a' * 63), false);
    });

    test('should convert hex to bytes and back', () {
      final hex = 'abcdef1234567890';
      final bytes = NostrHelpers.hexToBytes(hex);
      final result = NostrHelpers.bytesToHex(bytes);

      expect(result, hex);
    });
  });

  group('Relay', () {
    test('should create relay', () {
      final relay = Relay(url: 'wss://relay.example.com');

      expect(relay.url, 'wss://relay.example.com');
      expect(relay.read, true);
      expect(relay.write, true);
    });

    test('should serialize relay', () {
      final relay = Relay(
        url: 'wss://relay.example.com',
        read: true,
        write: false,
      );

      final json = relay.toJson();

      expect(json['url'], 'wss://relay.example.com');
      expect(json['read'], true);
      expect(json['write'], false);
    });
  });
}
