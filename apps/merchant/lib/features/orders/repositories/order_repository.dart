import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nostr_core/nostr_core.dart';
import '../models/order.dart';
import '../models/order_status.dart';

/// Repository for managing Orders using NIP-15 Checkout Protocol
/// NIP-15 defines 3 message types exchanged via kind 4 DMs:
/// - Type 0: Customer Order (encrypted order details)
/// - Type 1: Payment Request (merchant sends payment options)
/// - Type 2: Order Status Update (paid/shipped confirmation)
class OrderRepository {
  final NostrClient nostrClient;
  final String merchantPubkey;

  OrderRepository({
    required this.nostrClient,
    required this.merchantPubkey,
  });

  /// Sign an unsigned event with private key
  NostrEvent _signEvent(NostrEvent unsignedEvent, String privateKey) {
    final signature = Schnorr.sign(unsignedEvent.id, privateKey);
    return NostrEvent(
      id: unsignedEvent.id,
      pubkey: unsignedEvent.pubkey,
      createdAt: unsignedEvent.createdAt,
      kind: unsignedEvent.kind,
      tags: unsignedEvent.tags,
      content: unsignedEvent.content,
      sig: signature,
    );
  }

  /// Subscribe to incoming orders (kind 4 DMs from customers)
  /// Listens for Type 0 messages (customer orders)
  Stream<Order> subscribeToOrders() {
    final filter = NostrFilter(
      kinds: const [4], // NIP-04 encrypted DM (or kind 14 for NIP-44)
      tags: {
        'p': [merchantPubkey]
      }, // Orders sent to merchant
    );

    final subscription = nostrClient.subscribe([filter]);

    return subscription.stream.asyncMap((event) async {
      return await _parseOrderFromDM(event);
    }).where((order) => order != null).cast<Order>();
  }

  /// Parse Order from encrypted DM event
  /// Decrypts and checks if it's a Type 0 (customer order) message
  Future<Order?> _parseOrderFromDM(NostrEvent event) async {
    try {
      // For NIP-04/NIP-44, we need merchant's private key to decrypt
      // This should be passed from the calling context
      // For now, we'll return a placeholder that needs decryption
      
      return Order(
        id: event.id, // Use event ID as order ID temporarily
        customerPubkey: event.pubkey,
        merchantPubkey: merchantPubkey,
        status: OrderStatus.pending,
        createdAt: DateTime.fromMillisecondsSinceEpoch(event.createdAt * 1000),
        detailsEventId: event.id,
        // Details will be decrypted separately
      );
    } catch (e) {
      debugPrint('Error parsing order from DM: $e');
      return null;
    }
  }

  /// Decrypt and parse order details from kind 4 event
  Future<OrderDetails?> decryptOrderDetails({
    required NostrEvent event,
    required String privateKey,
  }) async {
    try {
      // Decrypt using NIP-44
      final conversationKey = NIP44.getConversationKey(
        privateKey,
        event.pubkey, // customer's pubkey
      );
      final decryptedContent = await NIP44.decrypt(event.content, conversationKey);
      final detailsJson = jsonDecode(decryptedContent) as Map<String, dynamic>;

      // Check if it's Type 0 (customer order)
      if (detailsJson['type'] != 0) {
        debugPrint('Not a customer order message, type: ${detailsJson['type']}');
        return null;
      }

      return OrderDetails.fromJson(detailsJson);
    } catch (e) {
      debugPrint('Error decrypting order details: $e');
      return null;
    }
  }

  /// Fetch order details by order ID
  Future<OrderDetails?> fetchOrderDetails({
    required String orderId,
    required String customerPubkey,
    required String privateKey,
  }) async {
    final filter = NostrFilter(
      kinds: const [4], // NIP-04 encrypted DM
      authors: [customerPubkey],
      tags: {
        'p': [merchantPubkey],
      },
    );

    final subscription = nostrClient.subscribe([filter]);
    OrderDetails? result;

    await for (final event in subscription.stream.timeout(
      const Duration(seconds: 5),
      onTimeout: (sink) => sink.close(),
    )) {
      try {
        final details = await decryptOrderDetails(
          event: event,
          privateKey: privateKey,
        );
        
        if (details != null && details.id == orderId) {
          result = details;
          break;
        }
      } catch (e) {
        debugPrint('Error fetching order details: $e');
      }
    }

    subscription.onClose();
    return result;
  }

  /// Send Payment Request (Type 1) to customer
  /// After receiving order, merchant sends payment options
  Future<void> sendPaymentRequest({
    required String orderId,
    required String customerPubkey,
    required List<PaymentOption> paymentOptions,
    required String privateKey,
    String? message,
  }) async {
    final paymentRequest = PaymentRequest(
      id: orderId,
      type: 1,
      message: message,
      paymentOptions: paymentOptions,
    );

    final conversationKey = NIP44.getConversationKey(
      privateKey,
      customerPubkey,
    );

    final encryptedContent = await NIP44.encrypt(
      jsonEncode(paymentRequest.toJson()),
      conversationKey,
    );

    final tags = <List<String>>[
      ['p', customerPubkey],
      ['e', orderId], // Reference to original order event
    ];

    final unsignedEvent = EventBuilder()
        .pubkey(merchantPubkey)
        .kind(4) // Encrypted DM
        .content(encryptedContent)
        .addTags(tags)
        .build();

    final signedEvent = _signEvent(unsignedEvent, privateKey);
    await nostrClient.publish(signedEvent);

  debugPrint('Payment request sent for order $orderId');
  }

  /// Send Order Status Update (Type 2) to customer
  /// Merchant confirms payment received and shipping status
  Future<void> sendOrderStatusUpdate({
    required String orderId,
    required String customerPubkey,
    required bool paid,
    required bool shipped,
    required String privateKey,
    String? message,
  }) async {
    final statusUpdate = OrderStatusUpdate(
      id: orderId,
      type: 2,
      message: message,
      paid: paid,
      shipped: shipped,
    );

    final conversationKey = NIP44.getConversationKey(
      privateKey,
      customerPubkey,
    );

    final encryptedContent = await NIP44.encrypt(
      jsonEncode(statusUpdate.toJson()),
      conversationKey,
    );

    final tags = <List<String>>[
      ['p', customerPubkey],
      ['e', orderId],
    ];

    final unsignedEvent = EventBuilder()
        .pubkey(merchantPubkey)
        .kind(4)
        .content(encryptedContent)
        .addTags(tags)
        .build();

    final signedEvent = _signEvent(unsignedEvent, privateKey);
    await nostrClient.publish(signedEvent);

  debugPrint('Order status update sent: paid=$paid, shipped=$shipped');
  }

  /// Update internal order status (for merchant tracking)
  /// This is separate from NIP-15 status updates
  Future<void> updateOrderStatus({
    required String orderId,
    required String customerPubkey,
    required OrderStatus newStatus,
    required String privateKey,
    DateTime? estimatedReady,
    String? stallId,
  }) async {
    // For food delivery extension, we track additional states
    // We can use kind 30078 for merchant's internal tracking
    final tags = <List<String>>[
      ['d', orderId],
      ['p', customerPubkey],
      ['status', newStatus.name],
      ['updated_at', DateTime.now().millisecondsSinceEpoch.toString()],
    ];

    if (stallId != null) {
      tags.add(['stall_id', stallId]);
    }

    if (estimatedReady != null) {
      tags.add([
        'estimated_ready',
        (estimatedReady.millisecondsSinceEpoch ~/ 1000).toString()
      ]);
    }

    final unsignedEvent = EventBuilder()
        .pubkey(merchantPubkey)
        .kind(30078) // Custom status tracking (food delivery extension)
        .content('')
        .addTags(tags)
        .build();

    final signedEvent = _signEvent(unsignedEvent, privateKey);
    await nostrClient.publish(signedEvent);

    // Also send NIP-15 status update if order is paid/shipped
    if (newStatus == OrderStatus.completed) {
      await sendOrderStatusUpdate(
        orderId: orderId,
        customerPubkey: customerPubkey,
        paid: true,
        shipped: true,
        privateKey: privateKey,
        message: 'Order completed',
      );
    }
  }

  /// Accept order (merchant action)
  Future<void> acceptOrder({
    required Order order,
    required String privateKey,
    DateTime? estimatedReady,
  }) async {
    await updateOrderStatus(
      orderId: order.id,
      customerPubkey: order.customerPubkey,
      newStatus: OrderStatus.accepted,
      privateKey: privateKey,
      estimatedReady: estimatedReady,
      stallId: order.stallId,
    );
  }

  /// Reject/Cancel order
  Future<void> cancelOrder({
    required Order order,
    required String privateKey,
    required String reason,
  }) async {
    await updateOrderStatus(
      orderId: order.id,
      customerPubkey: order.customerPubkey,
      newStatus: OrderStatus.cancelled,
      privateKey: privateKey,
      stallId: order.stallId,
    );

    // Send cancellation notice to customer (encrypted)
    await _sendOrderNotice(
      customerPubkey: order.customerPubkey,
      orderId: order.id,
      message: 'Order cancelled: $reason',
      privateKey: privateKey,
    );
  }

  /// Mark order as preparing
  Future<void> markPreparing({
    required Order order,
    required String privateKey,
    DateTime? estimatedReady,
  }) async {
    await updateOrderStatus(
      orderId: order.id,
      customerPubkey: order.customerPubkey,
      newStatus: OrderStatus.preparing,
      privateKey: privateKey,
      estimatedReady: estimatedReady,
      stallId: order.stallId,
    );
  }

  /// Mark order as ready
  Future<void> markReady({
    required Order order,
    required String privateKey,
  }) async {
    await updateOrderStatus(
      orderId: order.id,
      customerPubkey: order.customerPubkey,
      newStatus: OrderStatus.ready,
      privateKey: privateKey,
      stallId: order.stallId,
    );
  }

  /// Assign rider to order (send encrypted details to rider)
  /// In NIP-15 context, this is an extension for food delivery
  Future<void> assignRider({
    required Order order,
    required String riderPubkey,
    required OrderDetails orderDetails,
    required String privateKey,
  }) async {
    // Create rider assignment message
    final assignmentData = {
      'order_id': order.id,
      'pickup_location': {
        'name': order.stallName ?? 'Unknown',
        'stall_id': order.stallId,
      },
      'delivery_location': {
        'address': orderDetails.address ?? 'No address provided',
      },
      'shipping_cost': orderDetails.shippingCost ?? 0,
      'customer_contact': {
        'nostr': orderDetails.contact.nostr,
        'phone': orderDetails.contact.phone,
      },
      'items_summary': orderDetails.items.map((item) => {
        'name': item.productName ?? 'Unknown product',
        'quantity': item.quantity,
      }).toList(),
      'total': orderDetails.total ?? 0,
    };

    // Encrypt for rider using NIP-44
    final conversationKey = NIP44.getConversationKey(privateKey, riderPubkey);
    final encryptedContent = await NIP44.encrypt(
      jsonEncode(assignmentData),
      conversationKey,
    );

    final tags = <List<String>>[
      ['p', riderPubkey],
      ['e', order.id], // Reference to order
    ];

    final unsignedEvent = EventBuilder()
        .pubkey(merchantPubkey)
        .kind(4) // Encrypted DM
        .content(encryptedContent)
        .addTags(tags)
        .build();

    final signedEvent = _signEvent(unsignedEvent, privateKey);
    await nostrClient.publish(signedEvent);

  debugPrint('Rider assigned to order ${order.id}');
  }

  /// Send encrypted notice to customer
  Future<void> _sendOrderNotice({
    required String customerPubkey,
    required String orderId,
    required String message,
    required String privateKey,
  }) async {
    final conversationKey = NIP44.getConversationKey(
      privateKey,
      customerPubkey,
    );

    final encryptedContent = await NIP44.encrypt(
      jsonEncode({'order_id': orderId, 'message': message}),
      conversationKey,
    );

    final unsignedEvent = EventBuilder()
        .pubkey(merchantPubkey)
        .kind(4)
        .content(encryptedContent)
        .addTag(['p', customerPubkey])
        .addTag(['e', orderId])
        .build();

    final signedEvent = _signEvent(unsignedEvent, privateKey);
    await nostrClient.publish(signedEvent);
  }
}
