import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nostr_core/nostr_core.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/language_switcher.dart';

import '../providers/auth_provider.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _privateKeyController = TextEditingController();
  bool _isGenerating = false;
  bool _obscureKey = true;

  @override
  void dispose() {
    _privateKeyController.dispose();
    super.dispose();
  }

  Future<void> _generateNewKey() async {
    setState(() => _isGenerating = true);
    
    try {
      // Generate a new secp256k1 private key
      final keyPair = KeyPair.generate();
      _privateKeyController.text = keyPair.privateKey;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.keyGeneratedSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _importKey() async {
    final privateKey = _privateKeyController.text.trim();
    
    if (privateKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseEnterPrivateKey)),
      );
      return;
    }

    if (privateKey.length != 64) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorPrivateKeyLength)),
      );
      return;
    }

    // Save key and navigate
    await ref.read(authProvider.notifier).savePrivateKey(privateKey);
    
    if (mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        // Ensure AppBar action icons use the theme's onSurface color when
        // the AppBar itself is transparent so icons remain visible and
        // consistent across screens.
        actionsIconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        foregroundColor: theme.colorScheme.onSurface,
        actions: const [
          LanguageSwitcher(),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo/Icon
                Icon(
                  Icons.restaurant,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  AppLocalizations.of(context)!.appTitle,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.welcomeSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.nostrAuthentication,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context)!.nostrInfoDescription,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Generate Button
                FilledButton.tonalIcon(
                  onPressed: _isGenerating ? null : _generateNewKey,
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_circle_outline),
                  label: Text(_isGenerating ? AppLocalizations.of(context)!.generating : AppLocalizations.of(context)!.generateNewKey),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 16),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppLocalizations.of(context)!.or,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // Private Key Input
                TextField(
                  controller: _privateKeyController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.privateKeyHexLabel,
                    hintText: AppLocalizations.of(context)!.privateKeyHexHint,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureKey ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => _obscureKey = !_obscureKey);
                      },
                    ),
                  ),
                  obscureText: _obscureKey,
                  maxLength: 64,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]')),
                  ],
                ),
                const SizedBox(height: 16),

                // Import Button
                FilledButton.icon(
                  onPressed: _importKey,
                  icon: const Icon(Icons.login),
                  label: Text(AppLocalizations.of(context)!.importAndContinue),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 24),

                // Warning
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer.withAlpha((0.3 * 255).round()),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.error.withAlpha((0.3 * 255).round()),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: theme.colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.neverSharePrivateKeyWarning,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
