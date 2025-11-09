import 'dart:convert';

/// NIP-46: Nostr Connect
///
/// Remote signing protocol for Nostr
/// Spec: https://github.com/nostr-protocol/nips/blob/master/46.md

/// Request types for NIP-46 protocol
enum Nip46Method {
  connect('connect'),
  signEvent('sign_event'),
  getPublicKey('get_public_key'),
  nip04Encrypt('nip04_encrypt'),
  nip04Decrypt('nip04_decrypt'),
  nip44Encrypt('nip44_encrypt'),
  nip44Decrypt('nip44_decrypt'),
  ping('ping');

  const Nip46Method(this.value);
  final String value;

  factory Nip46Method.fromString(String value) {
    return values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown NIP-46 method: $value'),
    );
  }
}

/// NIP-46 Request message
class Nip46Request {
  final String id;
  final Nip46Method method;
  final List<dynamic> params;

  const Nip46Request({
    required this.id,
    required this.method,
    this.params = const [],
  });

  /// Convert to JSON for encryption
  Map<String, dynamic> toJson() => {
        'id': id,
        'method': method.value,
        'params': params,
      };

  String toJsonString() => jsonEncode(toJson());

  factory Nip46Request.fromJson(Map<String, dynamic> json) {
    return Nip46Request(
      id: json['id'] as String,
      method: Nip46Method.fromString(json['method'] as String),
      params: json['params'] as List<dynamic>? ?? [],
    );
  }

  factory Nip46Request.fromJsonString(String jsonString) {
    return Nip46Request.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }
}

/// NIP-46 Response message
class Nip46Response {
  final String id;
  final String? result;
  final String? error;

  const Nip46Response({
    required this.id,
    this.result,
    this.error,
  });

  bool get isSuccess => error == null;
  bool get isError => error != null;

  Map<String, dynamic> toJson() => {
        'id': id,
        if (result != null) 'result': result,
        if (error != null) 'error': error,
      };

  String toJsonString() => jsonEncode(toJson());

  factory Nip46Response.fromJson(Map<String, dynamic> json) {
    return Nip46Response(
      id: json['id'] as String,
      result: json['result'] as String?,
      error: json['error'] as String?,
    );
  }

  factory Nip46Response.fromJsonString(String jsonString) {
    return Nip46Response.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }
}

/// Bunker connection details parsed from bunker:// URL
class BunkerConnection {
  final String remotePubkey;
  final List<String> relays;
  final String? secret;

  const BunkerConnection({
    required this.remotePubkey,
    required this.relays,
    this.secret,
  });

  /// Parse bunker URL
  ///
  /// Format: bunker://<remote-pubkey>?relay=<relay-url>&relay=<relay-url>&secret=<optional-secret>
  factory BunkerConnection.fromUrl(String url) {
    if (!url.startsWith('bunker://')) {
      throw ArgumentError('Invalid bunker URL format. Must start with bunker://');
    }

    final uri = Uri.parse(url);
    final remotePubkey = uri.host;

    if (remotePubkey.isEmpty) {
      throw ArgumentError('Missing remote pubkey in bunker URL');
    }

    final relays = uri.queryParametersAll['relay'] ?? [];
    if (relays.isEmpty) {
      throw ArgumentError('At least one relay is required in bunker URL');
    }

    // Validate relay URLs
    for (final relay in relays) {
      if (!relay.startsWith('wss://') && !relay.startsWith('ws://')) {
        throw ArgumentError('Invalid relay URL: $relay. Must start with wss:// or ws://');
      }
    }

    final secret = uri.queryParameters['secret'];

    return BunkerConnection(
      remotePubkey: remotePubkey,
      relays: relays,
      secret: secret,
    );
  }

  /// Convert to bunker URL
  String toUrl() {
    final uri = Uri(
      scheme: 'bunker',
      host: remotePubkey,
      queryParameters: {
        'relay': relays,
        if (secret != null) 'secret': secret,
      },
    );
    return uri.toString();
  }
}

/// Active NIP-46 session
class Nip46Session {
  final BunkerConnection connection;
  final String ephemeralPrivateKey;
  final String ephemeralPublicKey;
  final DateTime createdAt;
  final String? remotePublicKey; // Set after successful connect

  const Nip46Session({
    required this.connection,
    required this.ephemeralPrivateKey,
    required this.ephemeralPublicKey,
    required this.createdAt,
    this.remotePublicKey,
  });

  Nip46Session copyWith({
    BunkerConnection? connection,
    String? ephemeralPrivateKey,
    String? ephemeralPublicKey,
    DateTime? createdAt,
    String? remotePublicKey,
  }) {
    return Nip46Session(
      connection: connection ?? this.connection,
      ephemeralPrivateKey: ephemeralPrivateKey ?? this.ephemeralPrivateKey,
      ephemeralPublicKey: ephemeralPublicKey ?? this.ephemeralPublicKey,
      createdAt: createdAt ?? this.createdAt,
      remotePublicKey: remotePublicKey ?? this.remotePublicKey,
    );
  }

  Map<String, dynamic> toJson() => {
        'connection': {
          'remotePubkey': connection.remotePubkey,
          'relays': connection.relays,
          'secret': connection.secret,
        },
        'ephemeralPrivateKey': ephemeralPrivateKey,
        'ephemeralPublicKey': ephemeralPublicKey,
        'createdAt': createdAt.toIso8601String(),
        'remotePublicKey': remotePublicKey,
      };

  factory Nip46Session.fromJson(Map<String, dynamic> json) {
    final connectionJson = json['connection'] as Map<String, dynamic>;
    return Nip46Session(
      connection: BunkerConnection(
        remotePubkey: connectionJson['remotePubkey'] as String,
        relays: (connectionJson['relays'] as List).cast<String>(),
        secret: connectionJson['secret'] as String?,
      ),
      ephemeralPrivateKey: json['ephemeralPrivateKey'] as String,
      ephemeralPublicKey: json['ephemeralPublicKey'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      remotePublicKey: json['remotePublicKey'] as String?,
    );
  }
}
