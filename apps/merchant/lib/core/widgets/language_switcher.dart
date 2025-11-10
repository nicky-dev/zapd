import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/locale_provider.dart';

/// Language switcher button for AppBar
class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return PopupMenuButton<Locale>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language, size: 20),
          const SizedBox(width: 4),
          Text(
            currentLocale.languageCode.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
      tooltip: 'Change language',
      onSelected: (locale) {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Row(
            children: [
              Text(
                '🇬🇧',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),
              const Text('English'),
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
              Text(
                '🇹🇭',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),
              const Text('ไทย'),
              if (currentLocale.languageCode == 'th') ...[
                const Spacer(),
                const Icon(Icons.check, size: 20, color: Colors.green),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
