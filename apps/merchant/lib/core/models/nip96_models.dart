/// NIP-96 Server Configuration
/// 
/// Represents the configuration from /.well-known/nostr/nip96.json
class NIP96ServerConfig {
  final String apiUrl;
  final String? downloadUrl;
  final List<int>? supportedNips;
  final String? tosUrl;
  final List<String>? contentTypes;
  final Map<String, NIP96Plan>? plans;

  const NIP96ServerConfig({
    required this.apiUrl,
    this.downloadUrl,
    this.supportedNips,
    this.tosUrl,
    this.contentTypes,
    this.plans,
  });

  factory NIP96ServerConfig.fromJson(Map<String, dynamic> json) {
    return NIP96ServerConfig(
      apiUrl: json['api_url'] as String,
      downloadUrl: json['download_url'] as String?,
      supportedNips: (json['supported_nips'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      tosUrl: json['tos_url'] as String?,
      contentTypes: (json['content_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      plans: (json['plans'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          NIP96Plan.fromJson(value as Map<String, dynamic>),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'api_url': apiUrl,
      if (downloadUrl != null) 'download_url': downloadUrl,
      if (supportedNips != null) 'supported_nips': supportedNips,
      if (tosUrl != null) 'tos_url': tosUrl,
      if (contentTypes != null) 'content_types': contentTypes,
      if (plans != null)
        'plans': plans!.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  /// Get the download URL or fallback to api_url
  String getDownloadUrl() => downloadUrl?.isNotEmpty == true ? downloadUrl! : apiUrl;

  /// Check if server has a free plan
  bool get hasFreePlan => plans?.containsKey('free') ?? false;
}

/// NIP-96 Plan configuration
class NIP96Plan {
  final String name;
  final bool isNip98Required;
  final String? url;
  final int? maxByteSize;
  final List<int>? fileExpiration;
  final Map<String, List<String>>? mediaTransformations;

  const NIP96Plan({
    required this.name,
    this.isNip98Required = true,
    this.url,
    this.maxByteSize,
    this.fileExpiration,
    this.mediaTransformations,
  });

  factory NIP96Plan.fromJson(Map<String, dynamic> json) {
    return NIP96Plan(
      name: json['name'] as String,
      isNip98Required: json['is_nip98_required'] as bool? ?? true,
      url: json['url'] as String?,
      maxByteSize: json['max_byte_size'] as int?,
      fileExpiration: (json['file_expiration'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      mediaTransformations:
          (json['media_transformations'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) => e as String).toList(),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'is_nip98_required': isNip98Required,
      if (url != null) 'url': url,
      if (maxByteSize != null) 'max_byte_size': maxByteSize,
      if (fileExpiration != null) 'file_expiration': fileExpiration,
      if (mediaTransformations != null)
        'media_transformations': mediaTransformations,
    };
  }
}

/// NIP-96 Upload Response
class NIP96UploadResponse {
  final String status; // "success" or "error"
  final String message;
  final String? processingUrl;
  final NIP94Event? nip94Event;

  const NIP96UploadResponse({
    required this.status,
    required this.message,
    this.processingUrl,
    this.nip94Event,
  });

  factory NIP96UploadResponse.fromJson(Map<String, dynamic> json) {
    return NIP96UploadResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      processingUrl: json['processing_url'] as String?,
      nip94Event: json['nip94_event'] != null
          ? NIP94Event.fromJson(json['nip94_event'] as Map<String, dynamic>)
          : null,
    );
  }

  bool get isSuccess => status == 'success';
  bool get isError => status == 'error';
}

/// NIP-94 Event (File Metadata Event)
class NIP94Event {
  final List<List<String>> tags;
  final String content;

  const NIP94Event({
    required this.tags,
    required this.content,
  });

  factory NIP94Event.fromJson(Map<String, dynamic> json) {
    return NIP94Event(
      tags: (json['tags'] as List<dynamic>)
          .map((tag) => (tag as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tags': tags,
      'content': content,
    };
  }

  /// Get tag value by tag name
  String? getTagValue(String tagName) {
    try {
      final tag = tags.firstWhere((t) => t.isNotEmpty && t[0] == tagName);
      return tag.length > 1 ? tag[1] : null;
    } catch (e) {
      return null;
    }
  }

  /// Get the download URL
  String? get url => getTagValue('url');

  /// Get the original file hash (before transformations)
  String? get originalHash => getTagValue('ox');

  /// Get the transformed file hash
  String? get transformedHash => getTagValue('x');

  /// Get the mime type
  String? get mimeType => getTagValue('m');

  /// Get the dimensions (e.g., "800x600")
  String? get dimensions => getTagValue('dim');

  /// Get the file size in bytes
  int? get size {
    final sizeStr = getTagValue('size');
    return sizeStr != null ? int.tryParse(sizeStr) : null;
  }
}

/// NIP-96 Predefined Servers
class NIP96Servers {
  /// nostr.build
  static const nostrBuild = 'https://nostr.build';

  /// void.cat
  static const voidCat = 'https://void.cat';

  /// nostrcheck.me
  static const nostrCheck = 'https://nostrcheck.me';

  /// List of well-known NIP-96 servers
  static const List<String> wellKnownServers = [
    nostrBuild,
    voidCat,
    nostrCheck,
  ];
}
