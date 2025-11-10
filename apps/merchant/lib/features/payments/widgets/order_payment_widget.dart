import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../../orders/models/order.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../models/payment.dart';
import '../providers/payment_provider.dart';
import '../screens/payment_details_screen.dart';

/// Payment widget for order detail screen
class OrderPaymentWidget extends ConsumerWidget {
  final Order order;

  const OrderPaymentWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final paymentState = ref.watch(paymentProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.payment,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.payment,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                if (paymentState.currentPayment != null)
                  _buildStatusChip(context, paymentState.currentPayment!.status),
              ],
            ),
            const Divider(height: 24),
            
            if (paymentState.currentPayment == null) ...[
              // No payment yet - show create payment button
              _buildNoPayment(context, ref),
            ] else ...[
              // Payment exists - show details
              _buildPaymentInfo(context, ref, paymentState.currentPayment!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, PaymentStatus status) {
    final l10n = AppLocalizations.of(context)!;
    Color color;
    String label;

    switch (status) {
      case PaymentStatus.pending:
        color = Colors.orange;
        label = l10n.paymentStatusPending;
        break;
      case PaymentStatus.paid:
        color = Colors.green;
        label = l10n.paymentStatusPaid;
        break;
      case PaymentStatus.expired:
        color = Colors.red;
        label = l10n.paymentStatusExpired;
        break;
      case PaymentStatus.failed:
        color = Colors.red;
        label = l10n.paymentStatusFailed;
        break;
    }

    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color),
    );
  }

  Widget _buildNoPayment(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Icon(Icons.account_balance_wallet_outlined, size: 48, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          l10n.noPayment,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.generateLightningInvoice,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => _createPayment(context, ref),
          icon: const Icon(Icons.bolt),
          label: Text(l10n.generateLightningInvoice),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo(BuildContext context, WidgetRef ref, Payment payment) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          context,
          l10n.amount,
          '${payment.amount.toStringAsFixed(2)} ${payment.currency}',
          bold: true,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          context,
          l10n.paymentMethod,
          payment.method == PaymentMethod.lightning ? l10n.lightningLabel : payment.method.name,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          context,
          l10n.paymentStatus,
          payment.status.name.toUpperCase(),
          color: _getStatusColor(payment.status),
        ),
        if (payment.paidAt != null) ...[
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            l10n.paidAt,
            _formatTimestamp(payment.paidAt!),
          ),
        ],
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _viewPaymentDetails(context, payment),
                icon: const Icon(Icons.visibility),
                label: Text(l10n.viewDetails),
              ),
            ),
            if (payment.status == PaymentStatus.pending) ...[
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _checkPaymentStatus(ref, payment),
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.checkStatus),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: color,
            fontSize: bold ? 18 : 14,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return Colors.green;
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.expired:
      case PaymentStatus.failed:
        return Colors.red;
    }
  }

  void _createPayment(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(paymentProvider.notifier);
    
    // Get merchant pubkey from auth provider
    final authState = ref.read(authProvider);
    final merchantPubkey = authState.value?.publicKey;
    
    if (merchantPubkey == null) {
      final l10n = AppLocalizations.of(context)!;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.merchantNotAuthenticated)),
        );
      }
      return;
    }
    
    // Calculate total amount from order details
    // If details are not loaded yet, use a default or show error
    final totalAmount = order.details?.total?.toDouble() ?? 0.0;
    
    if (totalAmount <= 0) {
      final l10n = AppLocalizations.of(context)!;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.orderTotalNotAvailable)),
        );
      }
      return;
    }
    
    final payment = await notifier.createPayment(
      orderId: order.id,
      amount: totalAmount / 100, // Convert from smallest unit (satang) to THB
      currency: 'THB',
      merchantPubkey: merchantPubkey,
      customerPubkey: order.customerPubkey,
      description: 'ZapD Order #${order.id.substring(0, 8)}',
    );

    if (payment != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentDetailsScreen(payment: payment),
        ),
      );
    }
  }

  void _viewPaymentDetails(BuildContext context, Payment payment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentDetailsScreen(payment: payment),
      ),
    );
  }

  void _checkPaymentStatus(WidgetRef ref, Payment payment) {
    ref.read(paymentProvider.notifier).checkPaymentStatus(payment.paymentHash!);
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
