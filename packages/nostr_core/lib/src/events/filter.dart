/// Nostr event filter for subscriptions
class NostrFilter {
  final List<String>? ids;
  final List<String>? authors;
  final List<int>? kinds;
  final Map<String, List<String>>? tags;
  final int? since;
  final int? until;
  final int? limit;

  const NostrFilter({
    this.ids,
    this.authors,
    this.kinds,
    this.tags,
    this.since,
    this.until,
    this.limit,
  });

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (ids != null && ids!.isNotEmpty) json['ids'] = ids;
    if (authors != null && authors!.isNotEmpty) json['authors'] = authors;
    if (kinds != null && kinds!.isNotEmpty) json['kinds'] = kinds;
    if (since != null) json['since'] = since;
    if (until != null) json['until'] = until;
    if (limit != null) json['limit'] = limit;

    // Add tag filters
    if (tags != null) {
      tags!.forEach((key, value) {
        if (value.isNotEmpty) {
          json['#$key'] = value;
        }
      });
    }

    return json;
  }

  /// Deserialize from JSON
  factory NostrFilter.fromJson(Map<String, dynamic> json) {
    final tags = <String, List<String>>{};

    // Extract tag filters
    json.forEach((key, value) {
      if (key.startsWith('#') && value is List) {
        tags[key.substring(1)] = value.map((e) => e.toString()).toList();
      }
    });

    return NostrFilter(
      ids: json['ids'] != null
          ? (json['ids'] as List).map((e) => e.toString()).toList()
          : null,
      authors: json['authors'] != null
          ? (json['authors'] as List).map((e) => e.toString()).toList()
          : null,
      kinds: json['kinds'] != null
          ? (json['kinds'] as List).map((e) => e as int).toList()
          : null,
      tags: tags.isNotEmpty ? tags : null,
      since: json['since'] as int?,
      until: json['until'] as int?,
      limit: json['limit'] as int?,
    );
  }

  @override
  String toString() {
    return 'NostrFilter(kinds: $kinds, authors: ${authors?.length ?? 0}, limit: $limit)';
  }
}
