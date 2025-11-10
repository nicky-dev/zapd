import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../models/order_status.dart';
import '../widgets/order_card.dart';

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  OrderStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderNotifierProvider);
    final filteredOrders = _filterStatus == null
        ? orders
        : orders.where((o) => o.status == _filterStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          PopupMenuButton<OrderStatus?>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter by status',
            onSelected: (status) {
              setState(() {
                _filterStatus = status;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('All Orders'),
              ),
              const PopupMenuDivider(),
              ...OrderStatus.values.map((status) {
                return PopupMenuItem(
                  value: status,
                  child: Row(
                    children: [
                      Text(status.icon),
                      const SizedBox(width: 8),
                      Text(status.displayName),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Status summary chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _StatusChip(
                  label: 'All',
                  count: orders.length,
                  isSelected: _filterStatus == null,
                  onTap: () => setState(() => _filterStatus = null),
                ),
                const SizedBox(width: 8),
                ...OrderStatus.values.map((status) {
                  final count = orders.where((o) => o.status == status).length;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _StatusChip(
                      label: status.displayName,
                      count: count,
                      icon: status.icon,
                      isSelected: _filterStatus == status,
                      onTap: () => setState(() => _filterStatus = status),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Order list
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _filterStatus == null
                              ? 'No orders yet'
                              : 'No ${_filterStatus!.displayName.toLowerCase()} orders',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Orders will appear here when customers place them',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      return OrderCard(order: filteredOrders[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final int count;
  final String? icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Text(icon!),
            const SizedBox(width: 4),
          ],
          Text(label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withOpacity(0.3)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
    );
  }
}
