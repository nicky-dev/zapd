import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../providers/order_provider.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../payments/widgets/order_payment_widget.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final Order order;

  const OrderDetailScreen({
    super.key,
    required this.order,
  });

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  bool _isLoadingDetails = false;
  OrderDetails? _decryptedDetails;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.order.details != null) {
      setState(() {
        _decryptedDetails = widget.order.details;
      });
      return;
    }

    setState(() {
      _isLoadingDetails = true;
      _errorMessage = null;
    });

    try {
      final authState = await ref.read(authProvider.future);
      final privateKey = authState.privateKey;

      if (privateKey == null) {
        setState(() {
          _errorMessage = l10n.authenticationRequired;
          _isLoadingDetails = false;
        });
        return;
      }

      final detailsAsync = await ref.read(
        orderDetailsProvider((
          orderId: widget.order.id,
          customerPubkey: widget.order.customerPubkey,
          privateKey: privateKey,
        )).future,
      );

      setState(() {
        _decryptedDetails = detailsAsync;
        _isLoadingDetails = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '${l10n.failedToDecryptOrderDetails}: $e';
        _isLoadingDetails = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width < 600 ? 16.0 : 48.0;
    final isNarrow = width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.orderDetails} #${widget.order.id.substring(0, 8)}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
            onPressed: _loadOrderDetails,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'copy_id':
                  _copyOrderId();
                  break;
                case 'copy_customer':
                  _copyCustomerPubkey();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'copy_id',
                child: Row(
                  children: [
                    const Icon(Icons.copy, size: 20),
                    const SizedBox(width: 8),
                    Text(l10n.copyOrderId),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'copy_customer',
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 20),
                    const SizedBox(width: 8),
                    Text(l10n.copyCustomerPubkey),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadOrderDetails,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusSection(l10n),
              const SizedBox(height: 24),
              _buildDetailsSection(l10n, isNarrow),
              const SizedBox(height: 24),
              _buildActionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.order.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.order.status.iconData,
                    color: widget.order.status.color,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.order.status.displayName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        widget.order.status.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(l10n.orderId, '#${widget.order.id.substring(0, 8)}...'),
            _buildInfoRow(l10n.createdAt, _formatDateTime(widget.order.createdAt)),
            if (widget.order.updatedAt != null)
              _buildInfoRow(l10n.updatedLabel, _formatDateTime(widget.order.updatedAt!)),
            if (widget.order.estimatedReady != null)
              _buildInfoRow(l10n.estimatedReadyLabel, _formatDateTime(widget.order.estimatedReady!)),
            if (widget.order.stallName != null)
              _buildInfoRow(l10n.stallName, widget.order.stallName!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(AppLocalizations l10n, bool isNarrow) {
    if (_isLoadingDetails) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
                child: Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(l10n.decryptingOrderDetails),
              ],
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadOrderDetails,
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_decryptedDetails == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.lock_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(l10n.orderDetailsEncrypted),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadOrderDetails,
                child: Text(l10n.decryptDetails),
              ),
            ],
          ),
        ),
      );
    }

    final details = _decryptedDetails!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Customer Information
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.customerInformation ?? l10n.customer,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Divider(height: 16),
                if (details.name != null)
                  _buildInfoRow(l10n.nameLabel, details.name!),
                _buildInfoRow(l10n.nostrPubkeyLabel, details.contact.nostr.substring(0, 16) + '...'),
                if (details.contact.phone != null)
                  _buildInfoRow(l10n.phoneLabel, details.contact.phone!),
                if (details.contact.email != null)
                  _buildInfoRow(l10n.emailLabel, details.contact.email!),
                if (details.address != null)
                  _buildInfoRow(l10n.addressLabel, details.address!),
                if (details.message != null && details.message!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.message, size: 16, color: Colors.blue[700]),
                            const SizedBox(width: 4),
                            Text(
                              l10n.messageLabel,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(details.message!),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Order Items
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.orderItems,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Divider(height: 16),
                ...details.items.map((item) => _buildOrderItem(item)),
                const Divider(height: 16),
                if (details.subtotal != null)
                  _buildPriceRow(l10n.subtotal, details.subtotal!),
                if (details.shippingCost != null)
                  _buildPriceRow(l10n.shipping, details.shippingCost!),
                if (details.discount != null && details.discount! > 0)
                  _buildPriceRow(l10n.discount, -details.discount!, isDiscount: true),
                if (details.total != null) ...[
                  const Divider(height: 16),
                  _buildPriceRow(l10n.totalLabel, details.total!, isBold: true),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Payment Information
        if (details.paymentHash != null || details.paymentPreimage != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.paymentDetails,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Divider(height: 16),
                  if (details.paymentHash != null)
                    _buildInfoRow(l10n.paymentHashLabel, details.paymentHash!.substring(0, 16) + '...'),
                  if (details.paymentPreimage != null)
                    _buildInfoRow(l10n.paymentProofLabel, details.paymentPreimage!.substring(0, 16) + '...'),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        // Lightning Payment
        OrderPaymentWidget(order: widget.order),
      ],
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${item.quantity}x',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? item.productId,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (item.notes != null && item.notes!.isNotEmpty)
                  Text(
                    item.notes!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
          if (item.price != null)
            Text(
              '${(item.price! * item.quantity).toStringAsFixed(2)} THB',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, int amount, {bool isBold = false, bool isDiscount = false}) {
    final color = isDiscount ? Colors.green : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            '${isDiscount ? "-" : ""}${(amount / 100).toStringAsFixed(2)} THB',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: isBold ? 16 : 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.updateOrderStatus,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: OrderStatus.values.map((status) {
                final isCurrentStatus = status == widget.order.status;
                return ActionChip(
                  label: Text(status.displayName),
                  avatar: Icon(status.iconData, size: 18),
                  onPressed: isCurrentStatus ? null : () => _updateOrderStatus(status),
                  backgroundColor: isCurrentStatus ? status.color.withOpacity(0.2) : null,
                  side: isCurrentStatus
                      ? BorderSide(color: status.color, width: 2)
                      : null,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _updateOrderStatus(OrderStatus newStatus) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.updateOrderStatus),
        content: Text('${l10n.confirm}? ${newStatus.displayName}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final authState = await ref.read(authProvider.future);
      final privateKey = authState.privateKey;

      if (privateKey == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.authenticationRequired)),
          );
        }
        return;
      }

      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.updatingOrderStatus)),
        );
      }

      await ref.read(orderNotifierProvider.notifier).updateOrderStatus(
            orderId: widget.order.id,
            newStatus: newStatus,
            privateKey: privateKey,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.orderStatusUpdated(newStatus.displayName))),
        );
        Navigator.pop(context); // Return to previous screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToUpdateStatus(e.toString()))),
        );
      }
    }
  }

  void _copyOrderId() {
    Clipboard.setData(ClipboardData(text: widget.order.id));
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.copiedToClipboard(l10n.orderId))),
    );
  }

  void _copyCustomerPubkey() {
    Clipboard.setData(ClipboardData(text: widget.order.customerPubkey));
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.copiedToClipboard(l10n.nostrPubkeyLabel))),
    );
  }
}
