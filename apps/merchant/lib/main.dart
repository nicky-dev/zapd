import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/providers/media_server_provider.dart';
import 'features/notifications/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        mediaServerProvider.overrideWith((ref) => MediaServerNotifier(prefs)),
      ],
      child: const MerchantApp(),
    ),
  );
}
