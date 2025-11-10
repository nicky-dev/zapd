import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

/// Notification types
enum NotificationType {
  newOrder,
  orderUpdate,
  payment,
  system,
}

/// App notification model
@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required NotificationType type,
    required String title,
    required String message,
    required DateTime timestamp,
    @Default(false) bool isRead,
    
    // Optional data for navigation
    String? orderId,
    String? paymentId,
    String? stallId,
    
    // Optional metadata
    Map<String, dynamic>? metadata,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

/// Extension for notification properties
extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.newOrder:
        return 'New Order';
      case NotificationType.orderUpdate:
        return 'Order Update';
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.system:
        return 'System';
    }
  }

  String get iconName {
    switch (this) {
      case NotificationType.newOrder:
        return 'shopping_bag';
      case NotificationType.orderUpdate:
        return 'update';
      case NotificationType.payment:
        return 'payment';
      case NotificationType.system:
        return 'notifications';
    }
  }
}
