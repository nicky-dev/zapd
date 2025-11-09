import 'dart:convert';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../events/event.dart';
import '../events/filter.dart';
import '../models/relay.dart';
import '../models/subscription.dart';

/// Nostr client for connecting to relays
class NostrClient {
  final List<Relay> _relays = [];
  final Map<String, WebSocketChannel> _connections = {};
  final Map<String, StreamController<NostrEvent>> _subscriptions = {};

  bool _isConnected = false;

  /// Check if client is connected to relays
  bool get isConnected => _isConnected;

  /// Get list of relays
  List<Relay> get relays => List.unmodifiable(_relays);

  /// Add relay
  void addRelay(Relay relay) {
    if (!_relays.any((r) => r.url == relay.url)) {
      _relays.add(relay);
    }
  }

  /// Remove relay
  void removeRelay(String url) {
    _relays.removeWhere((relay) => relay.url == url);
    _disconnectRelay(url);
  }

  /// Connect to all relays
  Future<void> connect() async {
    for (final relay in _relays) {
      await _connectRelay(relay);
    }
    _isConnected = true;
  }

  /// Disconnect from all relays
  Future<void> disconnect() async {
    for (final url in _connections.keys.toList()) {
      await _disconnectRelay(url);
    }
    _isConnected = false;
  }

  /// Connect to a single relay
  Future<void> _connectRelay(Relay relay) async {
    if (_connections.containsKey(relay.url)) {
      return; // Already connected
    }

    try {
      final channel = WebSocketChannel.connect(Uri.parse(relay.url));
      _connections[relay.url] = channel;

      // Listen to messages
      channel.stream.listen(
        (data) => _handleMessage(relay.url, data),
        onError: (error) => _handleError(relay.url, error),
        onDone: () => _handleDisconnect(relay.url),
      );

      print('Connected to relay: ${relay.url}');
    } catch (e) {
      print('Failed to connect to ${relay.url}: $e');
    }
  }

  /// Disconnect from a single relay
  Future<void> _disconnectRelay(String url) async {
    final channel = _connections.remove(url);
    await channel?.sink.close();
    print('Disconnected from relay: $url');
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

  /// Handle error
  void _handleError(String relayUrl, dynamic error) {
    print('Error from $relayUrl: $error');
  }

  /// Handle disconnect
  void _handleDisconnect(String relayUrl) {
    print('Disconnected from $relayUrl');
    _connections.remove(relayUrl);
  }

  /// Publish event to all connected relays
  Future<void> publish(NostrEvent event) async {
    final message = jsonEncode(['EVENT', event.toJson()]);

    for (final entry in _connections.entries) {
      try {
        entry.value.sink.add(message);
        print('Published event to ${entry.key}');
      } catch (e) {
        print('Failed to publish to ${entry.key}: $e');
      }
    }
  }

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

    for (final entry in _connections.entries) {
      try {
        entry.value.sink.add(message);
      } catch (e) {
        print('Failed to subscribe on ${entry.key}: $e');
      }
    }

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

    for (final entry in _connections.entries) {
      try {
        entry.value.sink.add(message);
      } catch (e) {
        print('Failed to close subscription on ${entry.key}: $e');
      }
    }

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
