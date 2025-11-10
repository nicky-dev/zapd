import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

/// Notification state
class NotificationState {
  final List<AppNotification> notifications;
  final int unreadCount;
  final bool isLoading;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
  });

  NotificationState copyWith({
    List<AppNotification>? notifications,
    int? unreadCount,
    bool? isLoading,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notification provider
class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationService _service;
  final Uuid _uuid = const Uuid();

  NotificationNotifier(this._service) : super(const NotificationState()) {
    loadNotifications();
  }

  /// Load notifications from storage
  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final notifications = await _service.getNotifications();
      final unreadCount = await _service.getUnreadCount();
      
      state = NotificationState(
        notifications: notifications,
        unreadCount: unreadCount,
        isLoading: false,
      );
    } catch (e) {
      print('Error loading notifications: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// Add a new notification
  Future<void> addNotification({
    required NotificationType type,
    required String title,
    required String message,
    String? orderId,
    String? paymentId,
    String? stallId,
    Map<String, dynamic>? metadata,
  }) async {
    final notification = AppNotification(
      id: _uuid.v4(),
      type: type,
      title: title,
      message: message,
      timestamp: DateTime.now(),
      orderId: orderId,
      paymentId: paymentId,
      stallId: stallId,
      metadata: metadata,
    );

    await _service.addNotification(notification);
    await loadNotifications();
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _service.markAsRead(notificationId);
    await loadNotifications();
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    await _service.markAllAsRead();
    await loadNotifications();
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await _service.deleteNotification(notificationId);
    await loadNotifications();
  }

  /// Clear all notifications
  Future<void> clearAll() async {
    await _service.clearAll();
    await loadNotifications();
  }

  /// Notify new order
  Future<void> notifyNewOrder(String orderId, String customerName) async {
    await addNotification(
      type: NotificationType.newOrder,
      title: 'New Order',
      message: 'New order from $customerName',
      orderId: orderId,
    );
  }

  /// Notify order update
  Future<void> notifyOrderUpdate(String orderId, String status) async {
    await addNotification(
      type: NotificationType.orderUpdate,
      title: 'Order Update',
      message: 'Order #${orderId.substring(0, 8)} is now $status',
      orderId: orderId,
    );
  }

  /// Notify payment
  Future<void> notifyPayment(String orderId, double amount) async {
    await addNotification(
      type: NotificationType.payment,
      title: 'Payment Received',
      message: 'Payment of ฿$amount received for order #${orderId.substring(0, 8)}',
      orderId: orderId,
    );
  }
}

/// Provider for notification state
final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return NotificationNotifier(service);
});

/// Provider for unread count
final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).unreadCount;
});
