import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:nostr_core/nostr_core.dart';
import '../models/nip96_models.dart';

/// NIP-96 HTTP File Storage Integration Service
/// 
/// Implements the full NIP-96 specification for uploading files to
/// Nostr-compatible media servers.
class NIP96Service {
  final String serverUrl;
  NIP96ServerConfig? _config;

  NIP96Service({required this.serverUrl});

  /// Discover server configuration from /.well-known/nostr/nip96.json
  Future<NIP96ServerConfig> discoverServer() async {
    if (_config != null) return _config!;

    try {
      final wellKnownUrl = serverUrl.endsWith('/')
          ? '${serverUrl}.well-known/nostr/nip96.json'
          : '$serverUrl/.well-known/nostr/nip96.json';

      final response = await http.get(Uri.parse(wellKnownUrl));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        _config = NIP96ServerConfig.fromJson(json);
        return _config!;
      } else {
        throw Exception(
          'Failed to discover NIP-96 server: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Server discovery failed: $e');
    }
  }

  /// Upload a file using NIP-96 protocol
  /// 
  /// Required: [imageBytes], [fileName], [privateKey] for NIP-98 auth
  /// Optional: [caption], [alt], [mediaType], [noTransform]
  Future<NIP96UploadResponse> uploadFile({
    required Uint8List imageBytes,
    required String fileName,
    required String privateKey,
    String? caption,
    String? alt,
    String? mediaType, // "avatar" or "banner"
    bool noTransform = false,
  }) async {
    try {
      // Discover server config
      final config = await discoverServer();

      // Calculate file hash for NIP-98 payload
      final hash = sha256.convert(imageBytes);
      final fileHash = hash.toString();

      // Create NIP-98 Authorization header
      final authHeader = await _createNIP98Auth(
        url: config.apiUrl,
        method: 'POST',
        privateKey: privateKey,
        payloadHash: fileHash,
      );

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(config.apiUrl));

      // Add authorization header
      request.headers['Authorization'] = authHeader;

      // Add file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: fileName,
        ),
      );

      // Add optional fields
      if (caption != null) {
        request.fields['caption'] = caption;
      }
      if (alt != null) {
        request.fields['alt'] = alt;
      }
      if (mediaType != null) {
        request.fields['media_type'] = mediaType;
      }
      if (noTransform) {
        request.fields['no_transform'] = 'true';
      }

      // Add file metadata
      request.fields['size'] = imageBytes.length.toString();

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Parse response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse =
            jsonDecode(response.body) as Map<String, dynamic>;
        return NIP96UploadResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 202) {
        // Accepted - processing
        final jsonResponse =
            jsonDecode(response.body) as Map<String, dynamic>;
        return NIP96UploadResponse.fromJson(jsonResponse);
      } else {
        // Error response
        try {
          final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(
            errorJson['message'] ?? 'Upload failed: ${response.statusCode}',
          );
        } catch (e) {
          throw Exception('Upload failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Upload failed: $e');
    }
  }

  /// Delete a file using NIP-96 protocol
  Future<bool> deleteFile({
    required String fileHash,
    required String privateKey,
    String? extension,
  }) async {
    try {
      final config = await discoverServer();

      // Construct delete URL
      final fileName = extension != null ? '$fileHash.$extension' : fileHash;
      final deleteUrl = '${config.apiUrl}/$fileName';

      // Create NIP-98 Authorization header
      final authHeader = await _createNIP98Auth(
        url: deleteUrl,
        method: 'DELETE',
        privateKey: privateKey,
      );

      // Send DELETE request
      final response = await http.delete(
        Uri.parse(deleteUrl),
        headers: {
          'Authorization': authHeader,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse =
            jsonDecode(response.body) as Map<String, dynamic>;
        return jsonResponse['status'] == 'success';
      } else {
        throw Exception('Delete failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Delete failed: $e');
    }
  }

  /// Create NIP-98 Authorization header
  /// 
  /// Creates a kind 27235 event for HTTP authentication
  Future<String> _createNIP98Auth({
    required String url,
    required String method,
    required String privateKey,
    String? payloadHash,
  }) async {
    try {
      // Get public key from private key
      final keyPair = KeyPair.fromPrivateKey(privateKey);
      final pubkey = keyPair.publicKey;

      // Create tags
      final tags = <List<String>>[
        ['u', url],
        ['method', method],
      ];

      if (payloadHash != null) {
        tags.add(['payload', payloadHash]);
      }

      // Build unsigned event
      final unsignedEvent = EventBuilder()
          .pubkey(pubkey)
          .kind(27235)
          .content('')
          .addTags(tags)
          .build();

      // Sign event
      final signature = Schnorr.sign(unsignedEvent.id, privateKey);
      final signedEvent = NostrEvent(
        id: unsignedEvent.id,
        pubkey: unsignedEvent.pubkey,
        createdAt: unsignedEvent.createdAt,
        kind: unsignedEvent.kind,
        tags: unsignedEvent.tags,
        content: unsignedEvent.content,
        sig: signature,
      );

      // Encode as base64
      final eventJson = jsonEncode(signedEvent.toJson());
      final base64Event = base64Encode(utf8.encode(eventJson));

      return 'Nostr $base64Event';
    } catch (e) {
      throw Exception('Failed to create NIP-98 auth: $e');
    }
  }

  /// Get download URL for a file
  String getDownloadUrl(String fileHash, {String? extension}) {
    if (_config == null) {
      throw Exception('Server not discovered. Call discoverServer() first.');
    }

    final fileName = extension != null ? '$fileHash.$extension' : fileHash;
    final downloadUrl = _config!.getDownloadUrl();
    return '$downloadUrl/$fileName';
  }
}
