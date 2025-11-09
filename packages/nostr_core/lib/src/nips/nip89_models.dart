/// NIP-89: Application Handlers
///
/// Spec: https://github.com/nostr-protocol/nips/blob/master/89.md
///
/// Used to announce and discover application handlers (clients, bots, services)
/// Bunker services like nsec.app use this to identify and display client apps

/// Application handler metadata (kind 31990)
class Nip89AppMetadata {
  final String name;
  final String? displayName;
  final String? picture;
  final String? about;
  final String? nip05;
  final List<String>? platforms; // e.g., ['web', 'ios', 'android']

  const Nip89AppMetadata({
    required this.name,
    this.displayName,
    this.picture,
    this.about,
    this.nip05,
    this.platforms,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (displayName != null) 'display_name': displayName,
        if (picture != null) 'picture': picture,
        if (about != null) 'about': about,
        if (nip05 != null) 'nip05': nip05,
        if (platforms != null) 'platforms': platforms,
      };
}

/// NIP-89 Application Handler Reference
///
/// Used in client tags: ["client", "AppName", "31990:pubkey:identifier"]
class Nip89AppReference {
  final String pubkey;
  final String identifier;
  final String name;

  const Nip89AppReference({
    required this.pubkey,
    required this.identifier,
    required this.name,
  });

  /// Get the NIP-19 address coordinate (naddr)
  String get address => '31990:$pubkey:$identifier';

  /// Get client tag for events
  List<String> get clientTag => ['client', name, address];

  @override
  String toString() => '$name ($address)';
}
