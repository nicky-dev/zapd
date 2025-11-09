/// NIP-01: Basic protocol flow
///
/// Specification: https://github.com/nostr-protocol/nips/blob/master/01.md

/// Message types
class MessageType {
  static const String event = 'EVENT';
  static const String req = 'REQ';
  static const String close = 'CLOSE';
  static const String eose = 'EOSE';
  static const String ok = 'OK';
  static const String notice = 'NOTICE';
}
