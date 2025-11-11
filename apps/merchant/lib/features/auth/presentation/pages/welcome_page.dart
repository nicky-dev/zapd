import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Language Switcher
            Positioned(
              top: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => ref.read(localeProvider.notifier).setLocale(const Locale('en')),
                        style: TextButton.styleFrom(
                          backgroundColor: currentLocale.languageCode == 'en'
                              ? theme.colorScheme.primaryContainer
                              : null,
                        ),
                        child: Text(l10n?.english ?? 'EN'),
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: () => ref.read(localeProvider.notifier).setLocale(const Locale('th')),
                        style: TextButton.styleFrom(
                          backgroundColor: currentLocale.languageCode == 'th'
                              ? theme.colorScheme.primaryContainer
                              : null,
                        ),
                        child: Text(l10n?.thai ?? 'TH'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          width: isMobile ? 150 : 200,
                          height: isMobile ? 150 : 200,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withAlpha((0.3 * 255).round()),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.delivery_dining,
                            size: isMobile ? 80 : 100,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Title
                      Text(
                        l10n?.welcomeTitle ?? 'ZapD Merchant',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        l10n?.welcomeSubtitle ?? 'Decentralized Food Delivery',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // Nostr Badge
                      Card(
                        color: theme.colorScheme.tertiaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.bolt,
                                    color: theme.colorScheme.onTertiaryContainer,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n?.poweredByNostr ?? 'Powered by Nostr Protocol',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onTertiaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n?.nostrDescription ?? 
                                    'Your identity is secured by cryptographic keys. '
                                    'No passwords, no central servers.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onTertiaryContainer
                                      .withAlpha((0.8 * 255).round()),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // New User Section
                      Text(
                        l10n?.newToZapD ?? 'New to ZapD?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => context.go('/auth/register'),
                        icon: const Icon(Icons.person_add),
                        label: Text(l10n?.createNewAccount ?? 'Create New Account'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Divider with OR
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              l10n?.or ?? 'OR',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withAlpha((0.5 * 255).round()),
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Existing User Section
                      Text(
                        l10n?.alreadyHaveKey ?? 'Already have a Nostr key?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => context.go('/auth/login'),
                        icon: const Icon(Icons.login),
                        label: Text(l10n?.signIn ?? 'Sign In'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Terms
                      Text(
                        l10n?.termsAgreement ?? 
                            'By continuing, you agree to our Terms of Service',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha((0.5 * 255).round()),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
