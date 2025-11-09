/// Nostr constants
class NostrConstants {
  /// Default public relays
  static const List<String> defaultRelays = [
    'wss://relay.damus.io',
    'wss://relay.nostr.band',
    'wss://nos.lol',
    'wss://relay.snort.social',
    'wss://nostr.wine',
  ];

  /// Event kind ranges
  static const int regularEventStart = 1000;
  static const int regularEventEnd = 9999;
  static const int replaceableEventStart = 10000;
  static const int replaceableEventEnd = 19999;
  static const int ephemeralEventStart = 20000;
  static const int ephemeralEventEnd = 29999;
  static const int parameterizedReplaceableEventStart = 30000;
  static const int parameterizedReplaceableEventEnd = 39999;
}
