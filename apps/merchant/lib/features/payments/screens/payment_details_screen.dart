import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../l10n/app_localizations.dart';
import '../models/payment.dart';
import '../providers/payment_provider.dart';

class PaymentDetailsScreen extends ConsumerStatefulWidget {
  final Payment payment;

  const PaymentDetailsScreen({
    super.key,
    required this.payment,
  });

  @override
  ConsumerState<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends ConsumerState<PaymentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Start polling for payment status if pending
    if (widget.payment.status == PaymentStatus.pending) {
      _startPaymentStatusPolling();
    }
  }

  void _startPaymentStatusPolling() {
    // Poll every 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && widget.payment.status == PaymentStatus.pending) {
        ref.read(paymentProvider.notifier).checkPaymentStatus(
          widget.payment.paymentHash!,
        );
        _startPaymentStatusPolling();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final paymentState = ref.watch(paymentProvider);
    final currentPayment = paymentState.currentPayment ?? widget.payment;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.paymentDetails),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status Card
          _buildStatusCard(currentPayment),
          const SizedBox(height: 16),

          // Amount Card
          _buildAmountCard(currentPayment),
          const SizedBox(height: 16),

          // Lightning Invoice Card
          if (currentPayment.lightningInvoice != null)
            _buildInvoiceCard(currentPayment),
          const SizedBox(height: 16),

          // Payment Details
          _buildDetailsCard(currentPayment),
          const SizedBox(height: 32),

          // Actions
          if (currentPayment.status == PaymentStatus.pending) ...[
            FilledButton.icon(
              onPressed: () => _showQRCode(currentPayment),
              icon: const Icon(Icons.qr_code),
              label: Text(l10n.showQrCode),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _copyInvoice(currentPayment),
              icon: const Icon(Icons.copy),
              label: Text(l10n.copyInvoice),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusCard(Payment payment) {
    final l10n = AppLocalizations.of(context)!;
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (payment.status) {
      case PaymentStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        statusText = l10n.paymentStatusPending;
        break;
      case PaymentStatus.paid:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = l10n.paymentStatusPaid;
        break;
      case PaymentStatus.expired:
        statusColor = Colors.red;
        statusIcon = Icons.error;
        statusText = l10n.paymentStatusExpired;
        break;
      case PaymentStatus.failed:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = l10n.paymentStatusFailed;
        break;
    }

    return Card(
  color: statusColor.withAlpha((0.1 * 255).round()),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(statusIcon, size: 64, color: statusColor),
            const SizedBox(height: 16),
            Text(
              statusText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (payment.status == PaymentStatus.pending && payment.expiresAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${l10n.expiresAt}: ${_formatTimestamp(payment.expiresAt!)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard(Payment payment) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.amount,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${payment.amount.toStringAsFixed(2)} ${payment.currency}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (payment.metadata != null &&
                    payment.metadata!['original_amount'] != null)
                  Text(
                    '${l10n.estimatedSats} ~${(payment.amount * 100).round()} sats',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(Payment payment) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.lightningInvoice,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () => _copyInvoice(payment),
                  tooltip: l10n.tapToCopy,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                payment.lightningInvoice!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(Payment payment) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.paymentDetails,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(l10n.paymentId, payment.id),
            _buildDetailRow(l10n.orderId, payment.orderId),
            _buildDetailRow(l10n.paymentMethod, payment.method.name.toUpperCase()),
            if (payment.paymentHash != null)
              _buildDetailRow(l10n.paymentHash, payment.paymentHash!, mono: true),
            if (payment.preimage != null)
              _buildDetailRow(l10n.preimage, payment.preimage!, mono: true),
            _buildDetailRow(l10n.createdAt, _formatTimestamp(payment.createdAt)),
            if (payment.paidAt != null)
              _buildDetailRow(l10n.paidAt, _formatTimestamp(payment.paidAt!)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool mono = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: mono ? 'monospace' : null,
                fontSize: mono ? 11 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQRCode(Payment payment) {
    final l10n = AppLocalizations.of(context)!;
    if (payment.lightningInvoice == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.scanWithWallet),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: QrImageView(
                data: payment.lightningInvoice!.toUpperCase(),
                version: QrVersions.auto,
                size: 250,
                backgroundColor: Colors.white,
                errorCorrectionLevel: QrErrorCorrectLevel.M,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.scanWithWallet,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
          FilledButton(
            onPressed: () {
              _copyInvoice(payment);
              Navigator.pop(context);
            },
            child: Text(l10n.copyInvoice),
          ),
        ],
      ),
    );
  }

  void _copyInvoice(Payment payment) {
    final l10n = AppLocalizations.of(context)!;
    if (payment.lightningInvoice != null) {
      Clipboard.setData(ClipboardData(text: payment.lightningInvoice!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.copiedInvoice)),
      );
    }
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
