import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:merchant/l10n/app_localizations.dart';

void main() {
  test('AppLocalizations loads for en and th and returns values', () async {
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    final th = await AppLocalizations.delegate.load(const Locale('th'));

    // Simple getters should be non-empty
    expect(en.save, isNotEmpty);
    expect(th.save, isNotEmpty);

    // Formatted getters should incorporate arguments
    final enConfirm = en.deleteStallConfirm('Stall A');
    expect(enConfirm, contains('Stall A'));
  });
}
