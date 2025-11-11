import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/nip19.dart';
import '../../../../core/services/nip07_service.dart';
import '../../../../core/services/nip46_service.dart';

enum LoginMethod {
  privateKey,
  nostrExtension,
  nostrConnect,
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  LoginMethod _selectedMethod = LoginMethod.privateKey;
  final _privateKeyController = TextEditingController();
  final _bunkerUrlController = TextEditingController();
  bool _isPrivateKeyVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _privateKeyController.dispose();
    _bunkerUrlController.dispose();
    super.dispose();
  }

  Future<void> _loginWithPrivateKey() async {
    final input = _privateKeyController.text.trim();
  final l10n = AppLocalizations.of(context)!;

    if (input.isEmpty) {
  _showError(l10n.errorEnterPrivateKey);
      return;
    }

    setState(() => _isLoading = true);

    try {
      String privateKeyHex;
      
      // Check if input is nsec format
      if (input.startsWith('nsec1')) {
        if (!Nip19.isNsec(input)) {
          _showError(l10n.errorInvalidNsec);
          setState(() => _isLoading = false);
          return;
        }
        privateKeyHex = Nip19.decodePrivateKey(input);
      } else {
        // Assume hex format
        if (input.length != 64) {
          _showError(l10n.errorPrivateKeyLength);
          setState(() => _isLoading = false);
          return;
        }
        privateKeyHex = input;
      }

      await ref.read(authProvider.notifier).savePrivateKey(privateKeyHex);

      if (!mounted) return;
      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      _showError('${l10n.errorLoginFailed}: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loginWithNostrExtension() async {
  final l10n = AppLocalizations.of(context)!;
    
    setState(() => _isLoading = true);

    try {
      // Check if extension is available
      if (!Nip07Service.isAvailable()) {
        if (!mounted) return;
        _showError(l10n.noExtensionFound);
        setState(() => _isLoading = false);
        return;
      }

      // Get public key from extension
      final publicKeyHex = await Nip07Service.getPublicKey();
      
      // For now, we'll store the public key
      // In production, all signing would go through the extension
      await ref.read(authProvider.notifier).savePrivateKey(publicKeyHex);

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.extensionConnected),
          backgroundColor: Colors.green,
        ),
      );
      
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      _showError('${l10n.errorConnectFailed}: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loginWithNostrConnect() async {
    final bunkerUrl = _bunkerUrlController.text.trim();
  final l10n = AppLocalizations.of(context)!;

    if (bunkerUrl.isEmpty) {
      _showError(l10n.errorEnterBunkerUrl);
      return;
    }

    // Basic validation
    if (!bunkerUrl.startsWith('bunker://')) {
      _showError(l10n.errorInvalidBunkerUrl);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Show dialog instructing user to approve on nsecBunker
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(l10n.waitingForApproval),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.waitingForApprovalContent),
              const SizedBox(height: 16),
              Text(l10n.stepsLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(l10n.step1),
              Text(l10n.step2),
              Text(l10n.step3),
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      );
      
      // Connect to remote signer (now with 5 minute timeout)
      await Nip46Service.connect(bunkerUrl);
      
      // Close waiting dialog
      if (!mounted) return;
      Navigator.of(context).pop();
      
      // Get public key from remote signer
      final publicKey = await Nip46Service.getPublicKey();
      
      // Store the NIP-46 session with public key
      // Note: For NIP-46, we store the public key as the identifier
      // The actual signing happens remotely via the bunker
      await ref.read(authProvider.notifier).savePrivateKey(publicKey);

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.nostrConnectConnectedWithKey(l10n.nostrConnectConnected, '${publicKey.substring(0, 16)}...')),
          backgroundColor: Colors.green,
        ),
      );
      
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      context.go('/dashboard');
    } on ArgumentError catch (e) {
      // Close waiting dialog if open
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      if (!mounted) return;
      _showError('${l10n.errorInvalidBunkerUrl}: ${e.message}');
    } on TimeoutException {
      // Close waiting dialog if open
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      if (!mounted) return;
      _showError(
        'Connection timeout.\n'
        'Did you approve the connection on your nsecBunker/Amber app?'
        'Note: This is a prototype - events are unsigned and rejected by relays.\n'
        'Requires secp256k1 implementation for production use.',
      );
    } on UnimplementedError catch (e) {
      // Close waiting dialog if open
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      if (!mounted) return;
      _showError(e.message ?? 'Feature not yet implemented');
    } catch (e) {
      // Close waiting dialog if open
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      if (!mounted) return;
      final errorMsg = e.toString();
      
      // Show user-friendly error based on error type
      String displayError;
      
      if (errorMsg.contains('All relays disconnected') || 
          errorMsg.contains('Root Cause')) {
        // Crypto limitation error
        displayError = '''
🔒 NIP-46 Requires Cryptography

This is a PROTOTYPE - infrastructure works but needs:
✗ secp256k1 keypair generation
✗ Schnorr event signatures  
✗ NIP-44 ECDH encryption

Real relays reject unsigned events.

Status: Protocol implementation complete ✓
Next: Add native cryptography library
''';
      } else if (errorMsg.contains('disconnected')) {
        displayError = 'Relay disconnected - unsigned events rejected.\n'
            'NIP-46 requires secp256k1 signatures.';
      } else {
    displayError = '${l10n.errorConnectFailed}: $e';
      }
      
      _showError(displayError);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.signIn ?? 'Sign In'),
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
                // Welcome back text
                Text(
                  l10n?.welcomeBack ?? 'Welcome Back!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n?.chooseSignInMethod ?? 'Choose your preferred sign-in method',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Login Method Cards
                _buildMethodCard(
                  method: LoginMethod.privateKey,
                  icon: Icons.key,
                  title: l10n?.privateKeyOrNsec ?? 'Private Key / nsec',
                  description: l10n?.privateKeyDescription ?? 
                      'Direct key input (not recommended for daily use)',
                  badge: l10n?.notRecommended ?? 'Not Recommended for Regular Use',
                  badgeColor: theme.colorScheme.errorContainer,
                  theme: theme,
                ),
                const SizedBox(height: 16),

                _buildMethodCard(
                  method: LoginMethod.nostrExtension,
                  icon: Icons.extension,
                  title: l10n?.nostrExtension ?? 'Nostr Extension (NIP-07)',
                  description: l10n?.nostrExtensionDescription ?? 
                      'Use browser extension for secure signing',
                  badge: l10n?.secure ?? 'SECURE',
                  badgeColor: theme.colorScheme.primaryContainer,
                  theme: theme,
                ),
                const SizedBox(height: 16),

                _buildMethodCard(
                  method: LoginMethod.nostrConnect,
                  icon: Icons.hardware,
                  title: l10n?.nostrConnect ?? 'Nostr Connect (NIP-46)',
                  description: l10n?.nostrConnectDescription ?? 
                      'Remote signer or hardware wallet',
                  badge: l10n?.secure ?? 'SECURE',
                  badgeColor: theme.colorScheme.primaryContainer,
                  theme: theme,
                ),
                const SizedBox(height: 32),

                // Login Form based on selected method
                if (_selectedMethod == LoginMethod.privateKey)
                  _buildPrivateKeyForm(theme, l10n),
                if (_selectedMethod == LoginMethod.nostrExtension)
                  _buildNostrExtensionForm(theme, l10n),
                if (_selectedMethod == LoginMethod.nostrConnect)
                  _buildNostrConnectForm(theme, l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodCard({
    required LoginMethod method,
    required IconData icon,
    required String title,
    required String description,
    required String badge,
    required Color badgeColor,
    required ThemeData theme,
  }) {
    final isSelected = _selectedMethod == method;
    
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected 
          ? theme.colorScheme.primaryContainer.withAlpha((0.3 * 255).round())
          : null,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMethod = method;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Radio indicator
              const SizedBox(width: 8),
              Radio<LoginMethod>(
                value: method,
                groupValue: _selectedMethod,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedMethod = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivateKeyForm(ThemeData theme, AppLocalizations? l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _privateKeyController,
              obscureText: !_isPrivateKeyVisible,
              decoration: InputDecoration(
                labelText: l10n?.privateKey ?? 'Private Key',
                hintText: l10n?.enterPrivateKey ?? 'Enter your 64-character hex key or nsec1...',
                prefixIcon: const Icon(Icons.key),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPrivateKeyVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPrivateKeyVisible = !_isPrivateKeyVisible;
                    });
                  },
                ),
              ),
              maxLines: 1,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isLoading ? null : _loginWithPrivateKey,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.login),
              label: Text(_isLoading 
                  ? (l10n?.signingIn ?? 'Signing In...') 
                  : (l10n?.signIn ?? 'Sign In')),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNostrExtensionForm(ThemeData theme, AppLocalizations? l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.extension,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n?.connectWithExtension ?? 'Connect with Nostr Extension',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n?.extensionDescription ?? 
                  'This will use your browser extension (NIP-07) for secure key management.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              l10n?.supportedExtensions ?? 'Supported Extensions:',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildExtensionChip('nos2x', theme),
                _buildExtensionChip('Alby', theme),
                _buildExtensionChip('Flamingo', theme),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isLoading ? null : _loginWithNostrExtension,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.power),
              label: Text(_isLoading 
                  ? (l10n?.connecting ?? 'Connecting...') 
                  : (l10n?.connectExtension ?? 'Connect Extension')),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNostrConnectForm(ThemeData theme, AppLocalizations? l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.hardware,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n?.connectWithNostrConnect ?? 'Connect with Nostr Connect',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n?.nostrConnectFullDescription ?? 
                  'Use a remote signer or hardware wallet (NIP-46) for maximum security.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _bunkerUrlController,
              decoration: InputDecoration(
                labelText: l10n?.bunkerUrl ?? 'Bunker URL',
                hintText: l10n?.bunkerUrlHint ?? 'bunker://pubkey...',
                prefixIcon: const Icon(Icons.link),
              ),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isLoading ? null : _loginWithNostrConnect,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.power),
              label: Text(_isLoading 
                  ? (l10n?.connecting ?? 'Connecting...') 
                  : (l10n?.connect ?? 'Connect')),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtensionChip(String name, ThemeData theme) {
    return Chip(
      label: Text(name),
      avatar: const Icon(Icons.extension, size: 16),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
    );
  }
}
