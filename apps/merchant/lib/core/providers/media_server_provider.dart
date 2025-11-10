import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/nip96_models.dart';

/// Media server configuration
class MediaServerConfig {
  final String serverUrl; // Base URL for NIP-96 discovery
  final String name;
  final bool isNIP96; // Whether to use NIP-96 or legacy upload

  const MediaServerConfig({
    required this.serverUrl,
    required this.name,
    this.isNIP96 = true,
  });

  /// nostr.build with NIP-96
  static const nostrBuild = MediaServerConfig(
    serverUrl: NIP96Servers.nostrBuild,
    name: 'nostr.build',
    isNIP96: true,
  );

  /// void.cat with NIP-96
  static const voidCat = MediaServerConfig(
    serverUrl: NIP96Servers.voidCat,
    name: 'void.cat',
    isNIP96: true,
  );

  /// nostrcheck.me with NIP-96
  static const nostrCheck = MediaServerConfig(
    serverUrl: NIP96Servers.nostrCheck,
    name: 'nostrcheck.me',
    isNIP96: true,
  );

  static const List<MediaServerConfig> predefinedServers = [
    nostrBuild,
    voidCat,
    nostrCheck,
  ];
}

/// Provider for media server settings
class MediaServerNotifier extends StateNotifier<MediaServerConfig> {
  static const _key = 'media_server_url';
  static const _nameKey = 'media_server_name';
  static const _isNIP96Key = 'media_server_is_nip96';
  final SharedPreferences _prefs;

  MediaServerNotifier(this._prefs) : super(MediaServerConfig.nostrBuild) {
    _loadSettings();
  }

  void _loadSettings() {
    final url = _prefs.getString(_key);
    final name = _prefs.getString(_nameKey);
    final isNIP96 = _prefs.getBool(_isNIP96Key) ?? true;
    
    if (url != null && name != null) {
      state = MediaServerConfig(serverUrl: url, name: name, isNIP96: isNIP96);
    }
  }

  Future<void> setMediaServer(MediaServerConfig config) async {
    await _prefs.setString(_key, config.serverUrl);
    await _prefs.setString(_nameKey, config.name);
    await _prefs.setBool(_isNIP96Key, config.isNIP96);
    state = config;
  }

  Future<void> setCustomMediaServer(String url, String name, {bool isNIP96 = true}) async {
    final config = MediaServerConfig(serverUrl: url, name: name, isNIP96: isNIP96);
    await setMediaServer(config);
  }

  Future<void> resetToDefault() async {
    await setMediaServer(MediaServerConfig.nostrBuild);
  }
}

final mediaServerProvider = StateNotifierProvider<MediaServerNotifier, MediaServerConfig>((ref) {
  throw UnimplementedError('mediaServerProvider must be overridden');
});
