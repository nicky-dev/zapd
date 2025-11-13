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
  String get changeLanguage => 'Change language';

  @override
  String get english => 'English';

  @override
  String get thai => 'ไทย';

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
  String get acceptsOrdersDescription => 'Allow customers to place orders';

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
  String get comingSoon => 'Coming soon...';

  @override
  String get stallDuplicatedSuccess => 'Stall duplicated successfully';

  @override
  String get stallDeleted => 'Stall deleted';

  @override
  String get deleteStallTitle => 'Delete Stall';

  @override
  String deleteStallConfirm(Object stallName) {
    return 'Are you sure you want to delete \"$stallName\"?';
  }

  @override
  String get open => 'Open';

  @override
  String get closed => 'Closed';

  @override
  String get edit => 'Edit';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get products => 'Products';

  @override
  String get importAndContinue => 'Import & Continue';

  @override
  String get pleaseEnterPrivateKey => 'Please enter a private key';

  @override
  String get analyticsSubtitle => 'View sales and performance metrics';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get nostrAuthentication => 'Nostr Authentication';

  @override
  String get shop => 'Shop';

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
  String get searchPlace => 'Search place';

  @override
  String get useCurrentLocation => 'Use current location';

  @override
  String get noLocationSelected => 'No location selected';

  @override
  String get pickLocation => 'Pick location';

  @override
  String get select => 'Select';

  @override
  String get currentLocation => 'Current location';

  @override
  String get estimatedSats => 'Estimated';

  @override
  String get lightningInvoice => 'Lightning Invoice';

  @override
  String get tapToCopy => 'Tap to copy';

  @override
  String get copiedInvoice => 'Invoice copied to clipboard';

  @override
  String get merchantNotAuthenticated => 'Merchant not authenticated';

  @override
  String get orderTotalNotAvailable => 'Order total not available';

  @override
  String get lightningLabel => '⚡ Lightning';

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
  String get nip96Tag => 'NIP-96';

  @override
  String get legacyTag => 'Legacy';

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
  String get pleaseEnterStallName => 'Please enter stall name';

  @override
  String get stallCreatedSuccessfully => 'Stall created successfully';

  @override
  String get stallUpdatedSuccessfully => 'Stall updated successfully';

  @override
  String get pleaseAddShippingZone => 'Please add at least one shipping zone';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get orderLabel => 'Order';

  @override
  String get unknownStall => 'Unknown Stall';

  @override
  String get readyPrefix => 'Ready:';

  @override
  String get reject => 'Reject';

  @override
  String get accept => 'Accept';

  @override
  String get startPreparing => 'Start Preparing';

  @override
  String get markAsReady => 'Mark as Ready';

  @override
  String get assignRider => 'Assign Rider';

  @override
  String get privateKeyNotAvailable => 'Private key not available';

  @override
  String get orderAccepted => 'Order accepted';

  @override
  String get orderRejected => 'Order rejected';

  @override
  String get orderBeingPrepared => 'Order is being prepared';

  @override
  String get orderReadyForPickup => 'Order is ready for pickup';

  @override
  String get rejectOrderTitle => 'Reject Order';

  @override
  String get rejectOrderConfirm =>
      'Are you sure you want to reject this order?';

  @override
  String get riderAssignmentComingSoon => 'Rider assignment - Coming soon...';

  @override
  String get decryptingOrderDetails => 'Decrypting order details...';

  @override
  String get decryptDetails => 'Decrypt Details';

  @override
  String get orderDetailsEncrypted => 'Order details are encrypted';

  @override
  String get customerInformation => 'Customer Information';

  @override
  String get updateOrderStatus => 'Update Order Status';

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
  String get nameLabel => 'Name';

  @override
  String get nostrPubkeyLabel => 'Nostr Pubkey';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get emailLabel => 'Email';

  @override
  String get addressLabel => 'Address';

  @override
  String get messageLabel => 'Message:';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get shipping => 'Shipping';

  @override
  String get discount => 'Discount';

  @override
  String get totalLabel => 'Total';

  @override
  String get paymentHashLabel => 'Payment Hash';

  @override
  String get paymentProofLabel => 'Payment Proof';

  @override
  String get updatedLabel => 'Updated';

  @override
  String get estimatedReadyLabel => 'Estimated Ready';

  @override
  String get updatingOrderStatus => 'Updating order status...';

  @override
  String orderStatusUpdated(Object status) {
    return 'Order status updated to $status';
  }

  @override
  String failedToUpdateStatus(Object error) {
    return 'Failed to update status: $error';
  }

  @override
  String get actionCannotBeUndone => 'This action cannot be undone.';

  @override
  String notificationOrderTapped(Object orderId) {
    return 'Order $orderId';
  }

  @override
  String get currencySymbol => '฿';

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

  @override
  String get receiptsTitle => 'Receipts';

  @override
  String get receiptsView => 'View';

  @override
  String get receiptsCopyId => 'Copy ID';

  @override
  String get receiptsAmountPrefix => 'Amount:';

  @override
  String receiptDetailTitle(Object id) {
    return 'Receipt: $id';
  }

  @override
  String get receiptLabelTitle => 'Title';

  @override
  String get receiptLabelDate => 'Date';

  @override
  String get receiptLabelAmount => 'Amount';

  @override
  String get receiptLabelItems => 'Items';

  @override
  String get receiptCopied => 'Receipt id copied to clipboard';

  @override
  String get waitingForApproval => '⏳ Waiting for Approval';

  @override
  String get waitingForApprovalContent =>
      'Please approve this connection on your nsecBunker or Amber app.';

  @override
  String get stepsLabel => 'Steps:';

  @override
  String get step1 => '1. Open your nsecBunker/Amber app';

  @override
  String get step2 => '2. You should see a connection request';

  @override
  String get step3 => '3. Approve the request';

  @override
  String deleteProductConfirm(Object productName) {
    return 'Are you sure you want to delete \"$productName\"?';
  }

  @override
  String get productDeletedSuccessfully => 'Product deleted successfully';

  @override
  String failedToDeleteProduct(Object error) {
    return 'Failed to delete product: $error';
  }

  @override
  String get productCreated => 'Product created successfully';

  @override
  String get productUpdated => 'Product updated successfully';

  @override
  String get imageUploadedSuccessfully => 'Image uploaded successfully';

  @override
  String failedToUploadImage(Object error) {
    return 'Failed to upload image: $error';
  }

  @override
  String get noImagesAdded => 'No images added';

  @override
  String get uploading => 'Uploading...';

  @override
  String get addCategory => 'Add Category';

  @override
  String get addSpecification => 'Add Specification';

  @override
  String get noCategoriesAdded => 'No categories added';

  @override
  String get noSpecsAdded => 'No specs added';

  @override
  String get addShippingOverride => 'Add Shipping Override';

  @override
  String get noShippingOverrides => 'No shipping overrides';

  @override
  String get imageUploadServerTitle => 'Image Upload Server';

  @override
  String get mediaServerSettingsTitle => 'Media Server Settings';

  @override
  String get selectMediaServerDescription =>
      'Select a media server for uploading product images:';

  @override
  String mediaServerChangedTo(Object name) {
    return 'Media server changed to $name';
  }

  @override
  String get customServerTitle => 'Custom Server';

  @override
  String get copyNsec => 'Copy nsec';

  @override
  String get pleaseFillAllFields => 'Please fill in all fields';

  @override
  String get invalidUrlFormat => 'Invalid URL format';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get debugRunnerLabel => 'Debug runner - minimal app';

  @override
  String zoneLabel(Object id) {
    return 'Zone: $id';
  }

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'Describe your stall, menu, or policies';

  @override
  String get stallTypeLabel => 'Stall Type';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get currencyHint => 'e.g., THB';

  @override
  String get prepTimeLabel => 'Preparation Time (mins)';

  @override
  String get foodDetailsLabel => 'Food Details';

  @override
  String get cuisineTypeLabel => 'Cuisine';

  @override
  String get cuisineHint => 'e.g., Thai, Italian';

  @override
  String get operatingHoursLabel => 'Operating Hours';

  @override
  String get operatingHoursHint => 'e.g., 09:00-22:00';

  @override
  String get shippingZonesLabel => 'Shipping Zones';

  @override
  String get shippingZonesDescription => 'Define delivery zones and costs';

  @override
  String get costLabel => 'Cost';

  @override
  String get regionsLabel => 'Regions';

  @override
  String get allRegions => 'All regions';

  @override
  String get updateStall => 'Update Stall';

  @override
  String extraCostLabel(Object cost) {
    return 'Extra cost: $cost';
  }

  @override
  String get availableForOrder => 'Available for Order';

  @override
  String get availableForOrderSubtitle => 'Customers can order this product';

  @override
  String get createProduct => 'Create Product';

  @override
  String get productImages => 'Product Images';

  @override
  String get uploadImagesDescription =>
      'Upload images to showcase your product';

  @override
  String get categories => 'Categories';

  @override
  String get availability => 'Availability';

  @override
  String get editSpecification => 'Edit Specification';

  @override
  String get editShippingOverride => 'Edit Shipping Override';

  @override
  String get add => 'Add';

  @override
  String get categoryName => 'Category Name';

  @override
  String get categoryHint => 'e.g., Main Course, Dessert';

  @override
  String get privateKeyHexLabel => 'Private Key (hex)';

  @override
  String get privateKeyHexHint => 'Enter your 64-character private key';

  @override
  String get serverNameLabel => 'Server Name';

  @override
  String get serverNameHint => 'e.g., My Server';

  @override
  String get uploadUrlLabel => 'Upload URL';

  @override
  String get uploadUrlHint => 'https://example.com/upload';

  @override
  String get editShippingZone => 'Edit Shipping Zone';

  @override
  String get zoneIdLabel => 'Zone ID *';

  @override
  String get zoneIdHint => 'zone_1';

  @override
  String get zoneNameLabel => 'Zone Name';

  @override
  String get zoneNameHint => 'e.g., Local Delivery, Express';

  @override
  String get shippingCostLabel => 'Shipping Cost *';

  @override
  String get shippingCostHint => '30.00';

  @override
  String get regionsHint => 'region1, region2, region3';

  @override
  String get regionsHelper => 'Comma-separated list (optional)';

  @override
  String get noShippingZonesAdded => 'No shipping zones added';

  @override
  String get requiredLabel => 'Required';

  @override
  String get nostrInfoDescription =>
      'ZapD uses Nostr protocol for secure, decentralized authentication. Your private key is your identity - keep it safe!';

  @override
  String get neverSharePrivateKeyWarning =>
      'Never share your private key. Store it securely. Loss of private key means loss of access!';

  @override
  String get productNameLabel => 'Product Name *';

  @override
  String get productNameHint => 'e.g., Pad Thai';

  @override
  String get pleaseEnterProductName => 'Please enter product name';

  @override
  String get priceLabel => 'Price *';

  @override
  String get invalidLabel => 'Invalid';

  @override
  String get quantityHint => 'Leave empty for unlimited';

  @override
  String get spicyLevelLabel => 'Spicy Level (0-5)';

  @override
  String get dailyLimitLabel => 'Daily Limit';

  @override
  String get dailyLimitHint => 'Max orders per day';

  @override
  String get productSpecificationsHeader => 'Product Specifications (NIP-15)';

  @override
  String get specKeyLabel => 'Key *';

  @override
  String get specKeyHint => 'e.g., Size, Weight, Material';

  @override
  String get specValueLabel => 'Value *';

  @override
  String get specValueHint => 'e.g., Large, 500g, Cotton';

  @override
  String get shippingCostsHeader => 'Shipping Costs (NIP-15)';

  @override
  String get extraShippingCostsDescription => 'Extra shipping costs per zone';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String stallProductsTitle(Object stallName, Object products) {
    return '$stallName - $products';
  }

  @override
  String serverNameWithTag(Object name, Object tag) {
    return '$name ($tag)';
  }

  @override
  String get changeServer => 'Change server';

  @override
  String errorWithMessage(Object message) {
    return 'Error: $message';
  }

  @override
  String orderDetailsWithId(Object label, Object id) {
    return '$label #$id';
  }

  @override
  String confirmWithStatus(Object confirm, Object status) {
    return '$confirm? $status';
  }

  @override
  String labelWithValue(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String nostrConnectConnectedWithKey(Object message, Object pubkey) {
    return '$message\nPublic key: $pubkey';
  }
}
