// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'ZapD ร้านค้า';

  @override
  String get changeLanguage => 'เปลี่ยนภาษา';

  @override
  String get english => 'English';

  @override
  String get thai => 'ไทย';

  @override
  String get welcomeTitle => 'ZapD ร้านค้า';

  @override
  String get welcomeSubtitle => 'บริการจัดส่งอาหารแบบกระจายศูนย์';

  @override
  String get poweredByNostr => 'ขับเคลื่อนด้วย Nostr Protocol';

  @override
  String get nostrDescription =>
      'ข้อมูลของคุณปลอดภัยด้วยกุญแจเข้ารหัส ไม่มีรหัสผ่าน ไม่มีเซิร์ฟเวอร์กลาง';

  @override
  String get acceptsOrdersDescription => 'อนุญาตให้ลูกค้าสั่งซื้อสินค้า';

  @override
  String get newToZapD => 'เพิ่งมาใช้ ZapD?';

  @override
  String get createNewAccount => 'สร้างบัญชีใหม่';

  @override
  String get alreadyHaveKey => 'มีกุญแจ Nostr อยู่แล้ว?';

  @override
  String get signIn => 'เข้าสู่ระบบ';

  @override
  String get termsAgreement =>
      'การดำเนินการต่อถือว่าคุณยอมรับข้อกำหนดการใช้งาน';

  @override
  String get generateKeyTitle => 'สร้างกุญแจ Nostr ของคุณ';

  @override
  String get generateKeyDescription =>
      'กุญแจ Nostr คือตัวตนของคุณในเครือข่ายกระจายศูนย์ เก็บรักษาไว้อย่างปลอดภัยและอย่าแชร์ให้ใครเด็ดขาด';

  @override
  String get generateNewKey => 'สร้างกุญแจใหม่';

  @override
  String get generating => 'กำลังสร้าง...';

  @override
  String get keyGeneratedSuccess => 'สร้างกุญแจสำเร็จ!';

  @override
  String get privateKey => 'Private Key (nsec)';

  @override
  String get privateKeySecret => 'กุญแจส่วนตัว (เก็บเป็นความลับ!)';

  @override
  String get publicKey => 'Public Key (npub)';

  @override
  String get publicKeySafeToShare => 'กุญแจสาธารณะ (แชร์ได้)';

  @override
  String get copy => 'คัดลอก';

  @override
  String get copied => 'คัดลอกแล้ว';

  @override
  String get comingSoon => 'เร็วๆ นี้...';

  @override
  String get stallDuplicatedSuccess => 'คัดลอกแผงขายสำเร็จ';

  @override
  String get stallDeleted => 'ลบแผงขายเรียบร้อยแล้ว';

  @override
  String get deleteStallTitle => 'ลบแผงขาย';

  @override
  String deleteStallConfirm(Object stallName) {
    return 'คุณแน่ใจหรือว่าต้องการลบ \"$stallName\"?';
  }

  @override
  String get open => 'เปิด';

  @override
  String get closed => 'ปิด';

  @override
  String get edit => 'แก้ไข';

  @override
  String get duplicate => 'คัดลอก';

  @override
  String get products => 'สินค้า';

  @override
  String get importAndContinue => 'นำเข้า & ดำเนินการต่อ';

  @override
  String get pleaseEnterPrivateKey => 'กรุณากรอกกุญแจส่วนตัว';

  @override
  String get analyticsSubtitle => 'ดูยอดขายและตัวชี้วัดการทำงาน';

  @override
  String get accountInformation => 'ข้อมูลบัญชี';

  @override
  String get nostrAuthentication => 'การยืนยันด้วย Nostr';

  @override
  String get shop => 'ร้านค้า';

  @override
  String get importantSaveKey => 'สำคัญ: เก็บกุญแจส่วนตัวของคุณ';

  @override
  String get saveKeyInstructions =>
      '• เขียนลงกระดาษ\n• เก็บในโปรแกรมจัดการรหัสผ่าน\n• อย่าแชร์ให้ใคร\n• หากสูญหาย = สูญเสียบัญชี';

  @override
  String get saveAndContinue => 'บันทึกและดำเนินการต่อ';

  @override
  String get saved => 'บันทึกแล้ว!';

  @override
  String get generateDifferentKey => 'สร้างกุญแจใหม่';

  @override
  String get welcomeBack => 'ยินดีต้อนรับกลับมา! 👋';

  @override
  String get chooseSignInMethod => 'เลือกวิธีเข้าสู่ระบบที่คุณต้องการ';

  @override
  String get privateKeyOrNsec => 'กุญแจส่วนตัว / nsec';

  @override
  String get privateKeyDescription =>
      'ใส่กุญแจโดยตรง (ไม่แนะนำสำหรับใช้งานประจำ)';

  @override
  String get nostrExtension => 'ส่วนขยาย Nostr (NIP-07)';

  @override
  String get nostrExtensionDescription =>
      'ใช้ส่วนขยายเบราว์เซอร์เพื่อลงนามอย่างปลอดภัย';

  @override
  String get nostrConnect => 'Nostr Connect (NIP-46)';

  @override
  String get nostrConnectDescription => 'ตัวลงนามระยะไกลหรือกระเป๋าฮาร์ดแวร์';

  @override
  String get secure => 'ปลอดภัย';

  @override
  String get notRecommended => 'ไม่แนะนำสำหรับการใช้งานประจำ';

  @override
  String get enterPrivateKey => 'ใส่กุญแจ hex 64 ตัวอักษรหรือ nsec1...';

  @override
  String get signingIn => 'กำลังเข้าสู่ระบบ...';

  @override
  String get connectWithExtension => 'เชื่อมต่อด้วยส่วนขยาย Nostr';

  @override
  String get extensionDescription =>
      'จะใช้ส่วนขยายเบราว์เซอร์ (NIP-07) เพื่อจัดการกุญแจอย่างปลอดภัย';

  @override
  String get supportedExtensions => 'ส่วนขยายที่รองรับ:';

  @override
  String get connectExtension => 'เชื่อมต่อส่วนขยาย';

  @override
  String get connecting => 'กำลังเชื่อมต่อ...';

  @override
  String get connectWithNostrConnect => 'เชื่อมต่อด้วย Nostr Connect';

  @override
  String get nostrConnectFullDescription =>
      'ใช้ตัวลงนามระยะไกลหรือกระเป๋าฮาร์ดแวร์ (NIP-46) เพื่อความปลอดภัยสูงสุด';

  @override
  String get bunkerUrl => 'URL Bunker';

  @override
  String get bunkerUrlHint => 'bunker://pubkey...';

  @override
  String get connect => 'เชื่อมต่อ';

  @override
  String get dashboard => 'หน้าหลัก';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get show => 'แสดง';

  @override
  String get hide => 'ซ่อน';

  @override
  String get noExtensionFound =>
      'ไม่พบส่วนขยาย Nostr!\n\nกรุณาติดตั้งหนึ่งในส่วนขยายนี้:\n• nos2x\n• Alby\n• Flamingo';

  @override
  String get extensionConnected => 'เชื่อมต่อส่วนขยายสำเร็จ!';

  @override
  String get or => 'หรือ';

  @override
  String get errorSavingKey => 'เกิดข้อผิดพลาดในการบันทึกกุญแจ';

  @override
  String get errorInvalidNsec => 'รูปแบบ nsec ไม่ถูกต้อง';

  @override
  String get errorPrivateKeyLength =>
      'กุญแจส่วนตัวต้องมี 64 ตัวอักษร (hex) หรือขึ้นต้นด้วย nsec1';

  @override
  String get errorEnterPrivateKey => 'กรุณาใส่กุญแจส่วนตัวของคุณ';

  @override
  String get errorLoginFailed => 'เข้าสู่ระบบไม่สำเร็จ';

  @override
  String get errorConnectFailed => 'เชื่อมต่อไม่สำเร็จ';

  @override
  String get errorEnterBunkerUrl => 'กรุณาใส่ URL Nostr Connect';

  @override
  String get nostrConnectComingSoon =>
      'Nostr Connect (NIP-46) เร็วๆ นี้!\n\nจะรองรับตัวลงนามระยะไกลและกระเป๋าฮาร์ดแวร์';

  @override
  String get errorInvalidBunkerUrl =>
      'รูปแบบ URL bunker ไม่ถูกต้อง\nต้องเป็น: bunker://pubkey?relay=wss://...';

  @override
  String get nostrConnectConnected => 'เชื่อมต่อ Nostr Connect สำเร็จ!';

  @override
  String get paymentDetails => 'รายละเอียดการชำระเงิน';

  @override
  String get paymentStatus => 'สถานะการชำระเงิน';

  @override
  String get paymentStatusPending => 'รอดำเนินการ';

  @override
  String get paymentStatusPaid => 'ชำระแล้ว';

  @override
  String get paymentStatusExpired => 'หมดอายุ';

  @override
  String get paymentStatusFailed => 'ล้มเหลว';

  @override
  String get amount => 'จำนวนเงิน';

  @override
  String get searchPlace => 'ค้นหาสถานที่';

  @override
  String get useCurrentLocation => 'ใช้ตำแหน่งปัจจุบัน';

  @override
  String get noLocationSelected => 'ยังไม่ได้เลือกตำแหน่ง';

  @override
  String get pickLocation => 'เลือกตำแหน่ง';

  @override
  String get select => 'เลือก';

  @override
  String get currentLocation => 'ตำแหน่งปัจจุบัน';

  @override
  String get estimatedSats => 'ประมาณ';

  @override
  String get lightningInvoice => 'ใบแจ้งหนี้ Lightning';

  @override
  String get tapToCopy => 'แตะเพื่อคัดลอก';

  @override
  String get copiedInvoice => 'คัดลอกใบแจ้งหนี้แล้ว';

  @override
  String get merchantNotAuthenticated => 'ร้านค้ายังไม่ได้เข้าสู่ระบบ';

  @override
  String get orderTotalNotAvailable => 'ยอดคำสั่งซื้อไม่พร้อมใช้งาน';

  @override
  String get lightningLabel => '⚡ Lightning';

  @override
  String get paymentId => 'รหัสการชำระเงิน';

  @override
  String get orderId => 'รหัสคำสั่งซื้อ';

  @override
  String get paymentMethod => 'วิธีการชำระเงิน';

  @override
  String get paymentHash => 'Payment Hash';

  @override
  String get preimage => 'Preimage';

  @override
  String get createdAt => 'สร้างเมื่อ';

  @override
  String get paidAt => 'ชำระเมื่อ';

  @override
  String get expiresAt => 'หมดอายุเมื่อ';

  @override
  String get showQrCode => 'แสดง QR Code';

  @override
  String get copyInvoice => 'คัดลอกใบแจ้งหนี้';

  @override
  String get checkStatus => 'ตรวจสอบสถานะ';

  @override
  String get scanWithWallet => 'สแกนด้วย Lightning Wallet';

  @override
  String get close => 'ปิด';

  @override
  String get payment => 'การชำระเงิน';

  @override
  String get noPayment => 'ยังไม่มีการชำระเงิน';

  @override
  String get generateLightningInvoice => 'สร้างใบแจ้งหนี้ Lightning';

  @override
  String get viewDetails => 'ดูรายละเอียด';

  @override
  String get notifications => 'การแจ้งเตือน';

  @override
  String get markAllAsRead => 'ทำเครื่องหมายอ่านทั้งหมด';

  @override
  String get clearAll => 'ล้างทั้งหมด';

  @override
  String get noNotifications => 'ไม่มีการแจ้งเตือน';

  @override
  String get clearAllConfirm => 'คุณแน่ใจว่าต้องการล้างการแจ้งเตือนทั้งหมด?';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get notificationDeleted => 'ลบการแจ้งเตือนแล้ว';

  @override
  String get undo => 'เลิกทำ';

  @override
  String get notificationNewOrder => 'คำสั่งซื้อใหม่';

  @override
  String get notificationOrderUpdate => 'อัปเดตคำสั่งซื้อ';

  @override
  String get notificationPayment => 'การชำระเงิน';

  @override
  String get notificationSystem => 'ระบบ';

  @override
  String get justNow => 'เมื่อสักครู่';

  @override
  String minutesAgo(int count) {
    return '$count นาทีที่แล้ว';
  }

  @override
  String hoursAgo(int count) {
    return '$count ชั่วโมงที่แล้ว';
  }

  @override
  String daysAgo(int count) {
    return '$count วันที่แล้ว';
  }

  @override
  String get analytics => 'วิเคราะห์ยอดขาย';

  @override
  String get totalRevenue => 'รายได้รวม';

  @override
  String get totalOrders => 'คำสั่งซื้อทั้งหมด';

  @override
  String get averageOrderValue => 'มูลค่าเฉลี่ยต่อคำสั่งซื้อ';

  @override
  String get revenueTrend => 'แนวโน้มรายได้';

  @override
  String get orderStatusDistribution => 'การกระจายสถานะคำสั่งซื้อ';

  @override
  String get topProducts => 'สินค้าขายดี';

  @override
  String get noDataAvailable => 'ไม่มีข้อมูล';

  @override
  String get periodToday => 'วันนี้';

  @override
  String get periodWeek => 'สัปดาห์นี้';

  @override
  String get periodMonth => 'เดือนนี้';

  @override
  String get periodYear => 'ปีนี้';

  @override
  String soldCount(int count) {
    return 'ขายแล้ว: $count';
  }

  @override
  String get orders => 'คำสั่งซื้อ';

  @override
  String get selectPeriod => 'เลือกช่วงเวลา';

  @override
  String get manageYourBusiness => 'จัดการร้านค้า สินค้า และคำสั่งซื้อของคุณ';

  @override
  String get pendingOrders => 'คำสั่งซื้อที่รอดำเนินการ';

  @override
  String get activeOrders => 'คำสั่งซื้อที่กำลังดำเนินการ';

  @override
  String get quickActions => 'เมนูด่วน';

  @override
  String get myStalls => 'ร้านค้าของฉัน';

  @override
  String get manageStalls => 'จัดการร้านค้าอาหารของคุณ';

  @override
  String get myOrders => 'คำสั่งซื้อของฉัน';

  @override
  String get viewAndManageOrders => 'ดูและจัดการคำสั่งซื้อของลูกค้า';

  @override
  String get settings => 'ตั้งค่า';

  @override
  String get configureApp => 'ตั้งค่าแอพพลิเคชัน';

  @override
  String get account => 'บัญชี';

  @override
  String get notAvailable => 'ไม่มีข้อมูล';

  @override
  String get nostrRelays => 'Nostr Relays';

  @override
  String get connectionStatus => 'สถานะการเชื่อมต่อ';

  @override
  String get total => 'ทั้งหมด';

  @override
  String get connected => 'เชื่อมต่อแล้ว';

  @override
  String get healthy => 'ปกติ';

  @override
  String get relayList => 'รายการ Relay';

  @override
  String relaysConfigured(int count) {
    return 'ตั้งค่า $count relays แล้ว';
  }

  @override
  String get mediaServer => 'เซิร์ฟเวอร์สื่อ';

  @override
  String get nip96Tag => 'NIP-96';

  @override
  String get legacyTag => 'รุ่นเก่า';

  @override
  String get about => 'เกี่ยวกับ';

  @override
  String get version => 'เวอร์ชัน';

  @override
  String get protocol => 'โปรโตคอล';

  @override
  String get encryption => 'การเข้ารหัส';

  @override
  String get dangerZone => 'โซนอันตราย';

  @override
  String get exportPrivateKey => 'ส่งออก Private Key';

  @override
  String get backupPrivateKey => 'สำรองข้อมูล private key ของคุณ';

  @override
  String get signOutAccount => 'ออกจากบัญชีของคุณ';

  @override
  String errorLoadingSettings(String error) {
    return 'เกิดข้อผิดพลาดในการโหลดการตั้งค่า: $error';
  }

  @override
  String copiedToClipboard(String label) {
    return 'คัดลอก $label ไปยังคลิปบอร์ดแล้ว';
  }

  @override
  String get noStallsYet => 'ยังไม่มีร้านค้า';

  @override
  String get createFirstStall => 'สร้างร้านค้าแรกของคุณเพื่อเริ่มต้น';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get newStall => 'ร้านค้าใหม่';

  @override
  String get chooseStallType => 'เลือกประเภทร้านค้า';

  @override
  String get filterByStatus => 'กรองตามสถานะ';

  @override
  String get allOrders => 'คำสั่งซื้อทั้งหมด';

  @override
  String get all => 'ทั้งหมด';

  @override
  String get noOrdersYet => 'ยังไม่มีคำสั่งซื้อ';

  @override
  String get ordersWillAppear => 'คำสั่งซื้อจากลูกค้าจะปรากฏที่นี่';

  @override
  String get refresh => 'รีเฟรช';

  @override
  String get noProductsYet => 'ยังไม่มีสินค้า';

  @override
  String get addFirstProduct => 'เพิ่มสินค้าแรกของคุณเพื่อเริ่มขาย';

  @override
  String get addProduct => 'เพิ่มสินค้า';

  @override
  String get failedToLoadProducts => 'โหลดสินค้าไม่สำเร็จ';

  @override
  String get editProduct => 'แก้ไขสินค้า';

  @override
  String get deleteProduct => 'ลบสินค้า';

  @override
  String get createStall => 'สร้างร้านค้า';

  @override
  String get editStall => 'แก้ไขร้านค้า';

  @override
  String get stallName => 'ชื่อร้านค้า';

  @override
  String get description => 'คำอธิบาย';

  @override
  String get currency => 'สกุลเงิน';

  @override
  String get cuisine => 'ประเภทอาหาร';

  @override
  String get preparationTime => 'เวลาเตรียม';

  @override
  String get operatingHours => 'เวลาเปิด-ปิด';

  @override
  String get acceptsOrders => 'รับคำสั่งซื้อ';

  @override
  String get shippingZones => 'โซนการจัดส่ง';

  @override
  String get addShippingZone => 'เพิ่มโซนการจัดส่ง';

  @override
  String get save => 'บันทึก';

  @override
  String get delete => 'ลบ';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get productName => 'ชื่อสินค้า';

  @override
  String get price => 'ราคา';

  @override
  String get category => 'หมวดหมู่';

  @override
  String get inStock => 'มีสินค้า';

  @override
  String get images => 'รูปภาพ';

  @override
  String get addImage => 'เพิ่มรูปภาพ';

  @override
  String get basicInformation => 'ข้อมูลพื้นฐาน';

  @override
  String get stallNameRequired => 'ชื่อร้านค้า *';

  @override
  String get stallNameHint => 'เช่น ร้านอาหารไทย';

  @override
  String get descriptionOptional => 'คำอธิบาย (ไม่จำเป็น)';

  @override
  String get pleaseEnterStallName => 'กรุณากรอกชื่อแผง';

  @override
  String get stallCreatedSuccessfully => 'สร้างร้านค้าสำเร็จ';

  @override
  String get stallUpdatedSuccessfully => 'อัปเดตร้านค้าสำเร็จ';

  @override
  String get pleaseAddShippingZone => 'กรุณาเพิ่มโซนการจัดส่งอย่างน้อย 1 โซน';

  @override
  String get orderDetails => 'รายละเอียดคำสั่งซื้อ';

  @override
  String get orderLabel => 'คำสั่งซื้อ';

  @override
  String get unknownStall => 'ไม่มีชื่อร้าน';

  @override
  String get readyPrefix => 'พร้อม:';

  @override
  String get reject => 'ปฏิเสธ';

  @override
  String get accept => 'รับคำสั่งซื้อ';

  @override
  String get startPreparing => 'เริ่มเตรียมอาหาร';

  @override
  String get markAsReady => 'มารับสินค้าได้แล้ว';

  @override
  String get assignRider => 'มอบหมายผู้ส่ง';

  @override
  String get privateKeyNotAvailable => 'กุญแจส่วนตัวไม่พร้อมใช้งาน';

  @override
  String get orderAccepted => 'ยอมรับคำสั่งซื้อแล้ว';

  @override
  String get orderRejected => 'ปฏิเสธคำสั่งซื้อแล้ว';

  @override
  String get orderBeingPrepared => 'กำลังเตรียมคำสั่งซื้อ';

  @override
  String get orderReadyForPickup => 'คำสั่งซื้อพร้อมสำหรับรับสินค้าแล้ว';

  @override
  String get rejectOrderTitle => 'ปฏิเสธคำสั่งซื้อ';

  @override
  String get rejectOrderConfirm =>
      'คุณแน่ใจหรือไม่ว่าต้องการปฏิเสธคำสั่งซื้อนี้?';

  @override
  String get riderAssignmentComingSoon => 'การมอบหมายผู้ส่ง - มาในเร็วๆ นี้...';

  @override
  String get decryptingOrderDetails => 'กำลังถอดรหัสรายละเอียดคำสั่งซื้อ...';

  @override
  String get decryptDetails => 'ถอดรหัสรายละเอียด';

  @override
  String get orderDetailsEncrypted => 'รายละเอียดคำสั่งซื้อถูกเข้ารหัส';

  @override
  String get customerInformation => 'ข้อมูลลูกค้า';

  @override
  String get updateOrderStatus => 'อัปเดตสถานะคำสั่งซื้อ';

  @override
  String get copyOrderId => 'คัดลอก Order ID';

  @override
  String get copyCustomerPubkey => 'คัดลอก Customer Pubkey';

  @override
  String get status => 'สถานะ';

  @override
  String get customer => 'ลูกค้า';

  @override
  String get orderItems => 'รายการสินค้า';

  @override
  String get deliveryAddress => 'ที่อยู่จัดส่ง';

  @override
  String get contactPhone => 'เบอร์โทรติดต่อ';

  @override
  String get specialInstructions => 'คำสั่งพิเศษ';

  @override
  String get none => 'ไม่มี';

  @override
  String get nameLabel => 'ชื่อ';

  @override
  String get nostrPubkeyLabel => 'คีย์สาธารณะ Nostr';

  @override
  String get phoneLabel => 'โทรศัพท์';

  @override
  String get emailLabel => 'อีเมล';

  @override
  String get addressLabel => 'ที่อยู่';

  @override
  String get messageLabel => 'ข้อความ:';

  @override
  String get subtotal => 'รวมย่อย';

  @override
  String get shipping => 'ค่าจัดส่ง';

  @override
  String get discount => 'ส่วนลด';

  @override
  String get totalLabel => 'รวมทั้งหมด';

  @override
  String get paymentHashLabel => 'รหัสการชำระเงิน (Hash)';

  @override
  String get paymentProofLabel => 'หลักฐานการชำระเงิน';

  @override
  String get updatedLabel => 'อัปเดต';

  @override
  String get estimatedReadyLabel => 'คาดว่าจะพร้อม';

  @override
  String get updatingOrderStatus => 'กำลังอัปเดตสถานะคำสั่งซื้อ...';

  @override
  String orderStatusUpdated(Object status) {
    return 'สถานะคำสั่งซื้อเปลี่ยนเป็น $status';
  }

  @override
  String failedToUpdateStatus(Object error) {
    return 'ไม่สามารถอัปเดตสถานะ: $error';
  }

  @override
  String get actionCannotBeUndone => 'การกระทำนี้ไม่สามารถย้อนกลับได้';

  @override
  String notificationOrderTapped(Object orderId) {
    return 'คำสั่งซื้อ $orderId';
  }

  @override
  String get currencySymbol => '฿';

  @override
  String get actions => 'การดำเนินการ';

  @override
  String get acceptOrder => 'รับคำสั่งซื้อ';

  @override
  String get prepareOrder => 'เตรียมคำสั่งซื้อ';

  @override
  String get readyForPickup => 'พร้อมรับสินค้า';

  @override
  String get completeOrder => 'คำสั่งซื้อเสร็จสมบูรณ์';

  @override
  String get cancelOrder => 'ยกเลิกคำสั่งซื้อ';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get authenticationRequired => 'ต้องเข้าสู่ระบบ';

  @override
  String get failedToDecryptOrderDetails =>
      'ถอดรหัสรายละเอียดคำสั่งซื้อไม่สำเร็จ';

  @override
  String get receiptsTitle => 'ใบเสร็จ';

  @override
  String get receiptsView => 'ดู';

  @override
  String get receiptsCopyId => 'คัดลอกรหัส';

  @override
  String get receiptsAmountPrefix => 'จำนวน:';

  @override
  String receiptDetailTitle(Object id) {
    return 'ใบเสร็จ: $id';
  }

  @override
  String get receiptLabelTitle => 'หัวข้อ';

  @override
  String get receiptLabelDate => 'วันที่';

  @override
  String get receiptLabelAmount => 'จำนวน';

  @override
  String get receiptLabelItems => 'รายการ';

  @override
  String get receiptCopied => 'คัดลอกรหัสใบเสร็จแล้ว';

  @override
  String get waitingForApproval => '⏳ กำลังรอการอนุมัติ';

  @override
  String get waitingForApprovalContent =>
      'กรุณาอนุมัติการเชื่อมต่อในแอป nsecBunker หรือ Amber ของคุณ';

  @override
  String get stepsLabel => 'ขั้นตอน:';

  @override
  String get step1 => '1. เปิดแอป nsecBunker/Amber ของคุณ';

  @override
  String get step2 => '2. ควรจะเห็นคำขอเชื่อมต่อ';

  @override
  String get step3 => '3. ยืนยันคำขอ';

  @override
  String deleteProductConfirm(Object productName) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบ \"$productName\"?';
  }

  @override
  String get productDeletedSuccessfully => 'ลบสินค้าสำเร็จ';

  @override
  String failedToDeleteProduct(Object error) {
    return 'ไม่สามารถลบสินค้าได้: $error';
  }

  @override
  String get productCreated => 'สร้างสินค้าสำเร็จ';

  @override
  String get productUpdated => 'อัปเดตสินค้าสำเร็จ';

  @override
  String get imageUploadedSuccessfully => 'อัปโหลดรูปภาพสำเร็จ';

  @override
  String failedToUploadImage(Object error) {
    return 'อัปโหลดรูปภาพไม่สำเร็จ: $error';
  }

  @override
  String get noImagesAdded => 'ยังไม่มีรูปภาพ';

  @override
  String get uploading => 'กำลังอัปโหลด...';

  @override
  String get addCategory => 'เพิ่มหมวดหมู่';

  @override
  String get addSpecification => 'เพิ่มสเปค';

  @override
  String get noCategoriesAdded => 'ยังไม่มีหมวดหมู่';

  @override
  String get noSpecsAdded => 'ยังไม่มีสเปค';

  @override
  String get addShippingOverride => 'เพิ่มการปรับค่าส่ง';

  @override
  String get noShippingOverrides => 'ยังไม่มีการปรับค่าส่ง';

  @override
  String get imageUploadServerTitle => 'เซิร์ฟเวอร์อัปโหลดรูป';

  @override
  String get mediaServerSettingsTitle => 'การตั้งค่าเซิร์ฟเวอร์สื่อ';

  @override
  String get selectMediaServerDescription =>
      'เลือกเซิร์ฟเวอร์สื่อสำหรับการอัปโหลดรูปภาพสินค้า:';

  @override
  String mediaServerChangedTo(Object name) {
    return 'เปลี่ยนเซิร์ฟเวอร์สื่อเป็น $name';
  }

  @override
  String get customServerTitle => 'เซิร์ฟเวอร์กำหนดเอง';

  @override
  String get copyNsec => 'คัดลอก nsec';

  @override
  String get pleaseFillAllFields => 'กรุณากรอกข้อมูลให้ครบ';

  @override
  String get invalidUrlFormat => 'รูปแบบ URL ไม่ถูกต้อง';

  @override
  String get logoutConfirm => 'คุณแน่ใจว่าต้องการออกจากระบบหรือไม่?';

  @override
  String get debugRunnerLabel => 'โหมดดีบัก - แอปอย่างง่าย';

  @override
  String zoneLabel(Object id) {
    return 'โซน: $id';
  }

  @override
  String get descriptionLabel => 'คำอธิบาย';

  @override
  String get descriptionHint => 'อธิบายแผง, เมนู หรือ นโยบายของคุณ';

  @override
  String get stallTypeLabel => 'ประเภทแผง';

  @override
  String get currencyLabel => 'สกุลเงิน';

  @override
  String get currencyHint => 'เช่น THB';

  @override
  String get prepTimeLabel => 'เวลาการเตรียม (นาที)';

  @override
  String get foodDetailsLabel => 'รายละเอียดอาหาร';

  @override
  String get cuisineTypeLabel => 'ประเภทอาหาร';

  @override
  String get cuisineHint => 'เช่น ไทย, อิตาเลียน';

  @override
  String get operatingHoursLabel => 'เวลาทำการ';

  @override
  String get operatingHoursHint => 'เช่น 09:00-22:00';

  @override
  String get shippingZonesLabel => 'โซนการจัดส่ง';

  @override
  String get shippingZonesDescription => 'กำหนดโซนการจัดส่งและค่าจัดส่ง';

  @override
  String get costLabel => 'ค่าใช้จ่าย';

  @override
  String get regionsLabel => 'ภูมิภาค';

  @override
  String get allRegions => 'ทุกภูมิภาค';

  @override
  String get updateStall => 'อัปเดตแผง';

  @override
  String extraCostLabel(Object cost) {
    return 'ค่าเพิ่ม: $cost';
  }

  @override
  String get availableForOrder => 'พร้อมให้สั่งซื้อ';

  @override
  String get availableForOrderSubtitle => 'ลูกค้าสามารถสั่งสินค้านี้ได้';

  @override
  String get createProduct => 'สร้างสินค้า';

  @override
  String get productImages => 'รูปภาพสินค้า';

  @override
  String get uploadImagesDescription => 'อัปโหลดรูปภาพเพื่อแสดงสินค้า';

  @override
  String get categories => 'หมวดหมู่';

  @override
  String get availability => 'ความพร้อมขาย';

  @override
  String get editSpecification => 'แก้ไขสเปค';

  @override
  String get editShippingOverride => 'แก้ไขการปรับค่าส่ง';

  @override
  String get add => 'เพิ่ม';

  @override
  String get categoryName => 'ชื่อหมวดหมู่';

  @override
  String get categoryHint => 'เช่น เมนูหลัก, ของหวาน';

  @override
  String get privateKeyHexLabel => 'Private Key (hex)';

  @override
  String get privateKeyHexHint => 'กรอกคีย์ส่วนตัว 64 ตัวอักษร';

  @override
  String get serverNameLabel => 'ชื่อเซิร์ฟเวอร์';

  @override
  String get serverNameHint => 'เช่น My Server';

  @override
  String get uploadUrlLabel => 'URL อัปโหลด';

  @override
  String get uploadUrlHint => 'https://example.com/upload';

  @override
  String get editShippingZone => 'แก้ไขโซนการจัดส่ง';

  @override
  String get zoneIdLabel => 'รหัสโซน *';

  @override
  String get zoneIdHint => 'zone_1';

  @override
  String get zoneNameLabel => 'ชื่อโซน';

  @override
  String get zoneNameHint => 'เช่น Local Delivery, Express';

  @override
  String get shippingCostLabel => 'ค่าจัดส่ง *';

  @override
  String get shippingCostHint => '30.00';

  @override
  String get regionsHint => 'region1, region2, region3';

  @override
  String get regionsHelper => 'คั่นด้วยคอมม่า (ไม่บังคับ)';

  @override
  String get noShippingZonesAdded => 'ยังไม่มีโซนการจัดส่ง';

  @override
  String get requiredLabel => 'จำเป็น';

  @override
  String get nostrInfoDescription =>
      'ZapD ใช้โปรโตคอล Nostr สำหรับการยืนยันตัวตนที่ปลอดภัยและกระจายศูนย์ คีย์ส่วนตัวของคุณคือตัวตนของคุณ - เก็บให้ปลอดภัย!';

  @override
  String get neverSharePrivateKeyWarning =>
      'ห้ามแชร์คีย์ส่วนตัวของคุณ เก็บไว้ในที่ปลอดภัย การสูญหายของคีย์หมายถึงการสูญเสียการเข้าถึง!';

  @override
  String get productNameLabel => 'ชื่อสินค้า *';

  @override
  String get productNameHint => 'เช่น ผัดไทย';

  @override
  String get pleaseEnterProductName => 'กรุณากรอกชื่อสินค้า';

  @override
  String get priceLabel => 'ราคา *';

  @override
  String get invalidLabel => 'ไม่ถูกต้อง';

  @override
  String get quantityHint => 'ปล่อยว่างสำหรับไม่จำกัด';

  @override
  String get spicyLevelLabel => 'ระดับความเผ็ด (0-5)';

  @override
  String get dailyLimitLabel => 'จำกัดต่อวัน';

  @override
  String get dailyLimitHint => 'จำนวนสั่งสูงสุดต่อวัน';

  @override
  String get productSpecificationsHeader => 'สเปคสินค้า (NIP-15)';

  @override
  String get specKeyLabel => 'คีย์ *';

  @override
  String get specKeyHint => 'เช่น ขนาด, น้ำหนัก, วัสดุ';

  @override
  String get specValueLabel => 'ค่า *';

  @override
  String get specValueHint => 'เช่น ใหญ่, 500g, ผ้า';

  @override
  String get shippingCostsHeader => 'ค่าจัดส่ง (NIP-15)';

  @override
  String get extraShippingCostsDescription =>
      'ค่าใช้จ่ายการจัดส่งเพิ่มเติมต่อโซน';

  @override
  String get quantityLabel => 'จำนวน';

  @override
  String stallProductsTitle(Object stallName, Object products) {
    return '$stallName - $products';
  }

  @override
  String serverNameWithTag(Object name, Object tag) {
    return '$name ($tag)';
  }

  @override
  String get changeServer => 'เปลี่ยนเซิร์ฟเวอร์';

  @override
  String errorWithMessage(Object message) {
    return 'ข้อผิดพลาด: $message';
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
    return '$message\nคีย์สาธารณะ: $pubkey';
  }
}
