# Image Upload Feature (NIP-96)

## Overview
Product images are uploaded using **NIP-96 HTTP File Storage Integration**, the official Nostr standard for file uploads. The merchant app supports multiple NIP-96 compliant servers with **nostr.build as the default**.

## NIP-96 Specification

This implementation follows [NIP-96](https://github.com/nostr-protocol/nips/blob/master/96.md), which defines:
- Server discovery via `/.well-known/nostr/nip96.json`
- NIP-98 authentication (kind 27235 events)
- Standardized upload/download/delete endpoints
- NIP-94 file metadata events
- Media transformations and plans

## Implementation

### Components

1. **NIP96Service** (`core/services/nip96_service.dart`)
   - Full NIP-96 protocol implementation
   - Server discovery from `.well-known/nostr/nip96.json`
   - NIP-98 HTTP authentication (kind 27235)
   - File upload with SHA-256 payload hash
   - File deletion support
   - NIP-94 metadata parsing

2. **NIP96 Models** (`core/models/nip96_models.dart`)
   - `NIP96ServerConfig`: Server configuration
   - `NIP96Plan`: Server plan details (free, paid)
   - `NIP96UploadResponse`: Upload response wrapper
   - `NIP94Event`: File metadata event (kind 1063)
   - `NIP96Servers`: Well-known server list

3. **MediaServerProvider** (`core/providers/media_server_provider.dart`)
   - NIP-96 server management
   - Persists settings via SharedPreferences
   - Default: nostr.build (NIP-96)
   - Predefined servers: nostr.build, void.cat, nostrcheck.me
   - Custom server support

4. **Product Form** (`features/products/screens/product_form_screen.dart`)
   - NIP-96 upload integration
   - NIP-98 authentication with user's private key
   - Image picker (gallery selection)
   - Upload progress indicator
   - Image preview with remove function
   - Image optimization (max 1920x1920, 85% quality)

5. **Settings Screen** (`features/settings/screens/settings_screen.dart`)
   - Media Server configuration section
   - Shows server name, URL, and NIP-96 status
   - Select from predefined NIP-96 servers
   - Add custom NIP-96 servers
   - Validation and error handling

### NIP-96 Upload Flow

1. **Server Discovery**
   - Fetch `{serverUrl}/.well-known/nostr/nip96.json`
   - Parse server configuration (api_url, plans, limits)
   - Cache configuration for subsequent uploads

2. **File Preparation**
   - Calculate SHA-256 hash of file bytes
   - Prepare multipart/form-data request
   - Add optional metadata (caption, alt, media_type)

3. **NIP-98 Authentication**
   - Create kind 27235 event with:
     - `u` tag: upload URL
     - `method` tag: "POST"
     - `payload` tag: file SHA-256 hash
   - Sign event with user's private key
   - Base64 encode and add as `Authorization: Nostr <base64>` header

4. **Upload Request**
   - POST to server's `api_url`
   - Include Authorization header
   - Send file with metadata

5. **Response Handling**
   - Parse NIP-96 response
   - Extract NIP-94 event with file metadata
   - Get download URL from `url` tag
   - Store original hash (`ox` tag) for future operations

### Usage in Product Form

1. **Add Image**
   - Click "Add Image" button
   - Select image from gallery
   - Image automatically uploaded via NIP-96
   - URL added to product's images array

2. **Remove Image**
   - Click X button on image preview
   - Image URL removed from product

### Media Server Settings

1. **View Current Server**
   - Open Settings → Media Server
   - See server name, URL, and NIP-96 status

2. **Change Server**
   - Click settings icon
   - Select from predefined servers:
     - nostr.build (NIP-96) - Free, reliable
     - void.cat (NIP-96) - Alternative
     - nostrcheck.me (NIP-96) - Community server

3. **Add Custom Server**
   - Click "Custom Server"
   - Enter server base URL (e.g., `https://myserver.com`)
   - Enter server name
   - System will discover NIP-96 config automatically

### Supported NIP-96 Servers

#### 1. nostr.build (Default)
- **URL**: `https://nostr.build`
- **NIP-96**: ✅ Full support
- **Features**: Free uploads, CDN, media transformations
- **Discovery**: `https://nostr.build/.well-known/nostr/nip96.json`

#### 2. void.cat
- **URL**: `https://void.cat`
- **NIP-96**: ✅ Full support
- **Features**: Free uploads, open source
- **Discovery**: `https://void.cat/.well-known/nostr/nip96.json`

#### 3. nostrcheck.me
- **URL**: `https://nostrcheck.me`
- **NIP-96**: ✅ Full support
- **Features**: Community-run server
- **Discovery**: `https://nostrcheck.me/.well-known/nostr/nip96.json`

### NIP-96 Response Format

```json
{
  "status": "success",
  "message": "Upload successful.",
  "nip94_event": {
    "tags": [
      ["url", "https://nostr.build/av/12345.png"],
      ["ox", "719171db19525d9d08dd69cb716a18158a249b7b3b3ec4bbdec5698dca104b7b"],
      ["x", "543244319525d9d08dd69cb716a18158a249b7b3b3ec4bbde5435543acb34443"],
      ["m", "image/png"],
      ["dim", "800x600"],
      ["size", "123456"]
    ],
    "content": ""
  }
}
```

### NIP-94 Metadata Tags

- `url`: Download URL
- `ox`: Original file SHA-256 hash (before transformations)
- `x`: Transformed file SHA-256 hash (after server processing)
- `m`: MIME type
- `dim`: Dimensions (e.g., "800x600")
- `size`: File size in bytes
- `alt`: Alternative text for accessibility
- `blurhash`: BlurHash for placeholder

### Dependencies

- `image_picker: ^1.2.0` - Cross-platform image selection
- `http: ^1.5.0` - HTTP client for NIP-96 API
- `shared_preferences: ^2.3.3` - Persist server settings
- `nostr_core` - NIP-98 auth, event signing, crypto
- `crypto: ^3.0.3` - SHA-256 hashing for payload

### Platform Support

- ✅ Web (file picker)
- ✅ macOS (file picker)
- ✅ Windows (file picker)
- ✅ iOS (photo library/camera)
- ✅ Android (photo library/camera)

### Security Features

1. **NIP-98 Authentication**
   - Every upload requires signed event
   - Proof of private key ownership
   - Prevents unauthorized uploads

2. **Payload Verification**
   - File hash included in auth event
   - Server can verify file integrity
   - Protects against tampering

3. **Private Key Protection**
   - Keys never sent to server
   - Only signatures transmitted
   - Full client-side signing

### Error Handling

- **403 Forbidden**: Authentication failed or payload hash mismatch
- **413 Payload Too Large**: File exceeds server limits
- **402 Payment Required**: Server requires payment (not implemented)
- **Network errors**: Clear error messages in SnackBar
- **Server discovery failed**: Fallback to manual configuration

## Configuration

### Add New Predefined Server

Edit `MediaServerConfig.predefinedServers` in `media_server_provider.dart`:

```dart
static const myServer = MediaServerConfig(
  serverUrl: 'https://myserver.com',
  name: 'My NIP-96 Server',
  isNIP96: true,
);

static const List<MediaServerConfig> predefinedServers = [
  nostrBuild,
  voidCat,
  nostrCheck,
  myServer, // Add here
];
```

### Server Requirements

To add a custom NIP-96 server, it must:
1. Implement `/.well-known/nostr/nip96.json` endpoint
2. Support NIP-98 authentication
3. Return NIP-94 metadata in responses
4. Follow NIP-96 upload/download/delete spec

## Benefits

✅ **Standardized**: Uses official Nostr NIP-96 protocol
✅ **Authenticated**: NIP-98 ensures only authorized uploads
✅ **Decentralized**: Choose from multiple servers
✅ **Flexible**: Add custom NIP-96 servers
✅ **Persistent**: Settings saved across sessions
✅ **Secure**: Client-side signing, no key exposure
✅ **Discoverable**: Automatic server configuration
✅ **Metadata-rich**: Full NIP-94 file information

## Future Enhancements

- [ ] Add image cropping before upload
- [ ] Support multiple image selection
- [ ] Add image reordering (drag & drop)
- [ ] Camera capture option
- [ ] Progress percentage display
- [ ] File deletion via NIP-96 DELETE
- [ ] Server health checks
- [ ] Auto-fallback to backup servers
- [ ] NIP-96 server discovery from relays
- [ ] Support NIP-96 paid plans
- [ ] Media transformations (resize, format)
- [ ] Batch upload optimization

## Implementation

### Components

1. **ImageUploadService** (`core/services/image_upload_service.dart`)
   - Dynamic upload URL based on settings
   - Supports multiple media server response formats
   - Handles nostr.build, void.cat, and custom servers
   - Error handling with detailed messages

2. **MediaServerProvider** (`core/providers/media_server_provider.dart`)
   - Manages media server configuration
   - Persists settings via SharedPreferences
   - Default: nostr.build
   - Predefined servers: nostr.build, void.cat
   - Custom server support

3. **Product Form** (`features/products/screens/product_form_screen.dart`)
   - Image picker integration (gallery selection)
   - Image upload with progress indicator
   - Image preview in horizontal scrollable list
   - Remove image functionality
   - Image optimization (max 1920x1920, 85% quality)

4. **Settings Screen** (`features/settings/screens/settings_screen.dart`)
   - Media Server section
   - Select from predefined servers
   - Add custom media server
   - Display current server name and URL

### Usage in Product Form

1. **Add Image**
   - Click "Add Image" button
   - Select image from gallery
   - Image is automatically uploaded to configured media server
   - URL is added to product's images array

2. **Remove Image**
   - Click X button on image preview
   - Image URL is removed from product

### Media Server Settings

1. **Open Settings**
   - Navigate to Settings screen
   - Find "Media Server" section

2. **Select Predefined Server**
   - Click settings icon
   - Choose from: nostr.build (default), void.cat
   - Server changes immediately

3. **Add Custom Server**
   - Click "Custom Server"
   - Enter server name
   - Enter upload URL endpoint
   - Save

### Supported Media Servers

#### 1. nostr.build (Default)
- **URL**: `https://nostr.build/api/v2/upload/files`
- **Response Format**:
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

#### 2. void.cat
- **URL**: `https://void.cat/upload`
- **Response Format**:
```json
{
  "file": {
    "url": "https://void.cat/...",
    "metadata": {...}
  }
}
```

#### 3. Custom Servers
- Any server that accepts multipart/form-data uploads
- Must return JSON with `url` field OR plain text URL
- Supported response formats:
  - `{"url": "https://..."}`
  - `{"status": "success", "data": [{"url": "..."}]}`
  - `{"file": {"url": "..."}}`
  - Plain text: `https://...`

### Dependencies

- `image_picker: ^1.2.0` - Cross-platform image selection
- `http: ^1.5.0` - HTTP client for API calls
- `shared_preferences: ^2.3.3` - Persist media server settings

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
- Upload failures: Displays detailed error from media server
- Image loading errors: Shows broken image icon in preview
- Invalid server URL: Validation before saving

## Configuration

### Default Server
```dart
MediaServerConfig.nostrBuild = MediaServerConfig(
  uploadUrl: 'https://nostr.build/api/v2/upload/files',
  name: 'nostr.build',
);
```

### Add New Predefined Server
Edit `MediaServerConfig.predefinedServers` in `media_server_provider.dart`:
```dart
static const List<MediaServerConfig> predefinedServers = [
  nostrBuild,
  voidCat,
  // Add new server here
  MediaServerConfig(
    uploadUrl: 'https://example.com/upload',
    name: 'Example Server',
  ),
];
```

## Benefits

1. **Flexible**: Choose or add custom media servers
2. **Decentralized**: Uses Nostr ecosystem infrastructure
3. **Free**: Default servers have no cost
4. **Persistent**: Settings saved across sessions
5. **Simple**: No authentication required for default servers

## Future Enhancements

- [ ] Add image cropping before upload
- [ ] Support multiple image selection
- [ ] Add image reordering (drag & drop)
- [ ] Camera capture option
- [ ] Image compression options
- [ ] More predefined servers (pomf.lain.la, blossom, etc.)
- [ ] Server health check / auto-fallback
- [ ] Upload progress percentage
- [ ] Batch upload optimization
