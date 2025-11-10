import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stall.dart';
import '../providers/stall_provider.dart';
import '../../../core/providers/nostr_provider.dart';
import '../screens/stall_form_screen.dart';
import '../../products/screens/product_list_screen.dart';
import '../../../l10n/app_localizations.dart';

class StallCard extends ConsumerWidget {
  const StallCard({
    super.key,
    required this.stall,
  });

  final Stall stall;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Navigate to product list screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductListScreen(stall: stall),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Stall type icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        stall.stallType?.icon ?? '🏪',
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Stall name and type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stall.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stall.stallType?.displayName ?? AppLocalizations.of(context)!.shop,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: stall.acceptsOrders ? Colors.green[100] : Colors.red[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      stall.acceptsOrders ? AppLocalizations.of(context)!.open : AppLocalizations.of(context)!.closed,
                      style: TextStyle(
                        color: stall.acceptsOrders ? Colors.green[800] : Colors.red[800],
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              if (stall.description?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text(
                  stall.description!,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              // Action buttons
              Row(
                children: [
                  _ActionButton(
                    icon: Icons.edit,
                    label: AppLocalizations.of(context)!.edit,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StallFormScreen(stall: stall),
                        ),
                      ).then((_) {
                        // Refresh stalls list
                        ref.read(stallNotifierProvider.notifier).loadStalls();
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.content_copy,
                    label: AppLocalizations.of(context)!.duplicate,
                    onPressed: () async {
                      final privateKey = ref.read(currentUserPrivateKeyProvider);
                      if (privateKey == null) {
                        _showError(context, 'Private key not available');
                        return;
                      }

                      try {
                        await ref.read(stallNotifierProvider.notifier).duplicateStall(
                              stall,
                              privateKey,
                            );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(AppLocalizations.of(context)!.stallDuplicatedSuccess)),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          _showError(context, 'Failed to duplicate: $e');
                        }
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.inventory_2,
                    label: AppLocalizations.of(context)!.products,
                    onPressed: () => _showComingSoon(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showOptionsMenu(context, ref),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.comingSoon)),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showOptionsMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text(AppLocalizations.of(context)!.deleteStallTitle),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteStallTitle),
        content: Text(AppLocalizations.of(context)!.deleteStallConfirm(stall.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              final privateKey = ref.read(currentUserPrivateKeyProvider);
              if (privateKey == null) {
                Navigator.pop(context);
                _showError(context, 'Private key not available');
                return;
              }

              try {
                await ref.read(stallNotifierProvider.notifier).deleteStall(
                      stall.id,
                      privateKey,
                    );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.stallDeleted)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  _showError(context, 'Failed to delete: $e');
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
