import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

/// Payment status
enum PaymentStatus {
  pending,
  paid,
  expired,
  failed,
}

/// Payment method
enum PaymentMethod {
  lightning,
  onChain,
  other,
}

/// Payment model
@freezed
class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String orderId,
    required double amount,
    required String currency,
    required PaymentMethod method,
    required PaymentStatus status,
    String? lightningInvoice,
    String? paymentHash,
    String? preimage,
    int? expiresAt,
    int? paidAt,
    String? merchantPubkey,
    String? customerPubkey,
    Map<String, dynamic>? metadata,
    required int createdAt,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}

/// Lightning invoice details
@freezed
class LightningInvoice with _$LightningInvoice {
  const factory LightningInvoice({
    required String paymentRequest, // bolt11 invoice
    required String paymentHash,
    required int amount, // in satoshis
    required String description,
    required int expiresAt,
    int? createdAt,
    Map<String, dynamic>? metadata,
  }) = _LightningInvoice;

  factory LightningInvoice.fromJson(Map<String, dynamic> json) =>
      _$LightningInvoiceFromJson(json);
}

/// Payment request for creating invoices
@freezed
class PaymentRequest with _$PaymentRequest {
  const factory PaymentRequest({
    required String orderId,
    required double amount,
    required String currency,
    required String merchantPubkey,
    required String customerPubkey,
    String? description,
    Map<String, dynamic>? metadata,
  }) = _PaymentRequest;

  factory PaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestFromJson(json);
}
