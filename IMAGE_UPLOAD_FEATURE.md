# Image Upload Feature

## Overview
Product images can now be uploaded to **nostr.build**, a free decentralized image hosting service for the Nostr ecosystem.

## Implementation

### Components

1. **ImageUploadService** (`core/services/image_upload_service.dart`)
   - Handles image upload to nostr.build API v2
   - Accepts image bytes and filename
   - Returns the uploaded image URL
   - Error handling with detailed messages

2. **Product Form** (`features/products/screens/product_form_screen.dart`)
   - Image picker integration (gallery selection)
   - Image upload with progress indicator
   - Image preview in horizontal scrollable list
   - Remove image functionality
   - Image optimization (max 1920x1920, 85% quality)

### Usage in Product Form

1. **Add Image**
   - Click "Add Image" button
   - Select image from gallery
   - Image is automatically uploaded to nostr.build
   - URL is added to product's images array

2. **Remove Image**
   - Click X button on image preview
   - Image URL is removed from product

### API Integration

**Endpoint**: `https://nostr.build/api/v2/upload/files`

**Request**: Multipart form-data with file

**Response**:
```json
{
  "status": "success",
  "data": [
    {
      "url": "https://image.nostr.build/...",
      "blurhash": "...",
      "sha256": "..."
    }
  ]
}
```

### Dependencies

- `image_picker: ^1.2.0` - Cross-platform image selection
- `http: ^1.5.0` - HTTP client for API calls

### Platform Support

- ✅ Web (file picker)
- ✅ macOS (file picker)
- ✅ Windows (file picker)
- ✅ iOS (photo library/camera)
- ✅ Android (photo library/camera)

### Image Optimization

- Maximum dimensions: 1920x1920 pixels
- Image quality: 85% (balance between quality and file size)
- Format: Original format preserved (JPEG, PNG, etc.)

### Error Handling

- Network errors: Shows error message in SnackBar
- Invalid images: Handled by image_picker
- Upload failures: Displays detailed error from nostr.build
- Image loading errors: Shows broken image icon in preview

## Benefits

1. **Decentralized**: Uses Nostr ecosystem infrastructure
2. **Free**: No cost for image hosting
3. **Permanent**: Images persist on nostr.build
4. **Fast**: Direct upload to CDN
5. **Simple**: No authentication required

## Future Enhancements

- [ ] Add image cropping before upload
- [ ] Support multiple image selection
- [ ] Add image reordering (drag & drop)
- [ ] Camera capture option
- [ ] Image compression options
- [ ] Alternative hosting services (void.cat, pomf.lain.la)
