import 'event.dart';

/// Builder for creating Nostr events
class EventBuilder {
  String? _pubkey;
  int? _kind;
  String _content = '';
  final List<List<String>> _tags = [];

  /// Set public key
  EventBuilder pubkey(String pubkey) {
    _pubkey = pubkey;
    return this;
  }

  /// Set event kind
  EventBuilder kind(int kind) {
    _kind = kind;
    return this;
  }

  /// Set content
  EventBuilder content(String content) {
    _content = content;
    return this;
  }

  /// Add a tag
  EventBuilder addTag(List<String> tag) {
    _tags.add(tag);
    return this;
  }

  /// Add multiple tags
  EventBuilder addTags(List<List<String>> tags) {
    _tags.addAll(tags);
    return this;
  }

  /// Add a 'p' tag (pubkey reference)
  EventBuilder tagPubkey(String pubkey) {
    _tags.add(['p', pubkey]);
    return this;
  }

  /// Add an 'e' tag (event reference)
  EventBuilder tagEvent(String eventId) {
    _tags.add(['e', eventId]);
    return this;
  }

  /// Add a 'd' tag (identifier)
  EventBuilder tagIdentifier(String identifier) {
    _tags.add(['d', identifier]);
    return this;
  }

  /// Build unsigned event
  NostrEvent build() {
    if (_pubkey == null) {
      throw Exception('Public key is required');
    }
    if (_kind == null) {
      throw Exception('Event kind is required');
    }

    final createdAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final id = NostrEvent.computeId(
      pubkey: _pubkey!,
      createdAt: createdAt,
      kind: _kind!,
      tags: _tags,
      content: _content,
    );

    return NostrEvent(
      id: id,
      pubkey: _pubkey!,
      createdAt: createdAt,
      kind: _kind!,
      tags: List.from(_tags),
      content: _content,
      sig: '', // Will be signed later
    );
  }

  /// Reset builder
  void reset() {
    _pubkey = null;
    _kind = null;
    _content = '';
    _tags.clear();
  }
}
