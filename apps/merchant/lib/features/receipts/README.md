Receipts feature (merchant)

This folder contains a small, self-contained "Receipts" feature for the merchant app.

Purpose
- Provide a simple UI displaying recent receipts for manual testing and integration.

Notes
- This feature adds files only; it does NOT modify existing app routing or other files.
- To view this screen in the running app, import and push the `ReceiptsScreen` from any existing widget, for example:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => ReceiptsScreen()),
);
```

Files
- `receipts_screen.dart` — a simple Material screen showing sample receipts.
