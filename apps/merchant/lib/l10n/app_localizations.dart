import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'ZapD Merchant'**
  String get appTitle;

  /// Welcome page title
  ///
  /// In en, this message translates to:
  /// **'ZapD Merchant'**
  String get welcomeTitle;

  /// Welcome page subtitle
  ///
  /// In en, this message translates to:
  /// **'Decentralized Food Delivery'**
  String get welcomeSubtitle;

  /// Nostr protocol badge
  ///
  /// In en, this message translates to:
  /// **'Powered by Nostr Protocol'**
  String get poweredByNostr;

  /// Nostr protocol description
  ///
  /// In en, this message translates to:
  /// **'Your identity is secured by cryptographic keys. No passwords, no central servers.'**
  String get nostrDescription;

  /// New user section title
  ///
  /// In en, this message translates to:
  /// **'New to ZapD?'**
  String get newToZapD;

  /// Create account button
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// Existing user section title
  ///
  /// In en, this message translates to:
  /// **'Already have a Nostr key?'**
  String get alreadyHaveKey;

  /// Sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Terms agreement text
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service'**
  String get termsAgreement;

  /// Generate key page title
  ///
  /// In en, this message translates to:
  /// **'Generate Your Nostr Key'**
  String get generateKeyTitle;

  /// Generate key description
  ///
  /// In en, this message translates to:
  /// **'Your Nostr key is your identity on the decentralized network. Keep it safe and never share it with anyone.'**
  String get generateKeyDescription;

  /// Generate button
  ///
  /// In en, this message translates to:
  /// **'Generate New Key'**
  String get generateNewKey;

  /// Generating state
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get generating;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Key Generated Successfully!'**
  String get keyGeneratedSuccess;

  /// Private key label
  ///
  /// In en, this message translates to:
  /// **'Private Key'**
  String get privateKey;

  /// Private key with warning
  ///
  /// In en, this message translates to:
  /// **'Private Key (Keep Secret!)'**
  String get privateKeySecret;

  /// Public key label
  ///
  /// In en, this message translates to:
  /// **'Public Key'**
  String get publicKey;

  /// Public key with note
  ///
  /// In en, this message translates to:
  /// **'Public Key (Safe to Share)'**
  String get publicKeySafeToShare;

  /// Copy button
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Copied message
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copied;

  /// Warning title
  ///
  /// In en, this message translates to:
  /// **'Important: Save Your Private Key'**
  String get importantSaveKey;

  /// Key saving instructions
  ///
  /// In en, this message translates to:
  /// **'• Write it down on paper\n• Store it in a password manager\n• NEVER share it with anyone\n• Loss of key = Loss of account'**
  String get saveKeyInstructions;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save and Continue'**
  String get saveAndContinue;

  /// Saved state
  ///
  /// In en, this message translates to:
  /// **'Saved!'**
  String get saved;

  /// Regenerate button
  ///
  /// In en, this message translates to:
  /// **'Generate Different Key'**
  String get generateDifferentKey;

  /// Login page title
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// Login page subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred sign-in method'**
  String get chooseSignInMethod;

  /// Private key method title
  ///
  /// In en, this message translates to:
  /// **'Private Key / nsec'**
  String get privateKeyOrNsec;

  /// Private key method description
  ///
  /// In en, this message translates to:
  /// **'Direct key input (not recommended for daily use)'**
  String get privateKeyDescription;

  /// Extension method title
  ///
  /// In en, this message translates to:
  /// **'Nostr Extension (NIP-07)'**
  String get nostrExtension;

  /// Extension method description
  ///
  /// In en, this message translates to:
  /// **'Use browser extension for secure signing'**
  String get nostrExtensionDescription;

  /// Nostr Connect method title
  ///
  /// In en, this message translates to:
  /// **'Nostr Connect (NIP-46)'**
  String get nostrConnect;

  /// Nostr Connect method description
  ///
  /// In en, this message translates to:
  /// **'Remote signer or hardware wallet'**
  String get nostrConnectDescription;

  /// Secure badge
  ///
  /// In en, this message translates to:
  /// **'SECURE'**
  String get secure;

  /// Not recommended warning
  ///
  /// In en, this message translates to:
  /// **'Not Recommended for Regular Use'**
  String get notRecommended;

  /// Private key input hint
  ///
  /// In en, this message translates to:
  /// **'Enter your 64-character hex key or nsec1...'**
  String get enterPrivateKey;

  /// Signing in state
  ///
  /// In en, this message translates to:
  /// **'Signing In...'**
  String get signingIn;

  /// Extension connect title
  ///
  /// In en, this message translates to:
  /// **'Connect with Nostr Extension'**
  String get connectWithExtension;

  /// Extension description
  ///
  /// In en, this message translates to:
  /// **'This will use your browser extension (NIP-07) for secure key management.'**
  String get extensionDescription;

  /// Extensions list title
  ///
  /// In en, this message translates to:
  /// **'Supported Extensions:'**
  String get supportedExtensions;

  /// Connect extension button
  ///
  /// In en, this message translates to:
  /// **'Connect Extension'**
  String get connectExtension;

  /// Connecting state
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// Nostr Connect title
  ///
  /// In en, this message translates to:
  /// **'Connect with Nostr Connect'**
  String get connectWithNostrConnect;

  /// Nostr Connect full description
  ///
  /// In en, this message translates to:
  /// **'Use a remote signer or hardware wallet (NIP-46) for maximum security.'**
  String get nostrConnectFullDescription;

  /// Bunker URL label
  ///
  /// In en, this message translates to:
  /// **'Bunker URL'**
  String get bunkerUrl;

  /// Bunker URL hint
  ///
  /// In en, this message translates to:
  /// **'bunker://pubkey...'**
  String get bunkerUrlHint;

  /// Connect button
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Dashboard title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Show button
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// Hide button
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No extension error message
  ///
  /// In en, this message translates to:
  /// **'No Nostr extension found!\n\nPlease install one of these extensions:\n• nos2x\n• Alby\n• Flamingo'**
  String get noExtensionFound;

  /// Extension success message
  ///
  /// In en, this message translates to:
  /// **'Extension connected successfully!'**
  String get extensionConnected;

  /// OR divider text
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Error saving key message
  ///
  /// In en, this message translates to:
  /// **'Error saving key'**
  String get errorSavingKey;

  /// Invalid nsec error
  ///
  /// In en, this message translates to:
  /// **'Invalid nsec format'**
  String get errorInvalidNsec;

  /// Private key length error
  ///
  /// In en, this message translates to:
  /// **'Private key must be 64 characters (hex) or start with nsec1'**
  String get errorPrivateKeyLength;

  /// Empty private key error
  ///
  /// In en, this message translates to:
  /// **'Please enter your private key'**
  String get errorEnterPrivateKey;

  /// Login failed error
  ///
  /// In en, this message translates to:
  /// **'Failed to login'**
  String get errorLoginFailed;

  /// Connection failed error
  ///
  /// In en, this message translates to:
  /// **'Failed to connect'**
  String get errorConnectFailed;

  /// Empty bunker URL error
  ///
  /// In en, this message translates to:
  /// **'Please enter a Nostr Connect URL'**
  String get errorEnterBunkerUrl;

  /// Nostr Connect not yet implemented message
  ///
  /// In en, this message translates to:
  /// **'Nostr Connect (NIP-46) coming soon!\n\nThis will support remote signers and hardware wallets.'**
  String get nostrConnectComingSoon;

  /// Invalid bunker URL error
  ///
  /// In en, this message translates to:
  /// **'Invalid bunker URL format.\nExpected: bunker://pubkey?relay=wss://...'**
  String get errorInvalidBunkerUrl;

  /// Nostr Connect success message
  ///
  /// In en, this message translates to:
  /// **'Connected to Nostr Connect!'**
  String get nostrConnectConnected;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
