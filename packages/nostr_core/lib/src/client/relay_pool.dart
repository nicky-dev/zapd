import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Relay connection status
enum RelayStatus {
  disconnected,
  connecting,
  connected,
  error,
}

/// Individual relay connection wrapper
class RelayConnection {
  final String url;
  WebSocketChannel? _channel;
  RelayStatus status = RelayStatus.disconnected;
  DateTime? lastConnected;
  DateTime? lastError;
  int failureCount = 0;
  int messagesSent = 0;
  int messagesReceived = 0;

  RelayConnection(this.url);

  /// Connect to relay
  Future<void> connect() async {
    if (status == RelayStatus.connected || status == RelayStatus.connecting) {
      return;
    }

    try {
      status = RelayStatus.connecting;
      _channel = WebSocketChannel.connect(Uri.parse(url));
      
      // Wait for connection to be established
      await _channel!.ready;
      
      status = RelayStatus.connected;
      lastConnected = DateTime.now();
      failureCount = 0;
    } catch (e) {
      status = RelayStatus.error;
      lastError = DateTime.now();
      failureCount++;
      rethrow;
    }
  }

  /// Disconnect from relay
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
    status = RelayStatus.disconnected;
  }

  /// Send message to relay
  void send(String message) {
    if (status != RelayStatus.connected || _channel == null) {
      throw StateError('Relay not connected: $url');
    }
    _channel!.sink.add(message);
    messagesSent++;
  }

  /// Get stream of messages from relay
  Stream<dynamic>? get stream => _channel?.stream;

  /// Check if relay is healthy
  bool get isHealthy {
    return status == RelayStatus.connected && 
           failureCount < 3 &&
           (lastError == null || 
            DateTime.now().difference(lastError!).inMinutes > 5);
  }

  /// Get connection latency in milliseconds (simple check)
  int? get latency {
    if (lastConnected == null) return null;
    // This is a simplified latency - in real implementation,
    // you'd measure ping/pong round-trip time
    return DateTime.now().difference(lastConnected!).inMilliseconds;
  }
}

/// Relay pool with connection management, load balancing, and health checks
class RelayPool {
  final Map<String, RelayConnection> _relays = {};
  final StreamController<Map<String, dynamic>> _messageController = 
      StreamController.broadcast();
  
  Timer? _healthCheckTimer;
  bool _isShuttingDown = false;

  /// Add relay to pool
  void addRelay(String url) {
    if (_relays.containsKey(url)) return;
    _relays[url] = RelayConnection(url);
  }

  /// Remove relay from pool
  Future<void> removeRelay(String url) async {
    final relay = _relays.remove(url);
    await relay?.disconnect();
  }

  /// Connect to all relays in pool
  Future<void> connectAll() async {
    final futures = <Future>[];
    
    for (final relay in _relays.values) {
      futures.add(relay.connect().catchError((e) {
        print('Failed to connect to ${relay.url}: $e');
      }));
    }

    await Future.wait(futures);
    _startHealthChecks();
    _startListening();
  }

  /// Disconnect from all relays
  Future<void> disconnectAll() async {
    _isShuttingDown = true;
    _healthCheckTimer?.cancel();
    
    final futures = <Future>[];
    for (final relay in _relays.values) {
      futures.add(relay.disconnect());
    }
    
    await Future.wait(futures);
    await _messageController.close();
  }

  /// Send message to all connected relays
  void broadcastToAll(String message) {
    for (final relay in _relays.values) {
      if (relay.status == RelayStatus.connected) {
        try {
          relay.send(message);
        } catch (e) {
          print('Failed to send to ${relay.url}: $e');
        }
      }
    }
  }

  /// Send message to specific relay
  void sendToRelay(String url, String message) {
    final relay = _relays[url];
    if (relay == null) {
      throw ArgumentError('Relay not in pool: $url');
    }
    relay.send(message);
  }

  /// Send message to N best relays (load balancing)
  void sendToNBest(String message, int n) {
    final healthyRelays = _relays.values
        .where((r) => r.isHealthy)
        .toList()
      ..sort((a, b) {
        // Sort by latency (lower is better)
        final aLatency = a.latency ?? 99999;
        final bLatency = b.latency ?? 99999;
        return aLatency.compareTo(bLatency);
      });

    final targets = healthyRelays.take(n);
    for (final relay in targets) {
      try {
        relay.send(message);
      } catch (e) {
        print('Failed to send to ${relay.url}: $e');
      }
    }
  }

  /// Get stream of all messages from all relays
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  /// Get relay statistics
  Map<String, dynamic> getStats() {
    final connected = _relays.values.where((r) => r.status == RelayStatus.connected).length;
    final healthy = _relays.values.where((r) => r.isHealthy).length;
    
    return {
      'total': _relays.length,
      'connected': connected,
      'healthy': healthy,
      'disconnected': _relays.length - connected,
      'relays': _relays.map((url, relay) => MapEntry(url, {
        'status': relay.status.name,
        'messagesSent': relay.messagesSent,
        'messagesReceived': relay.messagesReceived,
        'failureCount': relay.failureCount,
        'lastConnected': relay.lastConnected?.toIso8601String(),
        'lastError': relay.lastError?.toIso8601String(),
        'latency': relay.latency,
        'isHealthy': relay.isHealthy,
      })),
    };
  }

  /// Get list of healthy relay URLs
  List<String> get healthyRelays {
    return _relays.entries
        .where((e) => e.value.isHealthy)
        .map((e) => e.key)
        .toList();
  }

  /// Start listening to all relay streams
  void _startListening() {
    for (final entry in _relays.entries) {
      final url = entry.key;
      final relay = entry.value;
      
      relay.stream?.listen(
        (data) {
          if (!_isShuttingDown) {
            relay.messagesReceived++;
            _messageController.add({
              'relay': url,
              'data': data,
            });
          }
        },
        onError: (error) {
          print('Error from $url: $error');
          relay.status = RelayStatus.error;
          relay.lastError = DateTime.now();
          relay.failureCount++;
          
          // Try to reconnect after error
          if (!_isShuttingDown) {
            _reconnectRelay(relay);
          }
        },
        onDone: () {
          print('Connection closed: $url');
          relay.status = RelayStatus.disconnected;
          
          // Try to reconnect
          if (!_isShuttingDown) {
            _reconnectRelay(relay);
          }
        },
      );
    }
  }

  /// Reconnect to a relay after delay
  Future<void> _reconnectRelay(RelayConnection relay) async {
    // Exponential backoff: 1s, 2s, 4s, 8s, max 30s
    final delay = Duration(
      seconds: (1 << relay.failureCount.clamp(0, 5)).clamp(1, 30),
    );
    
    print('Reconnecting to ${relay.url} in ${delay.inSeconds}s...');
    await Future.delayed(delay);
    
    if (!_isShuttingDown) {
      try {
        await relay.connect();
        print('Reconnected to ${relay.url}');
      } catch (e) {
        print('Failed to reconnect to ${relay.url}: $e');
      }
    }
  }

  /// Start periodic health checks
  void _startHealthChecks() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _performHealthCheck(),
    );
  }

  /// Perform health check on all relays
  void _performHealthCheck() {
    for (final relay in _relays.values) {
      if (relay.status == RelayStatus.connected && !relay.isHealthy) {
        print('Relay unhealthy, reconnecting: ${relay.url}');
        relay.disconnect().then((_) => _reconnectRelay(relay));
      } else if (relay.status == RelayStatus.disconnected) {
        print('Relay disconnected, reconnecting: ${relay.url}');
        _reconnectRelay(relay);
      }
    }
  }

  /// Get best relay URL based on health and latency
  String? getBestRelay() {
    final healthy = _relays.entries
        .where((e) => e.value.isHealthy)
        .toList()
      ..sort((a, b) {
        final aLatency = a.value.latency ?? 99999;
        final bLatency = b.value.latency ?? 99999;
        return aLatency.compareTo(bLatency);
      });

    return healthy.isNotEmpty ? healthy.first.key : null;
  }
}

