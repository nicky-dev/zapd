import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nostr_core/nostr_core.dart';

import '../providers/auth_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/nip19.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  bool _isGenerating = false;
  String? _generatedPrivateKeyHex;
  String? _generatedPublicKeyHex;
  bool _isKeySaved = false;
  bool _showPrivateKey = false;

  Future<void> _generateNewKey() async {
    setState(() {
      _isGenerating = true;
    });

    // Simulate key generation delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Generate actual secp256k1 key pair
    final keyPair = KeyPair.generate();
    final privateKey = keyPair.privateKey;
    final publicKey = keyPair.publicKey;

    setState(() {
      _generatedPrivateKeyHex = privateKey;
      _generatedPublicKeyHex = publicKey;
      _isGenerating = false;
    });
  }

  Future<void> _saveAndContinue() async {
    if (_generatedPrivateKeyHex == null) return;

    try {
      await ref.read(authProvider.notifier).savePrivateKey(_generatedPrivateKeyHex!);
      
      if (!mounted) return;
      
      setState(() {
        _isKeySaved = true;
      });

      // Wait a bit to show success state
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n?.errorSavingKey ?? "Error saving key"}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n?.copied ?? 'Copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.generateKeyTitle ?? 'Generate Your Nostr Key'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/auth'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon
                Icon(
                  Icons.key,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  l10n?.generateKeyTitle ?? 'Generate Your Nostr Key',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  l10n?.generateKeyDescription ?? 'Your Nostr key is your identity on the decentralized network.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Generate Button
                if (_generatedPrivateKeyHex == null)
                  FilledButton.icon(
                    onPressed: _isGenerating ? null : _generateNewKey,
                    icon: _isGenerating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome),
                    label: Text(_isGenerating 
                        ? (l10n?.generating ?? 'Generating...') 
                        : (l10n?.generateNewKey ?? 'Generate New Key')),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 20,
                      ),
                    ),
                  ),

                // Generated Keys Display
                if (_generatedPrivateKeyHex != null) ...[
                  // Success Animation
                  Card(
                    color: theme.colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 48,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n?.keyGeneratedSuccess ?? 'Key Generated Successfully!',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Private Key Card
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.shield,
                                color: theme.colorScheme.error,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n?.privateKeySecret ?? 'Private Key (Keep Secret!)',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(_showPrivateKey ? Icons.visibility_off : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _showPrivateKey = !_showPrivateKey;
                                  });
                                },
                                tooltip: _showPrivateKey 
                                    ? (l10n?.hide ?? 'Hide') 
                                    : (l10n?.show ?? 'Show'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () => _copyToClipboard(
                                  Nip19.encodePrivateKey(_generatedPrivateKeyHex!),
                                ),
                                tooltip: l10n?.copy ?? 'Copy',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SelectableText(
                              _showPrivateKey 
                                  ? Nip19.encodePrivateKey(_generatedPrivateKeyHex!)
                                  : '••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Public Key Card
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.public,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n?.publicKeySafeToShare ?? 'Public Key (Safe to Share)',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () => _copyToClipboard(
                                  Nip19.encodePublicKey(_generatedPublicKeyHex!),
                                ),
                                tooltip: l10n?.copy ?? 'Copy',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SelectableText(
                              Nip19.encodePublicKey(_generatedPublicKeyHex!),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Warning Card
                  Card(
                    color: theme.colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: theme.colorScheme.error,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n?.importantSaveKey ?? 'Important: Save Your Private Key',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onErrorContainer,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n?.saveKeyInstructions ?? 
                                      '• Write it down on paper\n'
                                      '• Store it in a password manager\n'
                                      '• NEVER share it with anyone\n'
                                      '• Loss of key = Loss of account',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onErrorContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Continue Button
                  FilledButton.icon(
                    onPressed: _isKeySaved ? null : _saveAndContinue,
                    icon: _isKeySaved
                        ? const Icon(Icons.check)
                        : const Icon(Icons.arrow_forward),
                    label: Text(_isKeySaved 
                        ? (l10n?.saved ?? 'Saved!') 
                        : (l10n?.saveAndContinue ?? 'Save and Continue')),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Regenerate Button
                  if (!_isKeySaved)
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _generatedPrivateKeyHex = null;
                          _generatedPublicKeyHex = null;
                          _showPrivateKey = false;
                        });
                        _generateNewKey();
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n?.generateDifferentKey ?? 'Generate Different Key'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
