import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../repositories/order_repository.dart';
import '../../../core/providers/nostr_provider.dart';

/// Provider for OrderRepository
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final nostrClient = ref.watch(nostrClientProvider);
  final merchantPubkey = ref.watch(currentUserPubkeyProvider);

  return OrderRepository(
    nostrClient: nostrClient,
    merchantPubkey: merchantPubkey ?? '',
  );
});

/// Stream provider for real-time orders
final ordersStreamProvider = StreamProvider<Order>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.subscribeToOrders();
});

/// Provider for fetching order details
final orderDetailsProvider = FutureProvider.family<OrderDetails?, ({String orderId, String customerPubkey, String privateKey})>(
  (ref, params) async {
    final repository = ref.watch(orderRepositoryProvider);
    return repository.fetchOrderDetails(
      orderId: params.orderId,
      customerPubkey: params.customerPubkey,
      privateKey: params.privateKey,
    );
  },
);

/// State notifier for managing orders
class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier(this.ref) : super([]) {
    _listenToOrders();
  }

  final Ref ref;

  void _listenToOrders() {
    final ordersStream = ref.watch(ordersStreamProvider);
    ordersStream.whenData((order) {
      // Add or update order in list
      final existingIndex = state.indexWhere((o) => o.id == order.id);
      if (existingIndex >= 0) {
        // Update existing
        final newState = [...state];
        newState[existingIndex] = order;
        state = newState;
      } else {
        // Add new
        state = [...state, order];
      }
    });
  }

  List<Order> getOrdersByStatus(OrderStatus status) {
    return state.where((order) => order.status == status).toList();
  }

  List<Order> getActiveOrders() {
    return state.where((order) => order.status.isActive).toList();
  }

  Future<void> acceptOrder(Order order, String privateKey, {DateTime? estimatedReady}) async {
    try {
      final repository = ref.read(orderRepositoryProvider);
      await repository.acceptOrder(
        order: order,
        privateKey: privateKey,
        estimatedReady: estimatedReady,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> cancelOrder(Order order, String privateKey, String reason) async {
    try {
      final repository = ref.read(orderRepositoryProvider);
      await repository.cancelOrder(
        order: order,
        privateKey: privateKey,
        reason: reason,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> markPreparing(Order order, String privateKey, {DateTime? estimatedReady}) async {
    try {
      final repository = ref.read(orderRepositoryProvider);
      await repository.markPreparing(
        order: order,
        privateKey: privateKey,
        estimatedReady: estimatedReady,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> markReady(Order order, String privateKey) async {
    try {
      final repository = ref.read(orderRepositoryProvider);
      await repository.markReady(
        order: order,
        privateKey: privateKey,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> assignRider({
    required Order order,
    required String riderPubkey,
    required OrderDetails orderDetails,
    required String privateKey,
  }) async {
    try {
      final repository = ref.read(orderRepositoryProvider);
      await repository.assignRider(
        order: order,
        riderPubkey: riderPubkey,
        orderDetails: orderDetails,
        privateKey: privateKey,
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Generic method to update order status
  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
    required String privateKey,
    DateTime? estimatedReady,
    String? reason,
  }) async {
    final order = state.firstWhere((o) => o.id == orderId);
    final repository = ref.read(orderRepositoryProvider);

    switch (newStatus) {
      case OrderStatus.accepted:
        await repository.acceptOrder(
          order: order,
          privateKey: privateKey,
          estimatedReady: estimatedReady,
        );
        break;
      case OrderStatus.preparing:
        await repository.markPreparing(
          order: order,
          privateKey: privateKey,
          estimatedReady: estimatedReady,
        );
        break;
      case OrderStatus.ready:
        await repository.markReady(
          order: order,
          privateKey: privateKey,
        );
        break;
      case OrderStatus.cancelled:
        await repository.cancelOrder(
          order: order,
          privateKey: privateKey,
          reason: reason ?? 'Order cancelled',
        );
        break;
      default:
        throw UnimplementedError('Status $newStatus not yet implemented');
    }
  }
}

/// Provider for OrderNotifier
final orderNotifierProvider = StateNotifierProvider<OrderNotifier, List<Order>>((ref) {
  return OrderNotifier(ref);
});

/// Derived providers for filtering orders
final pendingOrdersProvider = Provider<List<Order>>((ref) {
  final orders = ref.watch(orderNotifierProvider);
  return orders.where((o) => o.status == OrderStatus.pending).toList();
});

final activeOrdersProvider = Provider<List<Order>>((ref) {
  final orders = ref.watch(orderNotifierProvider);
  return orders.where((o) => o.status.isActive).toList();
});

final completedOrdersProvider = Provider<List<Order>>((ref) {
  final orders = ref.watch(orderNotifierProvider);
  return orders.where((o) => o.status == OrderStatus.completed).toList();
});
