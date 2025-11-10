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

  /// Tooltip/label for language switcher
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Thai language name
  ///
  /// In en, this message translates to:
  /// **'ไทย'**
  String get thai;

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

  /// Subtitle explaining accepts orders
  ///
  /// In en, this message translates to:
  /// **'Allow customers to place orders'**
  String get acceptsOrdersDescription;

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
  /// **'Private Key (nsec)'**
  String get privateKey;

  /// Private key with warning
  ///
  /// In en, this message translates to:
  /// **'Private Key (Keep Secret!)'**
  String get privateKeySecret;

  /// Public key label
  ///
  /// In en, this message translates to:
  /// **'Public Key (npub)'**
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

  /// Generic coming soon label
  ///
  /// In en, this message translates to:
  /// **'Coming soon...'**
  String get comingSoon;

  /// Snackbar when stall duplication succeeds
  ///
  /// In en, this message translates to:
  /// **'Stall duplicated successfully'**
  String get stallDuplicatedSuccess;

  /// Snackbar when stall deletion succeeds
  ///
  /// In en, this message translates to:
  /// **'Stall deleted'**
  String get stallDeleted;

  /// Dialog title for deleting a stall
  ///
  /// In en, this message translates to:
  /// **'Delete Stall'**
  String get deleteStallTitle;

  /// Confirmation message when deleting a stall
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{stallName}\"?'**
  String deleteStallConfirm(Object stallName);

  /// Stall is open
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// Stall is closed
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// Edit label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Duplicate label
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// Products label
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// Import key button
  ///
  /// In en, this message translates to:
  /// **'Import & Continue'**
  String get importAndContinue;

  /// Prompt to enter private key
  ///
  /// In en, this message translates to:
  /// **'Please enter a private key'**
  String get pleaseEnterPrivateKey;

  /// Subtitle for analytics menu card
  ///
  /// In en, this message translates to:
  /// **'View sales and performance metrics'**
  String get analyticsSubtitle;

  /// Account info card title
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// Nostr auth card title
  ///
  /// In en, this message translates to:
  /// **'Nostr Authentication'**
  String get nostrAuthentication;

  /// Fallback stall type label
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shop;

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

  /// Dashboard welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome back! 👋'**
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

  /// Payment details screen title
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get paymentDetails;

  /// Payment status label
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// Payment status: pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get paymentStatusPending;

  /// Payment status: paid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paymentStatusPaid;

  /// Payment status: expired
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get paymentStatusExpired;

  /// Payment status: failed
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get paymentStatusFailed;

  /// Amount label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Estimated sats label
  ///
  /// In en, this message translates to:
  /// **'Estimated'**
  String get estimatedSats;

  /// Lightning invoice label
  ///
  /// In en, this message translates to:
  /// **'Lightning Invoice'**
  String get lightningInvoice;

  /// Tap to copy hint
  ///
  /// In en, this message translates to:
  /// **'Tap to copy'**
  String get tapToCopy;

  /// Invoice copied message
  ///
  /// In en, this message translates to:
  /// **'Invoice copied to clipboard'**
  String get copiedInvoice;

  /// Snackbar shown when merchant is not authenticated
  ///
  /// In en, this message translates to:
  /// **'Merchant not authenticated'**
  String get merchantNotAuthenticated;

  /// Snackbar shown when an order's total cannot be calculated
  ///
  /// In en, this message translates to:
  /// **'Order total not available'**
  String get orderTotalNotAvailable;

  /// Label for Lightning payment method
  ///
  /// In en, this message translates to:
  /// **'⚡ Lightning'**
  String get lightningLabel;

  /// Payment ID label
  ///
  /// In en, this message translates to:
  /// **'Payment ID'**
  String get paymentId;

  /// Order ID label
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get orderId;

  /// Payment method label
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// Payment hash label
  ///
  /// In en, this message translates to:
  /// **'Payment Hash'**
  String get paymentHash;

  /// Preimage label
  ///
  /// In en, this message translates to:
  /// **'Preimage'**
  String get preimage;

  /// Created at label
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get createdAt;

  /// Paid at label
  ///
  /// In en, this message translates to:
  /// **'Paid At'**
  String get paidAt;

  /// Expires at label
  ///
  /// In en, this message translates to:
  /// **'Expires At'**
  String get expiresAt;

  /// Show QR code button
  ///
  /// In en, this message translates to:
  /// **'Show QR Code'**
  String get showQrCode;

  /// Copy invoice button
  ///
  /// In en, this message translates to:
  /// **'Copy Invoice'**
  String get copyInvoice;

  /// Check status button
  ///
  /// In en, this message translates to:
  /// **'Check Status'**
  String get checkStatus;

  /// QR dialog title
  ///
  /// In en, this message translates to:
  /// **'Scan with Lightning Wallet'**
  String get scanWithWallet;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Payment label
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No payment message
  ///
  /// In en, this message translates to:
  /// **'No payment yet'**
  String get noPayment;

  /// Generate invoice button
  ///
  /// In en, this message translates to:
  /// **'Generate Lightning Invoice'**
  String get generateLightningInvoice;

  /// View details button
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// Notifications screen title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Mark all as read button
  ///
  /// In en, this message translates to:
  /// **'Mark All Read'**
  String get markAllAsRead;

  /// Clear all button
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// Empty notifications message
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// Clear all confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all notifications?'**
  String get clearAllConfirm;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Notification deleted message
  ///
  /// In en, this message translates to:
  /// **'Notification deleted'**
  String get notificationDeleted;

  /// Undo button
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// New order notification type
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get notificationNewOrder;

  /// Order update notification type
  ///
  /// In en, this message translates to:
  /// **'Order Update'**
  String get notificationOrderUpdate;

  /// Payment notification type
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get notificationPayment;

  /// System notification type
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get notificationSystem;

  /// Just now time label
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Minutes ago time label
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// Hours ago time label
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(int count);

  /// Days ago time label
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(int count);

  /// Analytics screen title
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// Total revenue label
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// Total orders label
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrders;

  /// Average order value label
  ///
  /// In en, this message translates to:
  /// **'Average Order Value'**
  String get averageOrderValue;

  /// Revenue trend chart title
  ///
  /// In en, this message translates to:
  /// **'Revenue Trend'**
  String get revenueTrend;

  /// Order status chart title
  ///
  /// In en, this message translates to:
  /// **'Order Status Distribution'**
  String get orderStatusDistribution;

  /// Top products section title
  ///
  /// In en, this message translates to:
  /// **'Top Products'**
  String get topProducts;

  /// No data message
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// Today period
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get periodToday;

  /// This week period
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get periodWeek;

  /// This month period
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get periodMonth;

  /// This year period
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get periodYear;

  /// Sold count label
  ///
  /// In en, this message translates to:
  /// **'Sold: {count}'**
  String soldCount(int count);

  /// Orders screen title
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// Select period label
  ///
  /// In en, this message translates to:
  /// **'Select Period'**
  String get selectPeriod;

  /// Dashboard subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your stalls, products, and orders'**
  String get manageYourBusiness;

  /// Pending orders label
  ///
  /// In en, this message translates to:
  /// **'Pending Orders'**
  String get pendingOrders;

  /// Active orders label
  ///
  /// In en, this message translates to:
  /// **'Active Orders'**
  String get activeOrders;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// My stalls menu item
  ///
  /// In en, this message translates to:
  /// **'My Stalls'**
  String get myStalls;

  /// Manage stalls description
  ///
  /// In en, this message translates to:
  /// **'Manage your food stalls'**
  String get manageStalls;

  /// My orders menu item
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// Manage orders description
  ///
  /// In en, this message translates to:
  /// **'View and manage customer orders'**
  String get viewAndManageOrders;

  /// Settings menu item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Settings description
  ///
  /// In en, this message translates to:
  /// **'Configure app preferences'**
  String get configureApp;

  /// Account section header
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Not available text
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// Nostr relays section header
  ///
  /// In en, this message translates to:
  /// **'Nostr Relays'**
  String get nostrRelays;

  /// Connection status label
  ///
  /// In en, this message translates to:
  /// **'Connection Status'**
  String get connectionStatus;

  /// Total label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Connected label
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Healthy label
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// Relay list label
  ///
  /// In en, this message translates to:
  /// **'Relay List'**
  String get relayList;

  /// Number of relays configured
  ///
  /// In en, this message translates to:
  /// **'{count} relays configured'**
  String relaysConfigured(int count);

  /// Media server section header
  ///
  /// In en, this message translates to:
  /// **'Media Server'**
  String get mediaServer;

  /// About section header
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Protocol label
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get protocol;

  /// Encryption label
  ///
  /// In en, this message translates to:
  /// **'Encryption'**
  String get encryption;

  /// Danger zone section header
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// Export private key button
  ///
  /// In en, this message translates to:
  /// **'Export Private Key'**
  String get exportPrivateKey;

  /// Backup private key description
  ///
  /// In en, this message translates to:
  /// **'Backup your private key'**
  String get backupPrivateKey;

  /// Sign out description
  ///
  /// In en, this message translates to:
  /// **'Sign out from your account'**
  String get signOutAccount;

  /// Error loading settings message
  ///
  /// In en, this message translates to:
  /// **'Error loading settings: {error}'**
  String errorLoadingSettings(String error);

  /// Copied to clipboard message
  ///
  /// In en, this message translates to:
  /// **'{label} copied to clipboard'**
  String copiedToClipboard(String label);

  /// No stalls message
  ///
  /// In en, this message translates to:
  /// **'No stalls yet'**
  String get noStallsYet;

  /// Create first stall prompt
  ///
  /// In en, this message translates to:
  /// **'Create your first stall to get started'**
  String get createFirstStall;

  /// Error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// New stall button
  ///
  /// In en, this message translates to:
  /// **'New Stall'**
  String get newStall;

  /// Choose stall type dialog title
  ///
  /// In en, this message translates to:
  /// **'Choose Stall Type'**
  String get chooseStallType;

  /// Filter by status tooltip
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get filterByStatus;

  /// All orders filter
  ///
  /// In en, this message translates to:
  /// **'All Orders'**
  String get allOrders;

  /// All label
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No orders message
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersYet;

  /// Orders will appear message
  ///
  /// In en, this message translates to:
  /// **'Orders from customers will appear here'**
  String get ordersWillAppear;

  /// Refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No products message
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get noProductsYet;

  /// Add first product prompt
  ///
  /// In en, this message translates to:
  /// **'Add your first product to start selling'**
  String get addFirstProduct;

  /// Add product button
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// Failed to load products message
  ///
  /// In en, this message translates to:
  /// **'Failed to load products'**
  String get failedToLoadProducts;

  /// Edit product button
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// Delete product button
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get deleteProduct;

  /// Create stall title
  ///
  /// In en, this message translates to:
  /// **'Create Stall'**
  String get createStall;

  /// Edit stall title
  ///
  /// In en, this message translates to:
  /// **'Edit Stall'**
  String get editStall;

  /// Stall name field
  ///
  /// In en, this message translates to:
  /// **'Stall Name'**
  String get stallName;

  /// Description field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Currency field
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// Cuisine field
  ///
  /// In en, this message translates to:
  /// **'Cuisine'**
  String get cuisine;

  /// Preparation time field
  ///
  /// In en, this message translates to:
  /// **'Preparation Time'**
  String get preparationTime;

  /// Operating hours field
  ///
  /// In en, this message translates to:
  /// **'Operating Hours'**
  String get operatingHours;

  /// Accepts orders toggle
  ///
  /// In en, this message translates to:
  /// **'Accepts Orders'**
  String get acceptsOrders;

  /// Shipping zones section
  ///
  /// In en, this message translates to:
  /// **'Shipping Zones'**
  String get shippingZones;

  /// Add shipping zone button
  ///
  /// In en, this message translates to:
  /// **'Add Shipping Zone'**
  String get addShippingZone;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Product name field
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// Price field
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Category field
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// In stock toggle
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// Images section
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// Add image button
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// Basic information section
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// Stall name required field
  ///
  /// In en, this message translates to:
  /// **'Stall Name *'**
  String get stallNameRequired;

  /// Stall name hint
  ///
  /// In en, this message translates to:
  /// **'e.g., Thai Street Food'**
  String get stallNameHint;

  /// Description optional field
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// Stall name validation
  ///
  /// In en, this message translates to:
  /// **'Please enter a stall name'**
  String get pleaseEnterStallName;

  /// Stall created message
  ///
  /// In en, this message translates to:
  /// **'Stall created successfully'**
  String get stallCreatedSuccessfully;

  /// Stall updated message
  ///
  /// In en, this message translates to:
  /// **'Stall updated successfully'**
  String get stallUpdatedSuccessfully;

  /// Shipping zone required message
  ///
  /// In en, this message translates to:
  /// **'Please add at least one shipping zone'**
  String get pleaseAddShippingZone;

  /// Order details title
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// Label used before order id, e.g. 'Order #123'
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get orderLabel;

  /// Fallback stall name when none provided
  ///
  /// In en, this message translates to:
  /// **'Unknown Stall'**
  String get unknownStall;

  /// Prefix for ready time label
  ///
  /// In en, this message translates to:
  /// **'Ready:'**
  String get readyPrefix;

  /// Reject button label
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Accept button label
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Start preparing button label
  ///
  /// In en, this message translates to:
  /// **'Start Preparing'**
  String get startPreparing;

  /// Mark order as ready button label
  ///
  /// In en, this message translates to:
  /// **'Mark as Ready'**
  String get markAsReady;

  /// Assign rider button label
  ///
  /// In en, this message translates to:
  /// **'Assign Rider'**
  String get assignRider;

  /// Shown when private key is missing
  ///
  /// In en, this message translates to:
  /// **'Private key not available'**
  String get privateKeyNotAvailable;

  /// Snackbar after accepting order
  ///
  /// In en, this message translates to:
  /// **'Order accepted'**
  String get orderAccepted;

  /// Snackbar after rejecting order
  ///
  /// In en, this message translates to:
  /// **'Order rejected'**
  String get orderRejected;

  /// Snackbar when order moved to preparing
  ///
  /// In en, this message translates to:
  /// **'Order is being prepared'**
  String get orderBeingPrepared;

  /// Snackbar when order is ready
  ///
  /// In en, this message translates to:
  /// **'Order is ready for pickup'**
  String get orderReadyForPickup;

  /// Dialog title when rejecting an order
  ///
  /// In en, this message translates to:
  /// **'Reject Order'**
  String get rejectOrderTitle;

  /// Dialog confirm text for rejecting an order
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this order?'**
  String get rejectOrderConfirm;

  /// Temporary message when rider assignment not implemented
  ///
  /// In en, this message translates to:
  /// **'Rider assignment - Coming soon...'**
  String get riderAssignmentComingSoon;

  /// Shown while order details are being decrypted
  ///
  /// In en, this message translates to:
  /// **'Decrypting order details...'**
  String get decryptingOrderDetails;

  /// Button to attempt decryption of order details
  ///
  /// In en, this message translates to:
  /// **'Decrypt Details'**
  String get decryptDetails;

  /// Shown when order details are encrypted and not available
  ///
  /// In en, this message translates to:
  /// **'Order details are encrypted'**
  String get orderDetailsEncrypted;

  /// Customer information section title
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get customerInformation;

  /// Header for update order status section
  ///
  /// In en, this message translates to:
  /// **'Update Order Status'**
  String get updateOrderStatus;

  /// Copy order ID action
  ///
  /// In en, this message translates to:
  /// **'Copy Order ID'**
  String get copyOrderId;

  /// Copy customer pubkey action
  ///
  /// In en, this message translates to:
  /// **'Copy Customer Pubkey'**
  String get copyCustomerPubkey;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Customer label
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// Order items label
  ///
  /// In en, this message translates to:
  /// **'Order Items'**
  String get orderItems;

  /// Delivery address label
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// Contact phone label
  ///
  /// In en, this message translates to:
  /// **'Contact Phone'**
  String get contactPhone;

  /// Special instructions label
  ///
  /// In en, this message translates to:
  /// **'Special Instructions'**
  String get specialInstructions;

  /// None label
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Customer name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// Nostr pubkey label
  ///
  /// In en, this message translates to:
  /// **'Nostr Pubkey'**
  String get nostrPubkeyLabel;

  /// Phone label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Address label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// Label for customer message field
  ///
  /// In en, this message translates to:
  /// **'Message:'**
  String get messageLabel;

  /// Subtotal label
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// Shipping cost label
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// Discount label
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// Total label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// Payment hash label
  ///
  /// In en, this message translates to:
  /// **'Payment Hash'**
  String get paymentHashLabel;

  /// Payment proof / preimage label
  ///
  /// In en, this message translates to:
  /// **'Payment Proof'**
  String get paymentProofLabel;

  /// Updated at label
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updatedLabel;

  /// Estimated ready time label
  ///
  /// In en, this message translates to:
  /// **'Estimated Ready'**
  String get estimatedReadyLabel;

  /// Shown while updating order status
  ///
  /// In en, this message translates to:
  /// **'Updating order status...'**
  String get updatingOrderStatus;

  /// Snackbar when order status updated
  ///
  /// In en, this message translates to:
  /// **'Order status updated to {status}'**
  String orderStatusUpdated(Object status);

  /// Snackbar when status update fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update status: {error}'**
  String failedToUpdateStatus(Object error);

  /// Dialog text warning that an action cannot be undone
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCannotBeUndone;

  /// Short message shown when tapping a notification referencing an order
  ///
  /// In en, this message translates to:
  /// **'Order {orderId}'**
  String notificationOrderTapped(Object orderId);

  /// Currency symbol used in the app
  ///
  /// In en, this message translates to:
  /// **'฿'**
  String get currencySymbol;

  /// Actions label
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// Accept order button
  ///
  /// In en, this message translates to:
  /// **'Accept Order'**
  String get acceptOrder;

  /// Prepare order button
  ///
  /// In en, this message translates to:
  /// **'Prepare Order'**
  String get prepareOrder;

  /// Ready for pickup button
  ///
  /// In en, this message translates to:
  /// **'Ready for Pickup'**
  String get readyForPickup;

  /// Complete order button
  ///
  /// In en, this message translates to:
  /// **'Complete Order'**
  String get completeOrder;

  /// Cancel order button
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Authentication required message
  ///
  /// In en, this message translates to:
  /// **'Authentication required'**
  String get authenticationRequired;

  /// Failed to decrypt message
  ///
  /// In en, this message translates to:
  /// **'Failed to decrypt order details'**
  String get failedToDecryptOrderDetails;

  /// Receipts screen title
  ///
  /// In en, this message translates to:
  /// **'Receipts'**
  String get receiptsTitle;

  /// View button label on receipts
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get receiptsView;

  /// Copy receipt id button label
  ///
  /// In en, this message translates to:
  /// **'Copy ID'**
  String get receiptsCopyId;

  /// Prefix before amount value on receipts
  ///
  /// In en, this message translates to:
  /// **'Amount:'**
  String get receiptsAmountPrefix;

  /// Dialog title for receipt detail
  ///
  /// In en, this message translates to:
  /// **'Receipt: {id}'**
  String receiptDetailTitle(Object id);

  /// Label for receipt title in detail dialog
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get receiptLabelTitle;

  /// Label for receipt date in detail dialog
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get receiptLabelDate;

  /// Label for receipt amount in detail dialog
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get receiptLabelAmount;

  /// Label for receipt items in detail dialog
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get receiptLabelItems;

  /// Snackbar message when receipt id copied
  ///
  /// In en, this message translates to:
  /// **'Receipt id copied to clipboard'**
  String get receiptCopied;
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
