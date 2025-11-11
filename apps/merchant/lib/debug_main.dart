import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const _DebugApp());
}

class _DebugApp extends StatelessWidget {
  const _DebugApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(l10n?.debugRunnerLabel ?? 'Debug runner - minimal app'),
        ),
      ),
    );
  }
}
