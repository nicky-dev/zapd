import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';

/// Language switcher button for AppBar
class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context);

    return PopupMenuButton<Locale>(
      tooltip: l10n?.changeLanguage ?? 'Change language',
      onSelected: (locale) {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Row(
            children: [
              Semantics(
                label: l10n?.english ?? 'English',
                child: Text(
                  '🇬🇧',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Text(l10n?.english ?? 'English'),
              if (currentLocale.languageCode == 'en') ...[
                const Spacer(),
                const Icon(Icons.check, size: 20, color: Colors.green),
              ],
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('th'),
          child: Row(
            children: [
              Semantics(
                label: l10n?.thai ?? 'ไทย',
                child: Text(
                  '🇹🇭',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Text(l10n?.thai ?? 'ไทย'),
              if (currentLocale.languageCode == 'th') ...[
                const Spacer(),
                const Icon(Icons.check, size: 20, color: Colors.green),
              ],
            ],
          ),
        ),
      ],
      // Compact icon-only UI so the control matches AppBar IconButton spacing.
      icon: Semantics(
        button: true,
        label: l10n?.changeLanguage ?? 'Change language',
        child: Builder(builder: (context) {
          // Use the surrounding IconTheme if available (e.g., AppBar actions)
          final iconColor = IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurface;
          return Icon(
            Icons.language,
            size: 20,
            color: iconColor,
          );
        }),
      ),
    );
  }
}
