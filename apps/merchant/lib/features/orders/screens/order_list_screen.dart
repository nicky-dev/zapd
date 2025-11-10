import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/language_switcher.dart';
import '../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final orders = ref.watch(orderNotifierProvider);
    final filteredOrders = _filterStatus == null
        ? orders
        : orders.where((o) => o.status == _filterStatus).toList();
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width < 600 ? 16.0 : 48.0;
    final isNarrow = width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orders),
        actions: [
          const LanguageSwitcher(),
          PopupMenuButton<OrderStatus?>(
            icon: const Icon(Icons.filter_list),
            tooltip: l10n.filterByStatus,
            onSelected: (status) {
              setState(() {
                _filterStatus = status;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: null,
                child: Text(l10n.allOrders),
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
          // Status summary chips (wrap on narrow screens)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
            child: isNarrow
                ? Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _StatusChip(
                        label: l10n.all,
                        count: orders.length,
                        isSelected: _filterStatus == null,
                        onTap: () => setState(() => _filterStatus = null),
                      ),
                      ...OrderStatus.values.map((status) {
                        final count = orders.where((o) => o.status == status).length;
                        return _StatusChip(
                          label: status.displayName,
                          count: count,
                          icon: status.icon,
                          isSelected: _filterStatus == status,
                          onTap: () => setState(() => _filterStatus = status),
                        );
                      }),
                    ],
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _StatusChip(
                          label: l10n.all,
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
          ),

          // Order list
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Semantics(
                          label: l10n.noOrdersYet,
                          child: Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noOrdersYet,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.ordersWillAppear,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
