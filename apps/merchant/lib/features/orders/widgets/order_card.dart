import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../providers/order_provider.dart';
import '../../../core/providers/nostr_provider.dart';
import '../screens/order_detail_screen.dart';

class OrderCard extends ConsumerWidget {
  const OrderCard({
    super.key,
    required this.order,
  });

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(order: order),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Order ID + Status
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id.substring(0, 8)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDateTime(order.createdAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                  _StatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 12),

              // Stall name
              Row(
                children: [
                  Icon(Icons.store, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    order.stallName?.isNotEmpty == true ? order.stallName! : 'Unknown Stall',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Show estimated ready time if available
              if (order.estimatedReady != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Ready: ${_formatDateTime(order.estimatedReady!)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Action buttons based on status
              _buildActionButtons(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    switch (order.status) {
      case OrderStatus.pending:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _rejectOrder(context, ref),
                icon: const Icon(Icons.close, size: 18),
                label: const Text('Reject'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () => _acceptOrder(context, ref),
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Accept'),
              ),
            ),
          ],
        );

      case OrderStatus.accepted:
        return ElevatedButton.icon(
          onPressed: () => _markPreparing(context, ref),
          icon: const Icon(Icons.restaurant, size: 18),
          label: const Text('Start Preparing'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 40),
          ),
        );

      case OrderStatus.preparing:
        return ElevatedButton.icon(
          onPressed: () => _markReady(context, ref),
          icon: const Icon(Icons.check_circle, size: 18),
          label: const Text('Mark as Ready'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 40),
          ),
        );

      case OrderStatus.ready:
        return ElevatedButton.icon(
          onPressed: () => _assignRider(context, ref),
          icon: const Icon(Icons.delivery_dining, size: 18),
          label: const Text('Assign Rider'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 40),
          ),
        );

      case OrderStatus.delivering:
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return SizedBox(
          width: double.infinity,
          child: Text(
            order.status.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ),
        );
    }
  }

  Future<void> _acceptOrder(BuildContext context, WidgetRef ref) async {
    final privateKey = ref.read(currentUserPrivateKeyProvider);
    if (privateKey == null) {
      _showError(context, 'Private key not available');
      return;
    }

    try {
      final estimatedReady = DateTime.now().add(const Duration(minutes: 30));
      await ref.read(orderNotifierProvider.notifier).acceptOrder(
            order,
            privateKey,
            estimatedReady: estimatedReady,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order accepted')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to accept: $e');
      }
    }
  }

  Future<void> _rejectOrder(BuildContext context, WidgetRef ref) async {
    final privateKey = ref.read(currentUserPrivateKeyProvider);
    if (privateKey == null) {
      _showError(context, 'Private key not available');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Order'),
        content: const Text('Are you sure you want to reject this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(orderNotifierProvider.notifier).cancelOrder(
              order,
              privateKey,
              'Rejected by merchant',
            );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order rejected')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          _showError(context, 'Failed to reject: $e');
        }
      }
    }
  }

  Future<void> _markPreparing(BuildContext context, WidgetRef ref) async {
    final privateKey = ref.read(currentUserPrivateKeyProvider);
    if (privateKey == null) return;

    try {
      await ref.read(orderNotifierProvider.notifier).markPreparing(
            order,
            privateKey,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order is being prepared')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed: $e');
      }
    }
  }

  Future<void> _markReady(BuildContext context, WidgetRef ref) async {
    final privateKey = ref.read(currentUserPrivateKeyProvider);
    if (privateKey == null) return;

    try {
      await ref.read(orderNotifierProvider.notifier).markReady(order, privateKey);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order is ready for pickup')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed: $e');
      }
    }
  }

  void _assignRider(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rider assignment - Coming soon...')),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        break;
      case OrderStatus.accepted:
      case OrderStatus.preparing:
        color = Colors.blue;
        break;
      case OrderStatus.ready:
      case OrderStatus.delivering:
        color = Colors.purple;
        break;
      case OrderStatus.completed:
        color = Colors.green;
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(status.icon),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
