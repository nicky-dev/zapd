import 'dart:convert';
import 'dart:async';
import '../events/event.dart';
import '../events/filter.dart';
import '../models/relay.dart';
import '../models/subscription.dart';
import 'relay_pool.dart';

/// Nostr client for connecting to relays (using RelayPool for better reliability)
class NostrClient {
  final List<Relay> _relays = [];
  late final RelayPool _pool;
  final Map<String, StreamController<NostrEvent>> _subscriptions = {};
  StreamSubscription<Map<String, dynamic>>? _poolSubscription;

  bool _isConnected = false;

  NostrClient() {
    _pool = RelayPool();
  }

  /// Check if client is connected to relays
  bool get isConnected => _isConnected;

  /// Get list of relays
  List<Relay> get relays => List.unmodifiable(_relays);

  /// Get relay pool statistics
  Map<String, dynamic> get stats => _pool.getStats();

  /// Add relay
  void addRelay(Relay relay) {
    if (!_relays.any((r) => r.url == relay.url)) {
      _relays.add(relay);
      _pool.addRelay(relay.url);
    }
  }

  /// Remove relay
  void removeRelay(String url) {
    _relays.removeWhere((relay) => relay.url == url);
    _pool.removeRelay(url);
  }

  /// Connect to all relays
  Future<void> connect() async {
    await _pool.connectAll();
    _isConnected = true;
    _startListening();
  }

  /// Disconnect from all relays
  Future<void> disconnect() async {
    await _poolSubscription?.cancel();
    _poolSubscription = null;
    await _pool.disconnectAll();
    _isConnected = false;
  }

  /// Start listening to relay pool messages
  void _startListening() {
    _poolSubscription = _pool.messageStream.listen((message) {
      final relayUrl = message['relay'] as String;
      final data = message['data'];
      _handleMessage(relayUrl, data);
    });
  }

  /// Handle incoming message
  void _handleMessage(String relayUrl, dynamic data) {
    try {
      final message = jsonDecode(data as String) as List;
      final messageType = message[0] as String;

      switch (messageType) {
        case 'EVENT':
          _handleEventMessage(relayUrl, message);
          break;
        case 'EOSE':
          _handleEOSEMessage(message);
          break;
        case 'OK':
          _handleOKMessage(message);
          break;
        case 'NOTICE':
          _handleNoticeMessage(relayUrl, message);
          break;
        default:
          print('Unknown message type from $relayUrl: $messageType');
      }
    } catch (e) {
      print('Error parsing message from $relayUrl: $e');
    }
  }

  /// Handle EVENT message
  void _handleEventMessage(String relayUrl, List message) {
    if (message.length < 3) return;

    final subscriptionId = message[1] as String;
    final eventJson = message[2] as Map<String, dynamic>;
    final event = NostrEvent.fromJson(eventJson);

    // Send to subscription stream
    final controller = _subscriptions[subscriptionId];
    if (controller != null && !controller.isClosed) {
      controller.add(event);
    }
  }

  /// Handle EOSE (End of Stored Events) message
  void _handleEOSEMessage(List message) {
    final subscriptionId = message[1] as String;
    print('EOSE received for subscription: $subscriptionId');
  }

  /// Handle OK message (event acceptance/rejection)
  void _handleOKMessage(List message) {
    final eventId = message[1] as String;
    final accepted = message[2] as bool;
    final reason = message.length > 3 ? message[3] as String : '';

    if (accepted) {
      print('Event $eventId accepted');
    } else {
      print('Event $eventId rejected: $reason');
    }
  }

  /// Handle NOTICE message
  void _handleNoticeMessage(String relayUrl, List message) {
    final notice = message[1] as String;
    print('Notice from $relayUrl: $notice');
  }

  /// Publish event to all connected relays (broadcast to all)
  Future<void> publish(NostrEvent event) async {
    final message = jsonEncode(['EVENT', event.toJson()]);
    _pool.broadcastToAll(message);
    print('Published event to all relays');
  }

  /// Publish to N best relays (load balanced)
  Future<void> publishToNBest(NostrEvent event, {int n = 3}) async {
    final message = jsonEncode(['EVENT', event.toJson()]);
    _pool.sendToNBest(message, n);
    print('Published event to $n best relays');
  }

  /// Get list of healthy relay URLs
  List<String> get healthyRelays => _pool.healthyRelays;

  /// Get best relay URL
  String? get bestRelay => _pool.getBestRelay();

  /// Subscribe to events with filters
  Subscription subscribe(
    List<NostrFilter> filters, {
    String? subscriptionId,
  }) {
    final subId = subscriptionId ?? _generateSubscriptionId();
    final controller = StreamController<NostrEvent>.broadcast();
    _subscriptions[subId] = controller;

    // Send REQ message to all relays
    final filtersJson = filters.map((f) => f.toJson()).toList();
    final message = jsonEncode(['REQ', subId, ...filtersJson]);
    _pool.broadcastToAll(message);

    return Subscription(
      id: subId,
      filters: filters,
      stream: controller.stream,
      onClose: () => _closeSubscription(subId),
    );
  }

  /// Close subscription
  void _closeSubscription(String subscriptionId) {
    // Send CLOSE message to all relays
    final message = jsonEncode(['CLOSE', subscriptionId]);
    _pool.broadcastToAll(message);

    // Close and remove controller
    final controller = _subscriptions.remove(subscriptionId);
    controller?.close();
  }

  /// Generate unique subscription ID
  String _generateSubscriptionId() {
    return 'sub_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Dispose client
  void dispose() {
    disconnect();
    for (final controller in _subscriptions.values) {
      controller.close();
    }
    _subscriptions.clear();
  }
}
