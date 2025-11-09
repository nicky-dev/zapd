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
  String get welcomeTitle => 'ZapD ร้านค้า';

  @override
  String get welcomeSubtitle => 'บริการจัดส่งอาหารแบบกระจายศูนย์';

  @override
  String get poweredByNostr => 'ขับเคลื่อนด้วย Nostr Protocol';

  @override
  String get nostrDescription =>
      'ข้อมูลของคุณปลอดภัยด้วยกุญแจเข้ารหัส ไม่มีรหัสผ่าน ไม่มีเซิร์ฟเวอร์กลาง';

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
  String get privateKey => 'กุญแจส่วนตัว';

  @override
  String get privateKeySecret => 'กุญแจส่วนตัว (เก็บเป็นความลับ!)';

  @override
  String get publicKey => 'กุญแจสาธารณะ';

  @override
  String get publicKeySafeToShare => 'กุญแจสาธารณะ (แชร์ได้)';

  @override
  String get copy => 'คัดลอก';

  @override
  String get copied => 'คัดลอกแล้ว';

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
  String get welcomeBack => 'ยินดีต้อนรับกลับมา!';

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
}
