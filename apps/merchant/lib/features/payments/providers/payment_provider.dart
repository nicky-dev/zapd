import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment.dart';
import '../services/lightning_service.dart';
import '../repositories/payment_repository.dart';
import '../../../core/providers/nostr_provider.dart';

/// Lightning Payment Service Provider
final lightningServiceProvider = Provider<LightningPaymentService>((ref) {
  return LightningPaymentService();
});

/// Payment Repository Provider
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final nostrClient = ref.watch(nostrClientProvider);
  final lightningService = ref.watch(lightningServiceProvider);
  
  return PaymentRepository(
    nostrClient: nostrClient,
    lightningService: lightningService,
  );
});

/// Payment State
class PaymentState {
  final Payment? currentPayment;
  final bool isLoading;
  final String? error;
  final List<Payment> payments;

  const PaymentState({
    this.currentPayment,
    this.isLoading = false,
    this.error,
    this.payments = const [],
  });

  PaymentState copyWith({
    Payment? currentPayment,
    bool? isLoading,
    String? error,
    List<Payment>? payments,
  }) {
    return PaymentState(
      currentPayment: currentPayment ?? this.currentPayment,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      payments: payments ?? this.payments,
    );
  }
}

/// Payment Notifier
class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentRepository repository;

  PaymentNotifier(this.repository) : super(const PaymentState());

  /// Create payment for an order
  Future<Payment?> createPayment({
    required String orderId,
    required double amount,
    required String currency,
    required String merchantPubkey,
    required String customerPubkey,
    String? description,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final payment = await repository.createPayment(
        orderId: orderId,
        amount: amount,
        currency: currency,
        merchantPubkey: merchantPubkey,
        customerPubkey: customerPubkey,
        description: description,
      );

      state = state.copyWith(
        currentPayment: payment,
        isLoading: false,
      );

      return payment;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Check payment status
  Future<void> checkPaymentStatus(String paymentHash) async {
    if (state.currentPayment == null) return;

    try {
      final status = await repository.checkPaymentStatus(paymentHash);
      
      if (status == PaymentStatus.paid && 
          state.currentPayment!.status != PaymentStatus.paid) {
        // Payment was completed!
        state = state.copyWith(
          currentPayment: state.currentPayment!.copyWith(
            status: PaymentStatus.paid,
            paidAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          ),
        );
      }
    } catch (e) {
      // Silently fail status checks
      print('Error checking payment status: $e');
    }
  }

  /// Mark payment as paid with preimage
  Future<bool> markAsPaid(String preimage) async {
    if (state.currentPayment == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final payment = await repository.markAsPaid(
        payment: state.currentPayment!,
        preimage: preimage,
      );

      state = state.copyWith(
        currentPayment: payment,
        isLoading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Clear current payment
  void clearPayment() {
    state = state.copyWith(currentPayment: null, error: null);
  }

  /// Load payments for an order
  Future<void> loadOrderPayments(String orderId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final payments = await repository.getPaymentsByOrder(orderId);
      
      state = state.copyWith(
        payments: payments,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

/// Payment Provider
final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  final repository = ref.watch(paymentRepositoryProvider);
  return PaymentNotifier(repository);
});

/// Payment for specific order provider
final orderPaymentProvider = FutureProvider.family<List<Payment>, String>((ref, orderId) async {
  final repository = ref.watch(paymentRepositoryProvider);
  return repository.getPaymentsByOrder(orderId);
});
