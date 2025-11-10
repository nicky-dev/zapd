import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// Service for uploading images to Nostr media servers
/// 
/// Supports multiple media servers including nostr.build, void.cat, etc.
/// API Documentation: https://nostr.build/api/
class ImageUploadService {
  final String uploadUrl;

  ImageUploadService({required this.uploadUrl});

  /// Upload an image file to the configured media server
  /// 
  /// Returns the URL of the uploaded image on success.
  /// Throws an exception on failure.
  Future<String> uploadImage(Uint8List imageBytes, String fileName) async {
    try {
      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      
      // Add the image file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: fileName,
        ),
      );

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Try to parse as JSON first (nostr.build, void.cat format)
        try {
          final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
          
          // nostr.build format
          if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
            final data = jsonResponse['data'] as List;
            if (data.isNotEmpty) {
              final firstItem = data[0] as Map<String, dynamic>;
              final imageUrl = firstItem['url'] as String;
              return imageUrl;
            }
          }
          
          // void.cat format
          if (jsonResponse['file'] != null) {
            final file = jsonResponse['file'] as Map<String, dynamic>;
            if (file['url'] != null) {
              return file['url'] as String;
            }
          }
          
          // Generic format - look for 'url' field
          if (jsonResponse['url'] != null) {
            return jsonResponse['url'] as String;
          }
          
          throw Exception('Upload successful but no URL in response');
        } catch (e) {
          // If not JSON, response body might be the URL directly
          final body = response.body.trim();
          if (body.startsWith('http://') || body.startsWith('https://')) {
            return body;
          }
          rethrow;
        }
      } else {
        // Try to get error message from response
        String errorMessage = 'Upload failed with status: ${response.statusCode}';
        try {
          final errorJson = json.decode(response.body) as Map<String, dynamic>;
          if (errorJson['message'] != null) {
            errorMessage = errorJson['message'] as String;
          } else if (errorJson['error'] != null) {
            errorMessage = errorJson['error'] as String;
          }
        } catch (_) {
          // Use default error message
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to upload image: $e');
    }
  }
}
