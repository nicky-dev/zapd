import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/language_switcher.dart';
import '../../../l10n/app_localizations.dart';
import '../models/notification.dart';
import '../providers/notification_provider.dart';

/// Notifications screen
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notificationState = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        actions: [
          const LanguageSwitcher(),
          if (notificationState.unreadCount > 0)
            TextButton.icon(
              onPressed: () {
                ref.read(notificationProvider.notifier).markAllAsRead();
              },
              icon: const Icon(Icons.done_all),
              label: Text(l10n.markAllAsRead),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_all') {
                _showClearAllDialog(context, ref);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline, size: 20),
                    const SizedBox(width: 8),
                    Text(l10n.clearAll),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: notificationState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificationState.notifications.isEmpty
              ? _buildEmptyState(context)
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(notificationProvider.notifier).loadNotifications();
                  },
                  child: ListView.separated(
                    itemCount: notificationState.notifications.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final notification = notificationState.notifications[index];
                      return _NotificationTile(notification: notification);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noNotifications,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearAllConfirm),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              ref.read(notificationProvider.notifier).clearAll();
              Navigator.pop(context);
            },
            child: Text(l10n.clearAll),
          ),
        ],
      ),
    );
  }
}

/// Notification tile widget
class _NotificationTile extends ConsumerWidget {
  final AppNotification notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        ref.read(notificationProvider.notifier).deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.notificationDeleted),
            action: SnackBarAction(
              label: l10n.undo,
              onPressed: () {
                // TODO: Implement undo
              },
            ),
          ),
        );
      },
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getTypeColor(notification.type).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getTypeIcon(notification.type),
            color: _getTypeColor(notification.type),
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(context, notification.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
        tileColor: notification.isRead ? null : Colors.blue.withOpacity(0.05),
        onTap: () {
          if (!notification.isRead) {
            ref.read(notificationProvider.notifier).markAsRead(notification.id);
          }
          _handleNotificationTap(context, ref, notification);
        },
      ),
    );
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.newOrder:
        return Icons.shopping_bag;
      case NotificationType.orderUpdate:
        return Icons.update;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.system:
        return Icons.info;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.newOrder:
        return Colors.green;
      case NotificationType.orderUpdate:
        return Colors.blue;
      case NotificationType.payment:
        return Colors.orange;
      case NotificationType.system:
        return Colors.grey;
    }
  }

  String _formatTimestamp(BuildContext context, DateTime timestamp) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return l10n.justNow;
    } else if (difference.inHours < 1) {
      return l10n.minutesAgo(difference.inMinutes);
    } else if (difference.inDays < 1) {
      return l10n.hoursAgo(difference.inHours);
    } else if (difference.inDays < 7) {
      return l10n.daysAgo(difference.inDays);
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _handleNotificationTap(BuildContext context, WidgetRef ref, AppNotification notification) {
    final l10n = AppLocalizations.of(context)!;
    // Navigate based on notification type
    if (notification.orderId != null) {
      // TODO: Navigate to order detail
      // For now, just show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.orderId}: ${notification.orderId}')),
      );
    }
  }
}
