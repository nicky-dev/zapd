import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/notification.dart';

/// Notification service for managing app notifications
class NotificationService {
  static const String _keyNotifications = 'notifications';
  static const int _maxNotifications = 100;

  final SharedPreferences _prefs;

  NotificationService(this._prefs);

  /// Get all notifications
  Future<List<AppNotification>> getNotifications() async {
    try {
      final String? data = _prefs.getString(_keyNotifications);
      if (data == null) return [];

      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList
          .map((json) => AppNotification.fromJson(json))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      print('Error loading notifications: $e');
      return [];
    }
  }

  /// Add a new notification
  Future<void> addNotification(AppNotification notification) async {
    try {
      final notifications = await getNotifications();
      notifications.insert(0, notification);

      // Keep only the last N notifications
      if (notifications.length > _maxNotifications) {
        notifications.removeRange(_maxNotifications, notifications.length);
      }

      await _saveNotifications(notifications);
    } catch (e) {
      print('Error adding notification: $e');
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final notifications = await getNotifications();
      final index = notifications.indexWhere((n) => n.id == notificationId);
      
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        await _saveNotifications(notifications);
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final notifications = await getNotifications();
      final updated = notifications.map((n) => n.copyWith(isRead: true)).toList();
      await _saveNotifications(updated);
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      final notifications = await getNotifications();
      notifications.removeWhere((n) => n.id == notificationId);
      await _saveNotifications(notifications);
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  /// Clear all notifications
  Future<void> clearAll() async {
    try {
      await _prefs.remove(_keyNotifications);
    } catch (e) {
      print('Error clearing notifications: $e');
    }
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    try {
      final notifications = await getNotifications();
      return notifications.where((n) => !n.isRead).length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  /// Save notifications to storage
  Future<void> _saveNotifications(List<AppNotification> notifications) async {
    try {
      final jsonList = notifications.map((n) => n.toJson()).toList();
      final data = jsonEncode(jsonList);
      await _prefs.setString(_keyNotifications, data);
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }
}

/// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

/// Provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return NotificationService(prefs);
});
