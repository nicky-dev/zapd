import 'package:flutter/material.dart';

void main() {
  runApp(const _DebugApp());
}

class _DebugApp extends StatelessWidget {
  const _DebugApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Debug runner - minimal app'),
        ),
      ),
    );
  }
}
