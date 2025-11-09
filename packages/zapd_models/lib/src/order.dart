import 'package:equatable/equatable.dart';

/// Order model
class Order extends Equatable {
  final String id;
  final String customerPubkey;
  final String restaurantPubkey;
  final String? riderPubkey;
  final List<OrderItem> items;
  final OrderStatus status;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DeliveryAddress deliveryAddress; // Encrypted in Nostr
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final String? specialInstructions; // Encrypted
  final PaymentInfo paymentInfo; // Encrypted

  const Order({
    required this.id,
    required this.customerPubkey,
    required this.restaurantPubkey,
    this.riderPubkey,
    required this.items,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.deliveryAddress,
    required this.createdAt,
    this.acceptedAt,
    this.pickedUpAt,
    this.deliveredAt,
    this.specialInstructions,
    required this.paymentInfo,
  });

  @override
  List<Object?> get props => [
        id,
        customerPubkey,
        restaurantPubkey,
        riderPubkey,
        items,
        status,
        subtotal,
        deliveryFee,
        total,
        deliveryAddress,
        createdAt,
        acceptedAt,
        pickedUpAt,
        deliveredAt,
        specialInstructions,
        paymentInfo,
      ];

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerPubkey': customerPubkey,
        'restaurantPubkey': restaurantPubkey,
        'riderPubkey': riderPubkey,
        'items': items.map((i) => i.toJson()).toList(),
        'status': status.name,
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'total': total,
        'deliveryAddress': deliveryAddress.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'acceptedAt': acceptedAt?.toIso8601String(),
        'pickedUpAt': pickedUpAt?.toIso8601String(),
        'deliveredAt': deliveredAt?.toIso8601String(),
        'specialInstructions': specialInstructions,
        'paymentInfo': paymentInfo.toJson(),
      };

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      customerPubkey: json['customerPubkey'] as String,
      restaurantPubkey: json['restaurantPubkey'] as String,
      riderPubkey: json['riderPubkey'] as String?,
      items: (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList(),
      status: OrderStatus.values.byName(json['status']),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      deliveryAddress: DeliveryAddress.fromJson(json['deliveryAddress']),
      createdAt: DateTime.parse(json['createdAt']),
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'])
          : null,
      pickedUpAt: json['pickedUpAt'] != null
          ? DateTime.parse(json['pickedUpAt'])
          : null,
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'])
          : null,
      specialInstructions: json['specialInstructions'] as String?,
      paymentInfo: PaymentInfo.fromJson(json['paymentInfo']),
    );
  }
}

/// Order item
class OrderItem extends Equatable {
  final String menuItemId;
  final String name;
  final int quantity;
  final double price;
  final List<String> selectedOptions;

  const OrderItem({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
    this.selectedOptions = const [],
  });

  @override
  List<Object?> get props =>
      [menuItemId, name, quantity, price, selectedOptions];

  Map<String, dynamic> toJson() => {
        'menuItemId': menuItemId,
        'name': name,
        'quantity': quantity,
        'price': price,
        'selectedOptions': selectedOptions,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItemId: json['menuItemId'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      selectedOptions: List<String>.from(json['selectedOptions'] ?? []),
    );
  }
}

/// Order status
enum OrderStatus {
  pending,
  accepted,
  preparing,
  ready,
  pickedUp,
  onTheWay,
  delivered,
  cancelled,
}

/// Delivery address (encrypted in Nostr)
class DeliveryAddress extends Equatable {
  final String street;
  final String city;
  final String zipCode;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final String? notes;

  const DeliveryAddress({
    required this.street,
    required this.city,
    required this.zipCode,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    this.notes,
  });

  @override
  List<Object?> get props =>
      [street, city, zipCode, phoneNumber, latitude, longitude, notes];

  Map<String, dynamic> toJson() => {
        'street': street,
        'city': city,
        'zipCode': zipCode,
        'phoneNumber': phoneNumber,
        'latitude': latitude,
        'longitude': longitude,
        'notes': notes,
      };

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      street: json['street'] as String,
      city: json['city'] as String,
      zipCode: json['zipCode'] as String,
      phoneNumber: json['phoneNumber'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }
}

/// Payment info (encrypted in Nostr)
class PaymentInfo extends Equatable {
  final PaymentMethod method;
  final String? lightningInvoice;
  final bool isPaid;

  const PaymentInfo({
    required this.method,
    this.lightningInvoice,
    this.isPaid = false,
  });

  @override
  List<Object?> get props => [method, lightningInvoice, isPaid];

  Map<String, dynamic> toJson() => {
        'method': method.name,
        'lightningInvoice': lightningInvoice,
        'isPaid': isPaid,
      };

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      method: PaymentMethod.values.byName(json['method']),
      lightningInvoice: json['lightningInvoice'] as String?,
      isPaid: json['isPaid'] as bool? ?? false,
    );
  }
}

/// Payment method
enum PaymentMethod {
  lightning,
  cash,
}
