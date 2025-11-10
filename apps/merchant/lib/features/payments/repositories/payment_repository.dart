import 'package:nostr_core/nostr_core.dart';
import '../models/payment.dart';
import '../services/lightning_service.dart';

/// Payment Repository
/// 
/// Manages payment creation, tracking, and verification
class PaymentRepository {
  final NostrClient nostrClient;
  final LightningPaymentService lightningService;

  PaymentRepository({
    required this.nostrClient,
    required this.lightningService,
  });

  /// Create a payment for an order
  Future<Payment> createPayment({
    required String orderId,
    required double amount,
    required String currency,
    required String merchantPubkey,
    required String customerPubkey,
    String? description,
  }) async {
    // Generate Lightning invoice
    final invoice = await lightningService.generateInvoice(
      orderId: orderId,
      amount: amount,
      currency: currency,
      description: description,
    );

    // Create payment record
    final payment = Payment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderId: orderId,
      amount: amount,
      currency: currency,
      method: PaymentMethod.lightning,
      status: PaymentStatus.pending,
      lightningInvoice: invoice.paymentRequest,
      paymentHash: invoice.paymentHash,
      expiresAt: invoice.expiresAt,
      merchantPubkey: merchantPubkey,
      customerPubkey: customerPubkey,
      metadata: invoice.metadata,
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );

    return payment;
  }

  /// Check payment status
  Future<PaymentStatus> checkPaymentStatus(String paymentHash) async {
    final isPaid = await lightningService.checkPaymentStatus(paymentHash);
    
    if (isPaid) {
      return PaymentStatus.paid;
    }
    
    return PaymentStatus.pending;
  }

  /// Mark payment as paid
  Future<Payment> markAsPaid({
    required Payment payment,
    required String preimage,
  }) async {
    // Verify preimage
    final isValid = lightningService.verifyPreimage(
      preimage,
      payment.paymentHash!,
    );

    if (!isValid) {
      throw Exception('Invalid payment preimage');
    }

    // Update payment status
    final updatedPayment = payment.copyWith(
      status: PaymentStatus.paid,
      preimage: preimage,
      paidAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );

    return updatedPayment;
  }

  /// Mark payment as expired
  Future<Payment> markAsExpired(Payment payment) async {
    return payment.copyWith(
      status: PaymentStatus.expired,
    );
  }

  /// Mark payment as failed
  Future<Payment> markAsFailed(Payment payment) async {
    return payment.copyWith(
      status: PaymentStatus.failed,
    );
  }

  /// Get payment by ID
  Future<Payment?> getPaymentById(String paymentId) async {
    // In production: fetch from database or Nostr events
    // For now, return null (not implemented)
    return null;
  }

  /// Get payments for an order
  Future<List<Payment>> getPaymentsByOrder(String orderId) async {
    // In production: query database or Nostr events
    // For now, return empty list (not implemented)
    return [];
  }

  /// Get all payments for a merchant
  Future<List<Payment>> getMerchantPayments(String merchantPubkey) async {
    // In production: query database or Nostr events
    // For now, return empty list (not implemented)
    return [];
  }
}
