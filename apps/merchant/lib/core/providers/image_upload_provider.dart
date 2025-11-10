import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/nip96_service.dart';
import 'media_server_provider.dart';

/// Provider for NIP-96 image upload service
/// Uses the configured media server URL
final nip96ServiceProvider = Provider<NIP96Service>((ref) {
  final mediaServer = ref.watch(mediaServerProvider);
  return NIP96Service(serverUrl: mediaServer.serverUrl);
});
