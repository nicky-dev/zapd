/// Nostr relay model
class Relay {
  final String url;
  final bool read;
  final bool write;

  const Relay({
    required this.url,
    this.read = true,
    this.write = true,
  });

  /// Create relay from URL
  factory Relay.fromUrl(String url) {
    return Relay(url: url);
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() => {
        'url': url,
        'read': read,
        'write': write,
      };

  /// Deserialize from JSON
  factory Relay.fromJson(Map<String, dynamic> json) {
    return Relay(
      url: json['url'] as String,
      read: json['read'] as bool? ?? true,
      write: json['write'] as bool? ?? true,
    );
  }

  @override
  String toString() => 'Relay(url: $url, read: $read, write: $write)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Relay && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;
}
