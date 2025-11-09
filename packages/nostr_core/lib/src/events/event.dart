import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../crypto/schnorr.dart';

/// Nostr event constants
class EventKind {
  static const int metadata = 0;
  static const int textNote = 1;
  static const int recommendServer = 2;
  static const int contactList = 3;
  static const int encryptedDirectMessage = 4;
  static const int deletion = 5;

  // ZapD custom kinds
  static const int restaurantProfile = 30000;
  static const int menuItem = 30001;
  static const int orderPublic = 30002;
  static const int riderLocation = 30003;
  static const int review = 30004;
  static const int orderStatus = 30078;
}

/// Nostr event model
class NostrEvent {
  final String id;
  final String pubkey;
  final int createdAt;
  final int kind;
  final List<List<String>> tags;
  final String content;
  final String sig;

  const NostrEvent({
    required this.id,
    required this.pubkey,
    required this.createdAt,
    required this.kind,
    required this.tags,
    required this.content,
    required this.sig,
  });

  /// Compute event ID according to NIP-01
  static String computeId({
    required String pubkey,
    required int createdAt,
    required int kind,
    required List<List<String>> tags,
    required String content,
  }) {
    final serialized = jsonEncode([
      0, // reserved for future use
      pubkey,
      createdAt,
      kind,
      tags,
      content,
    ]);

    print('🔍 Serialized for ID calculation:');
    print('   $serialized');

    final bytes = utf8.encode(serialized);
    final hash = sha256.convert(bytes);
    final computedId = hash.toString();
    
    print('   → Event ID: $computedId');

    return computedId;
  }

  /// Verify event signature
  bool verify() {
    // Recompute event ID
    final computedId = computeId(
      pubkey: pubkey,
      createdAt: createdAt,
      kind: kind,
      tags: tags,
      content: content,
    );
    
    // Check if ID matches
    if (computedId != id) {
      print('❌ Event ID mismatch: computed=$computedId, actual=$id');
      return false;
    }
    
    // Verify Schnorr signature
    return Schnorr.verify(sig, id, pubkey);
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'pubkey': pubkey,
        'created_at': createdAt,
        'kind': kind,
        'tags': tags,
        'content': content,
        'sig': sig,
      };

  /// Deserialize from JSON
  factory NostrEvent.fromJson(Map<String, dynamic> json) {
    return NostrEvent(
      id: json['id'] as String,
      pubkey: json['pubkey'] as String,
      createdAt: json['created_at'] as int,
      kind: json['kind'] as int,
      tags: (json['tags'] as List)
          .map((tag) => (tag as List).map((e) => e.toString()).toList())
          .toList(),
      content: json['content'] as String,
      sig: json['sig'] as String,
    );
  }

  /// Get tag value by key
  String? getTagValue(String key) {
    for (final tag in tags) {
      if (tag.isNotEmpty && tag[0] == key && tag.length > 1) {
        return tag[1];
      }
    }
    return null;
  }

  /// Get all tag values by key
  List<String> getTagValues(String key) {
    return tags
        .where((tag) => tag.isNotEmpty && tag[0] == key && tag.length > 1)
        .map((tag) => tag[1])
        .toList();
  }

  @override
  String toString() =>
      'NostrEvent(id: $id, kind: $kind, pubkey: ${pubkey.substring(0, 8)}...)';
}
