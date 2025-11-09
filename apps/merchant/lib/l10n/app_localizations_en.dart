// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ZapD Merchant';

  @override
  String get welcomeTitle => 'ZapD Merchant';

  @override
  String get welcomeSubtitle => 'Decentralized Food Delivery';

  @override
  String get poweredByNostr => 'Powered by Nostr Protocol';

  @override
  String get nostrDescription =>
      'Your identity is secured by cryptographic keys. No passwords, no central servers.';

  @override
  String get newToZapD => 'New to ZapD?';

  @override
  String get createNewAccount => 'Create New Account';

  @override
  String get alreadyHaveKey => 'Already have a Nostr key?';

  @override
  String get signIn => 'Sign In';

  @override
  String get termsAgreement =>
      'By continuing, you agree to our Terms of Service';

  @override
  String get generateKeyTitle => 'Generate Your Nostr Key';

  @override
  String get generateKeyDescription =>
      'Your Nostr key is your identity on the decentralized network. Keep it safe and never share it with anyone.';

  @override
  String get generateNewKey => 'Generate New Key';

  @override
  String get generating => 'Generating...';

  @override
  String get keyGeneratedSuccess => 'Key Generated Successfully!';

  @override
  String get privateKey => 'Private Key';

  @override
  String get privateKeySecret => 'Private Key (Keep Secret!)';

  @override
  String get publicKey => 'Public Key';

  @override
  String get publicKeySafeToShare => 'Public Key (Safe to Share)';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied to clipboard';

  @override
  String get importantSaveKey => 'Important: Save Your Private Key';

  @override
  String get saveKeyInstructions =>
      '• Write it down on paper\n• Store it in a password manager\n• NEVER share it with anyone\n• Loss of key = Loss of account';

  @override
  String get saveAndContinue => 'Save and Continue';

  @override
  String get saved => 'Saved!';

  @override
  String get generateDifferentKey => 'Generate Different Key';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get chooseSignInMethod => 'Choose your preferred sign-in method';

  @override
  String get privateKeyOrNsec => 'Private Key / nsec';

  @override
  String get privateKeyDescription =>
      'Direct key input (not recommended for daily use)';

  @override
  String get nostrExtension => 'Nostr Extension (NIP-07)';

  @override
  String get nostrExtensionDescription =>
      'Use browser extension for secure signing';

  @override
  String get nostrConnect => 'Nostr Connect (NIP-46)';

  @override
  String get nostrConnectDescription => 'Remote signer or hardware wallet';

  @override
  String get secure => 'SECURE';

  @override
  String get notRecommended => 'Not Recommended for Regular Use';

  @override
  String get enterPrivateKey => 'Enter your 64-character hex key or nsec1...';

  @override
  String get signingIn => 'Signing In...';

  @override
  String get connectWithExtension => 'Connect with Nostr Extension';

  @override
  String get extensionDescription =>
      'This will use your browser extension (NIP-07) for secure key management.';

  @override
  String get supportedExtensions => 'Supported Extensions:';

  @override
  String get connectExtension => 'Connect Extension';

  @override
  String get connecting => 'Connecting...';

  @override
  String get connectWithNostrConnect => 'Connect with Nostr Connect';

  @override
  String get nostrConnectFullDescription =>
      'Use a remote signer or hardware wallet (NIP-46) for maximum security.';

  @override
  String get bunkerUrl => 'Bunker URL';

  @override
  String get bunkerUrlHint => 'bunker://pubkey...';

  @override
  String get connect => 'Connect';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get logout => 'Logout';

  @override
  String get show => 'Show';

  @override
  String get hide => 'Hide';

  @override
  String get noExtensionFound =>
      'No Nostr extension found!\n\nPlease install one of these extensions:\n• nos2x\n• Alby\n• Flamingo';

  @override
  String get extensionConnected => 'Extension connected successfully!';

  @override
  String get or => 'OR';

  @override
  String get errorSavingKey => 'Error saving key';

  @override
  String get errorInvalidNsec => 'Invalid nsec format';

  @override
  String get errorPrivateKeyLength =>
      'Private key must be 64 characters (hex) or start with nsec1';

  @override
  String get errorEnterPrivateKey => 'Please enter your private key';

  @override
  String get errorLoginFailed => 'Failed to login';

  @override
  String get errorConnectFailed => 'Failed to connect';

  @override
  String get errorEnterBunkerUrl => 'Please enter a Nostr Connect URL';

  @override
  String get nostrConnectComingSoon =>
      'Nostr Connect (NIP-46) coming soon!\n\nThis will support remote signers and hardware wallets.';

  @override
  String get errorInvalidBunkerUrl =>
      'Invalid bunker URL format.\nExpected: bunker://pubkey?relay=wss://...';

  @override
  String get nostrConnectConnected => 'Connected to Nostr Connect!';
}
