import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// Service for uploading images to nostr.build
/// 
/// nostr.build is a free image hosting service for Nostr.
/// API Documentation: https://nostr.build/api/
class ImageUploadService {
  static const String _uploadUrl = 'https://nostr.build/api/v2/upload/files';

  /// Upload an image file to nostr.build
  /// 
  /// Returns the URL of the uploaded image on success.
  /// Throws an exception on failure.
  Future<String> uploadImage(Uint8List imageBytes, String fileName) async {
    try {
      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      
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
        // Parse the response
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        
        // nostr.build API v2 response structure:
        // {
        //   "status": "success",
        //   "data": [
        //     {
        //       "url": "https://image.nostr.build/...",
        //       "blurhash": "...",
        //       "sha256": "...",
        //       ...
        //     }
        //   ]
        // }
        
        if (jsonResponse['status'] == 'success') {
          final data = jsonResponse['data'] as List;
          if (data.isNotEmpty) {
            final firstItem = data[0] as Map<String, dynamic>;
            final imageUrl = firstItem['url'] as String;
            return imageUrl;
          }
        }
        
        throw Exception('Upload successful but no URL in response');
      } else {
        // Try to get error message from response
        String errorMessage = 'Upload failed with status: ${response.statusCode}';
        try {
          final errorJson = json.decode(response.body) as Map<String, dynamic>;
          if (errorJson['message'] != null) {
            errorMessage = errorJson['message'] as String;
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
