import 'package:flutter/material.dart';

enum OrderStatus {
  pending,
  accepted,
  preparing,
  ready,
  delivering,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.delivering:
        return 'Delivering';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get icon {
    switch (this) {
      case OrderStatus.pending:
        return '⏳';
      case OrderStatus.accepted:
        return '✅';
      case OrderStatus.preparing:
        return '👨‍🍳';
      case OrderStatus.ready:
        return '📦';
      case OrderStatus.delivering:
        return '🚚';
      case OrderStatus.completed:
        return '🎉';
      case OrderStatus.cancelled:
        return '❌';
    }
  }

  IconData get iconData {
    switch (this) {
      case OrderStatus.pending:
        return Icons.schedule;
      case OrderStatus.accepted:
        return Icons.check_circle;
      case OrderStatus.preparing:
        return Icons.restaurant;
      case OrderStatus.ready:
        return Icons.inventory_2;
      case OrderStatus.delivering:
        return Icons.local_shipping;
      case OrderStatus.completed:
        return Icons.done_all;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.accepted:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.delivering:
        return Colors.teal;
      case OrderStatus.completed:
        return Colors.green.shade700;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.pending:
        return 'Waiting for merchant to accept';
      case OrderStatus.accepted:
        return 'Order accepted by merchant';
      case OrderStatus.preparing:
        return 'Food is being prepared';
      case OrderStatus.ready:
        return 'Order is ready for pickup';
      case OrderStatus.delivering:
        return 'Rider is on the way';
      case OrderStatus.completed:
        return 'Order delivered successfully';
      case OrderStatus.cancelled:
        return 'Order was cancelled';
    }
  }

  bool get canCancel {
    return this == OrderStatus.pending || this == OrderStatus.accepted;
  }

  bool get isActive {
    return this != OrderStatus.completed && this != OrderStatus.cancelled;
  }
}
