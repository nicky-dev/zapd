import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/image_upload_service.dart';

/// Provider for the image upload service
final imageUploadServiceProvider = Provider<ImageUploadService>((ref) {
  return ImageUploadService();
});
