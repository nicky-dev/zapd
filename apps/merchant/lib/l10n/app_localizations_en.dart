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
  String get privateKey => 'Private Key (nsec)';

  @override
  String get privateKeySecret => 'Private Key (Keep Secret!)';

  @override
  String get publicKey => 'Public Key (npub)';

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
  String get welcomeBack => 'Welcome back! 👋';

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

  @override
  String get paymentDetails => 'Payment Details';

  @override
  String get paymentStatus => 'Payment Status';

  @override
  String get paymentStatusPending => 'Pending';

  @override
  String get paymentStatusPaid => 'Paid';

  @override
  String get paymentStatusExpired => 'Expired';

  @override
  String get paymentStatusFailed => 'Failed';

  @override
  String get amount => 'Amount';

  @override
  String get estimatedSats => 'Estimated';

  @override
  String get lightningInvoice => 'Lightning Invoice';

  @override
  String get tapToCopy => 'Tap to copy';

  @override
  String get copiedInvoice => 'Invoice copied to clipboard';

  @override
  String get paymentId => 'Payment ID';

  @override
  String get orderId => 'Order ID';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get paymentHash => 'Payment Hash';

  @override
  String get preimage => 'Preimage';

  @override
  String get createdAt => 'Created';

  @override
  String get paidAt => 'Paid At';

  @override
  String get expiresAt => 'Expires At';

  @override
  String get showQrCode => 'Show QR Code';

  @override
  String get copyInvoice => 'Copy Invoice';

  @override
  String get checkStatus => 'Check Status';

  @override
  String get scanWithWallet => 'Scan with Lightning Wallet';

  @override
  String get close => 'Close';

  @override
  String get payment => 'Payment';

  @override
  String get noPayment => 'No payment yet';

  @override
  String get generateLightningInvoice => 'Generate Lightning Invoice';

  @override
  String get viewDetails => 'View Details';

  @override
  String get notifications => 'Notifications';

  @override
  String get markAllAsRead => 'Mark All Read';

  @override
  String get clearAll => 'Clear All';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get clearAllConfirm =>
      'Are you sure you want to clear all notifications?';

  @override
  String get cancel => 'Cancel';

  @override
  String get notificationDeleted => 'Notification deleted';

  @override
  String get undo => 'Undo';

  @override
  String get notificationNewOrder => 'New Order';

  @override
  String get notificationOrderUpdate => 'Order Update';

  @override
  String get notificationPayment => 'Payment';

  @override
  String get notificationSystem => 'System';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get analytics => 'Analytics';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get totalOrders => 'Total Orders';

  @override
  String get averageOrderValue => 'Average Order Value';

  @override
  String get revenueTrend => 'Revenue Trend';

  @override
  String get orderStatusDistribution => 'Order Status Distribution';

  @override
  String get topProducts => 'Top Products';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get periodToday => 'Today';

  @override
  String get periodWeek => 'This Week';

  @override
  String get periodMonth => 'This Month';

  @override
  String get periodYear => 'This Year';

  @override
  String soldCount(int count) {
    return 'Sold: $count';
  }

  @override
  String get orders => 'Orders';

  @override
  String get selectPeriod => 'Select Period';

  @override
  String get manageYourBusiness => 'Manage your stalls, products, and orders';

  @override
  String get pendingOrders => 'Pending Orders';

  @override
  String get activeOrders => 'Active Orders';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get myStalls => 'My Stalls';

  @override
  String get manageStalls => 'Manage your food stalls';

  @override
  String get myOrders => 'My Orders';

  @override
  String get viewAndManageOrders => 'View and manage customer orders';

  @override
  String get settings => 'Settings';

  @override
  String get configureApp => 'Configure app preferences';

  @override
  String get account => 'Account';

  @override
  String get notAvailable => 'Not available';

  @override
  String get nostrRelays => 'Nostr Relays';

  @override
  String get connectionStatus => 'Connection Status';

  @override
  String get total => 'Total';

  @override
  String get connected => 'Connected';

  @override
  String get healthy => 'Healthy';

  @override
  String get relayList => 'Relay List';

  @override
  String relaysConfigured(int count) {
    return '$count relays configured';
  }

  @override
  String get mediaServer => 'Media Server';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get protocol => 'Protocol';

  @override
  String get encryption => 'Encryption';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get exportPrivateKey => 'Export Private Key';

  @override
  String get backupPrivateKey => 'Backup your private key';

  @override
  String get signOutAccount => 'Sign out from your account';

  @override
  String errorLoadingSettings(String error) {
    return 'Error loading settings: $error';
  }

  @override
  String copiedToClipboard(String label) {
    return '$label copied to clipboard';
  }

  @override
  String get noStallsYet => 'No stalls yet';

  @override
  String get createFirstStall => 'Create your first stall to get started';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get newStall => 'New Stall';

  @override
  String get chooseStallType => 'Choose Stall Type';

  @override
  String get filterByStatus => 'Filter by status';

  @override
  String get allOrders => 'All Orders';

  @override
  String get all => 'All';

  @override
  String get noOrdersYet => 'No orders yet';

  @override
  String get ordersWillAppear => 'Orders from customers will appear here';

  @override
  String get refresh => 'Refresh';

  @override
  String get products => 'Products';

  @override
  String get noProductsYet => 'No products yet';

  @override
  String get addFirstProduct => 'Add your first product to start selling';

  @override
  String get addProduct => 'Add Product';

  @override
  String get failedToLoadProducts => 'Failed to load products';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get deleteProduct => 'Delete Product';

  @override
  String get createStall => 'Create Stall';

  @override
  String get editStall => 'Edit Stall';

  @override
  String get stallName => 'Stall Name';

  @override
  String get description => 'Description';

  @override
  String get currency => 'Currency';

  @override
  String get cuisine => 'Cuisine';

  @override
  String get preparationTime => 'Preparation Time';

  @override
  String get operatingHours => 'Operating Hours';

  @override
  String get acceptsOrders => 'Accepts Orders';

  @override
  String get shippingZones => 'Shipping Zones';

  @override
  String get addShippingZone => 'Add Shipping Zone';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get productName => 'Product Name';

  @override
  String get price => 'Price';

  @override
  String get category => 'Category';

  @override
  String get inStock => 'In Stock';

  @override
  String get images => 'Images';

  @override
  String get addImage => 'Add Image';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get stallNameRequired => 'Stall Name *';

  @override
  String get stallNameHint => 'e.g., Thai Street Food';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get pleaseEnterStallName => 'Please enter a stall name';

  @override
  String get stallCreatedSuccessfully => 'Stall created successfully';

  @override
  String get stallUpdatedSuccessfully => 'Stall updated successfully';

  @override
  String get pleaseAddShippingZone => 'Please add at least one shipping zone';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get copyOrderId => 'Copy Order ID';

  @override
  String get copyCustomerPubkey => 'Copy Customer Pubkey';

  @override
  String get status => 'Status';

  @override
  String get customer => 'Customer';

  @override
  String get orderItems => 'Order Items';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get contactPhone => 'Contact Phone';

  @override
  String get specialInstructions => 'Special Instructions';

  @override
  String get none => 'None';

  @override
  String get actions => 'Actions';

  @override
  String get acceptOrder => 'Accept Order';

  @override
  String get prepareOrder => 'Prepare Order';

  @override
  String get readyForPickup => 'Ready for Pickup';

  @override
  String get completeOrder => 'Complete Order';

  @override
  String get cancelOrder => 'Cancel Order';

  @override
  String get loading => 'Loading...';

  @override
  String get authenticationRequired => 'Authentication required';

  @override
  String get failedToDecryptOrderDetails => 'Failed to decrypt order details';
}
