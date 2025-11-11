import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../../orders/providers/order_provider.dart';

/// Receipts screen backed by completed orders from the orders provider.
class ReceiptsScreen extends ConsumerWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final orders = ref.watch(completedOrdersProvider);

    // Show most recent 20 completed orders as receipts
    final receipts = orders.reversed.take(20).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.receiptsTitle),
        centerTitle: true,
      ),
      body: receipts.isEmpty
          ? Center(
              child: Text(l10n.noDataAvailable),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12.0),
              itemCount: receipts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = receipts[index];
                final title = order.stallName ?? '${l10n.orderLabel} ${order.id}';
                final date = order.createdAt.toIso8601String().split('T').first;
                final amount = order.details?.total != null
                    ? '${l10n.currencySymbol}${order.details!.total}'
                    : l10n.notAvailable;

                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: Theme.of(context).textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              date,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(AppLocalizations.of(context)!.labelWithValue(l10n.receiptsAmountPrefix, amount)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _showReceiptDetail(context, order),
                              icon: const Icon(Icons.receipt_long),
                              label: Text(l10n.receiptsView),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.receiptCopied)),
                                );
                              },
                              child: Text(l10n.receiptsCopyId),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showReceiptDetail(BuildContext context, dynamic r) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.receiptDetailTitle(r.id)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.labelWithValue(l10n.receiptLabelTitle, r.stallName ?? '')),
            const SizedBox(height: 8),
            Text(l10n.labelWithValue(l10n.receiptLabelDate, r.createdAt.toIso8601String().split('T').first)),
            const SizedBox(height: 8),
            Text(l10n.labelWithValue(l10n.receiptLabelAmount, (r.details?.total ?? l10n.notAvailable).toString())),
            const SizedBox(height: 8),
            Text(l10n.labelWithValue(l10n.receiptLabelItems, (r.details?.items.map((i) => i.productName ?? i.productId).join(', ')) ?? l10n.notAvailable)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

}
