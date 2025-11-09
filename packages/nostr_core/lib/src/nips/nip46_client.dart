import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../crypto/key_pair.dart';
import '../crypto/nip44.dart';
import '../crypto/schnorr.dart';
import '../events/event.dart';
import 'nip46_models.dart';
import 'nip89_models.dart';

/// NIP-46: Nostr Connect Client
///
/// Remote signing protocol implementation
/// Spec: https://github.com/nostr-protocol/nips/blob/master/46.md
class Nip46Client {
  Nip46Session? _session;
  final Map<String, WebSocketChannel> _connections = {};
  final Map<String, Completer<Nip46Response>> _pendingRequests = {};
  final StreamController<String> _errorController =
      StreamController.broadcast();
  final Map<String, String> _authChallenges = {}; // Store challenges per relay

  // NIP-89: App metadata for identification (FIXED pubkey and identifier)
  final Nip89AppReference appReference;
  final Nip89AppMetadata appMetadata;

  bool _isConnected = false;

  /// Create NIP-46 client with app metadata
  Nip46Client({
    required this.appMetadata,
    required this.appReference,
  });

  /// Check if client is connected
  bool get isConnected => _isConnected;

  /// Current session
  Nip46Session? get session => _session;

  /// Error stream
  Stream<String> get errors => _errorController.stream;

  /// Connect to remote signer
  ///
  /// 1. Parse bunker URL
  /// 2. Generate ephemeral keypair
  /// 3. Connect to relays
  /// 4. Send connect request
  /// 5. Wait for approval
  Future<Nip46Session> connect(String bunkerUrl) async {
    print('🔌 NIP-46: Starting connection...');
    print('✅ Using REAL secp256k1 cryptography!');
    print('✅ Events will be properly signed');
    print('✅ Messages will be NIP-44 encrypted');
    print('');

    // Parse bunker URL
    final connection = BunkerConnection.fromUrl(bunkerUrl);
    print(
        '📡 NIP-46: Remote pubkey: ${connection.remotePubkey.substring(0, 16)}...');
    print('📡 NIP-46: Relays: ${connection.relays}');
    print('🔐 NIP-46: Has secret: ${connection.secret != null}');
    print('');
    print('⚠️  IMPORTANT: If using nsec.app bunker:');
    print('    1. Open https://nsec.app in another tab');
    print('    2. You should see a pending connection request');
    print('    3. Approve the connection from this app');
    print('    4. Wait for response here (up to 5 minutes)');
    print('');

    // Generate ephemeral keypair for this session
    print('🔑 NIP-46: Generating secp256k1 keypair...');
    final ephemeralKeyPair = KeyPair.generate();
    print(
        '🔑 NIP-46: Ephemeral pubkey: ${ephemeralKeyPair.publicKey.substring(0, 16)}...');

    // Create session
    _session = Nip46Session(
      connection: connection,
      ephemeralPrivateKey: ephemeralKeyPair.privateKey,
      ephemeralPublicKey: ephemeralKeyPair.publicKey,
      createdAt: DateTime.now(),
    );

    // Connect to relays
    print('🌐 NIP-46: Connecting to relays...');
    await _connectToRelays(connection.relays);
    print('✅ NIP-46: Connected to ${_connections.length} relays');

    // Mark as connected after successful relay connection
    _isConnected = true;

    // Subscribe to responses (encrypted DMs from remote signer to our ephemeral key)
    print('📬 NIP-46: Subscribing to responses...');
    await _subscribeToResponses(ephemeralKeyPair.publicKey);

    // Send connect request with permissions
    print('📤 NIP-46: Sending connect request...');
    final request = Nip46Request(
      id: _generateRequestId(),
      method: Nip46Method.connect,
      params: [
        connection.remotePubkey,  // Remote user's pubkey
        connection.secret ?? '',   // Optional secret from bunker URL
        'nip44_encrypt,nip44_decrypt,sign_event',  // Permissions (comma-separated string)
      ],
    );
    print('📤 NIP-46: Request ID: ${request.id}');
    print('📤 NIP-46: Permissions: nip44_encrypt,nip44_decrypt,sign_event');

    final response = await _sendRequest(request, connection.remotePubkey);
    print('📥 NIP-46: Received response');

    if (response.isError) {
      print('❌ NIP-46: Error: ${response.error}');
      _isConnected = false;
      throw Exception('Connect failed: ${response.error}');
    }

    print('✅ NIP-46: Connection successful!');
    // Update session with confirmed remote public key
    _session = _session!.copyWith(remotePublicKey: connection.remotePubkey);

    return _session!;
  }

  /// Get public key from remote signer
  Future<String> getPublicKey() async {
    _ensureConnected();

    final request = Nip46Request(
      id: _generateRequestId(),
      method: Nip46Method.getPublicKey,
    );

    final response = await _sendRequest(
      request,
      _session!.connection.remotePubkey,
    );

    if (response.isError) {
      throw Exception('Failed to get public key: ${response.error}');
    }

    return response.result!;
  }

  /// Sign event using remote signer
  Future<NostrEvent> signEvent(Map<String, dynamic> unsignedEvent) async {
    _ensureConnected();

    final request = Nip46Request(
      id: _generateRequestId(),
      method: Nip46Method.signEvent,
      params: [jsonEncode(unsignedEvent)],
    );

    final response = await _sendRequest(
      request,
      _session!.connection.remotePubkey,
    );

    if (response.isError) {
      throw Exception('Failed to sign event: ${response.error}');
    }

    final signedEventJson =
        jsonDecode(response.result!) as Map<String, dynamic>;
    return NostrEvent.fromJson(signedEventJson);
  }

  /// Disconnect from remote signer
  Future<void> disconnect() async {
    // Create snapshot to avoid concurrent modification
    final connectionsList = _connections.entries.toList();

    // Close all WebSocket connections
    for (final entry in connectionsList) {
      try {
        await entry.value.sink.close();
      } catch (e) {
        print('⚠️ NIP-46: Error closing ${entry.key}: $e');
      }
    }

    _connections.clear();
    _pendingRequests.clear();
    _session = null;
    _isConnected = false;
  }

  /// Connect to multiple relays
  Future<void> _connectToRelays(List<String> relayUrls) async {
    for (final url in relayUrls) {
      try {
        print('🔗 NIP-46: Connecting to relay: $url');
        final channel = WebSocketChannel.connect(Uri.parse(url));
        _connections[url] = channel;

        // Listen to messages from this relay
        channel.stream.listen(
          (data) {
            print('📨 NIP-46: Message from $url');
            _handleRelayMessage(url, data);
          },
          onError: (error, stackTrace) {
            print('❌ NIP-46: WebSocket Error from $url: $error');
            print('📚 Stack trace: $stackTrace');
            _errorController.add('Relay error from $url: $error');
          },
          onDone: () {
            print('🔌 NIP-46: Disconnected from $url');
            _handleRelayDisconnect(url);
          },
        );

        print('✅ NIP-46: WebSocket created for: $url');
        // Wait longer for WebSocket handshake to complete
        await Future.delayed(const Duration(seconds: 2));
        print('✅ NIP-46: Connection ready: $url');
      } catch (e) {
        print('❌ NIP-46: Failed to connect to relay $url: $e');
        _errorController.add('Failed to connect to relay $url: $e');
      }
    }
  }

  /// Subscribe to encrypted responses from remote signer
  Future<void> _subscribeToResponses(String ephemeralPubkey) async {
    // CRITICAL: Match applesauce pattern - NO 'authors' filter!
    // applesauce only filters by kind and #p tag, then checks pubkey in handleEvent
    final subscription = [
      'REQ',
      _generateSubscriptionId(),
      {
        'kinds': [24133],          // NIP-46 events
        '#p': [ephemeralPubkey],   // Tagged TO our ephemeral key
        // NO 'authors' filter - accept from anyone, filter in handleEvent!
        // NO 'since' - listen for ALL events (past + future)
      }
    ];

    print('📬 NIP-46: Setting up subscription (applesauce pattern):');
    print('  Filter: kind=24133, #p=$ephemeralPubkey');
    print('  ✅ NO authors filter (accept from anyone)');
    print('  ✅ NO since filter (get all events)');
    print('  ℹ️  Will filter by pubkey in handleEvent');

    // Send subscription to all connected relays
    for (final entry in _connections.entries) {
      print('📡 NIP-46: Sending subscription to ${entry.key}');
      entry.value.sink.add(jsonEncode(subscription));
    }

    print('✅ NIP-46: Subscription sent to ${_connections.length} relays');
  }

  /// Send encrypted request to remote signer
  Future<Nip46Response> _sendRequest(
    Nip46Request request,
    String remotePubkey,
  ) async {
    // Don't check _isConnected here - it blocks the first connect request
    if (_session == null) {
      throw StateError('No session - call connect() first.');
    }

    print(
        '📤 NIP-46: Sending ${request.method.value} request (ID: ${request.id})');

    // Create completer for response
    final completer = Completer<Nip46Response>();
    _pendingRequests[request.id] = completer;

    try {
      // Get conversation key for NIP-44 encryption (modern standard)
      print('🔐 NIP-46: Computing ECDH shared secret...');
      print(
          '  Private key: ${_session!.ephemeralPrivateKey.substring(0, 16)}...');
      print('  Remote pubkey: ${remotePubkey.substring(0, 16)}...');

      final conversationKey = NIP44.getConversationKey(
        _session!.ephemeralPrivateKey,
        remotePubkey,
      );
      print('✅ NIP-46: ECDH computed successfully');

      // Encrypt request content
      print('🔒 NIP-46: Encrypting request with NIP-44 (XChaCha20-Poly1305)...');
      final plaintextContent = request.toJsonString();
      print('  Plaintext length: ${plaintextContent.length} bytes');

      final encryptedContent =
          await NIP44.encrypt(plaintextContent, conversationKey);
      print(
          '✅ NIP-46: Request encrypted, ciphertext length: ${encryptedContent.length}');

      // Create event (kind 24133 for NIP-46 request)
      final createdAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final tags = [
        ['p', remotePubkey],
        // NIP-89: Add client tag so bunker knows who we are!
        appReference.clientTag,
      ];

      print('📬 NIP-46: Creating event with:');
      print('  From: ${_session!.ephemeralPublicKey}');
      print('  To:   $remotePubkey');
      print('  Kind: 24133 (NIP-46 request)');
      print('  Tag:  p=$remotePubkey');
      print('  Tag:  client=${appReference.clientTag.join(", ")}');
      print('  🎯 Bunker will see: "${appMetadata.name}" app');

      // Compute event ID
      final id = NostrEvent.computeId(
        pubkey: _session!.ephemeralPublicKey,
        createdAt: createdAt,
        kind: 24133,
        tags: tags,
        content: encryptedContent,
      );

      // Sign event with Schnorr
      print('✍️ NIP-46: Signing event with Schnorr...');
      print('  Event ID to sign: $id');
      print(
          '  Using privkey: ${_session!.ephemeralPrivateKey.substring(0, 16)}...');
      print(
          '  Event pubkey:  ${_session!.ephemeralPublicKey.substring(0, 16)}...');

      final signature = Schnorr.sign(id, _session!.ephemeralPrivateKey);
      print('✅ NIP-46: Event signed');
      print('  Signature: ${signature.substring(0, 32)}...');

      final eventJson = {
        'id': id,
        'pubkey': _session!.ephemeralPublicKey,
        'created_at': createdAt,
        'kind': 24133,
        'tags': tags,
        'content': encryptedContent,
        'sig': signature,
      };

      print(
          '📨 NIP-46: Publishing signed event to ${_connections.length} relays');
      print('📋 NIP-46: Event JSON: ${jsonEncode(eventJson)}');

      // Publish event to all relays
      final publishMessage = jsonEncode(['EVENT', eventJson]);
      print(
          '📤 NIP-46: Publish message length: ${publishMessage.length} bytes');

      // Create snapshot to avoid concurrent modification
      final connectionEntries = _connections.entries.toList();
      for (final entry in connectionEntries) {
        try {
          print('📡 NIP-46: Sending to ${entry.key}');
          entry.value.sink.add(publishMessage);
        } catch (e) {
          print('⚠️ NIP-46: Failed to send to ${entry.key}: $e');
        }
      }

      // Wait for response with timeout (5 minutes for user approval)
      print(
          '⏳ NIP-46: Waiting for response (5 min timeout for user approval)...');
      return await completer.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () {
          print('⏱️ NIP-46: Request timed out after 5 minutes!');
          throw TimeoutException(
              'Request timed out. User may not have approved the connection.');
        },
      );
    } catch (e, stackTrace) {
      print('❌ NIP-46: Send request failed: $e');
      print('📚 NIP-46: Stack trace: $stackTrace');
      _pendingRequests.remove(request.id);
      rethrow;
    }
  }

  /// Handle incoming relay message
  void _handleRelayMessage(String relayUrl, dynamic data) {
    try {
      print('📨 NIP-46: RAW MESSAGE from $relayUrl: $data');
      print('📨 NIP-46: Message length: ${(data as String).length} bytes');
      
      final message = jsonDecode(data) as List;
      final messageType = message[0] as String;
      print('📋 NIP-46: Message type: $messageType');
      
      if (message.length > 1) {
        print('📋 NIP-46: Message parts: ${message.length}');
      }

      if (messageType == 'EVENT') {
        print(
            '🎉 🎉 🎉 NIP-46: Received EVENT - This should be the bunker response!');
        print('📦 NIP-46: Processing event message...');
        _handleEventMessage(message);
      } else if (messageType == 'EOSE') {
        final subId = message.length > 1 ? message[1] as String : 'unknown';
        print('✅ NIP-46: End of stored events for subscription: $subId on $relayUrl');
      } else if (messageType == 'AUTH') {
        final challenge = message[1] as String;
        print(
            '🔐 NIP-46: Received AUTH challenge from $relayUrl: ${challenge.substring(0, 16)}...');
        _authChallenges[relayUrl] = challenge;
        _handleAuth(relayUrl, challenge);
      } else if (messageType == 'OK') {
        final eventId = message[1] as String;
        final accepted = message[2] as bool;
        final msg = message.length > 3 ? message[3] as String : '';
        
        if (accepted) {
          print('✅ NIP-46: Event ${eventId.substring(0, 8)}... ACCEPTED by relay');
          print('   Message: $msg');
          print('   🎉 Our connect request was published successfully!');
          print('   ⏳ Now waiting for bunker to respond...');
          print('   💡 If no response: Check if you approved at https://nsec.app');
        } else {
          print('❌ NIP-46: Event ${eventId.substring(0, 8)}... REJECTED by relay');
          print('   Reason: $msg');
        }

        // If rejected with auth-required, try to authenticate
        if (!accepted && msg.contains('auth-required')) {
          print('🔐 NIP-46: Auth required, will authenticate...');
        }
      } else if (messageType == 'NOTICE') {
        final notice = message[1] as String;
        print('📢 NIP-46: Relay notice from $relayUrl: $notice');
        _errorController.add('Relay notice from $relayUrl: $notice');
      }
    } catch (e, stackTrace) {
      print('❌ NIP-46: Error handling relay message: $e');
      print('📚 NIP-46: Stack trace: $stackTrace');
      _errorController.add('Error handling relay message: $e');
    }
  }

  /// Handle EVENT message (encrypted response from remote signer)
  void _handleEventMessage(List message) async {
    try {
      print('📦 NIP-46: Processing EVENT message');
      final eventJson = message[2] as Map<String, dynamic>;
      print('📄 NIP-46: Event JSON: $eventJson');

      final event = NostrEvent.fromJson(eventJson);
      print(
          '✉️ NIP-46: Event from ${event.pubkey.substring(0, 16)}... kind=${event.kind}');
      print(
          '🔍 NIP-46: Expected bunker pubkey: ${_session!.connection.remotePubkey.substring(0, 16)}...');
      print(
          '🔍 NIP-46: Actual sender pubkey:   ${event.pubkey.substring(0, 16)}...');

      // CRITICAL: Ignore events from ourselves (our own sent messages)
      if (event.pubkey == _session!.ephemeralPublicKey) {
        print('⏭️  NIP-46: Ignoring event from OURSELVES (echo from relay)');
        print('   This is our own sent message, not a bunker response');
        return;
      }

      // Verify event is from expected bunker
      if (event.pubkey != _session!.connection.remotePubkey) {
        print('⚠️ NIP-46: Event from unexpected pubkey!');
        print('   Expected: ${_session!.connection.remotePubkey}');
        print('   Got:      ${event.pubkey}');
        print(
            '   📝 This is the ACTUAL bunker service pubkey - updating session!');

        // Update session with actual bunker service pubkey for future requests
        _session = _session!.copyWith(remotePublicKey: event.pubkey);
      }

      // Decrypt content using conversation key with NIP-44
      // TRY BOTH: sender pubkey AND bunker URL pubkey
      print('🔐 NIP-46: Computing ECDH shared secret...');
      print(
          '  Our privkey:    ${_session!.ephemeralPrivateKey.substring(0, 16)}...');
      print('  Sender pubkey:  ${event.pubkey.substring(0, 16)}...');
      print('  Bunker URL pubkey: ${_session!.connection.remotePubkey.substring(0, 16)}...');

      // First try: Use sender's pubkey (correct per NIP-46 spec)
      var conversationKey = NIP44.getConversationKey(
        _session!.ephemeralPrivateKey,
        event.pubkey,
      );
      print('  Conversation key (with sender): ${conversationKey.map((b) => b.toRadixString(16).padLeft(2, '0')).take(8).join()}...');

      print('🔓 NIP-46: Decrypting response with NIP-44 (XChaCha20-Poly1305)...');
      print('  Encrypted content length: ${event.content.length}');
      print(
          '  First 20 chars: ${event.content.substring(0, event.content.length > 20 ? 20 : event.content.length)}...');

      String? decryptedContent;
      try {
        // Try decrypting with sender's pubkey (correct per spec)
        print('  Attempting decrypt with SENDER pubkey...');
        decryptedContent = await NIP44.decrypt(
          event.content,
          conversationKey,
        );
        print('✅ NIP-46: Response decrypted with SENDER pubkey');
      } catch (e1) {
        print('❌ NIP-46: Decrypt with sender pubkey failed: $e1');
        
        // Fallback: Try with bunker URL pubkey (nsec.app might do this?)
        print('  Attempting decrypt with BUNKER URL pubkey...');
        try {
          conversationKey = NIP44.getConversationKey(
            _session!.ephemeralPrivateKey,
            _session!.connection.remotePubkey,
          );
          print('  Conversation key (with URL): ${conversationKey.map((b) => b.toRadixString(16).padLeft(2, '0')).take(8).join()}...');
          decryptedContent = await NIP44.decrypt(
            event.content,
            conversationKey,
          );
          print('✅ NIP-46: Response decrypted with BUNKER URL pubkey');
          print('   ⚠️ This is non-standard! Bunker should use sender pubkey per NIP-46 spec');
        } catch (e2) {
          print('❌ NIP-46: Both decryption attempts failed!');
          print('   Sender pubkey error: $e1');
          print('   Bunker URL pubkey error: $e2');
          throw Exception('Cannot decrypt response: tried both sender and bunker URL pubkeys');
        }
      }
      print('📝 NIP-46: Decrypted content: $decryptedContent');

      // Parse as JSON first to check if it's a request or response
      print('🔍 NIP-46: Parsing JSON');
      final json = jsonDecode(decryptedContent) as Map<String, dynamic>;
      
      // Check if this is a request from bunker (has "method" field)
      if (json.containsKey('method') && json.containsKey('params')) {
        print('📥 NIP-46: Received REQUEST from bunker (not a response!)');
        print('   Method: ${json['method']}');
        print('   ID: ${json['id']}');
        
        // Handle bunker request
        await _handleBunkerRequest(json, event.pubkey);
        return;
      }
      
      // Otherwise, it's a response
      print('🔍 NIP-46: Parsing response JSON');
      final response = Nip46Response.fromJsonString(decryptedContent);
      print(
          '✅ NIP-46: Response ID: ${response.id}, Success: ${response.isSuccess}');

      if (response.isError) {
        print('❌ NIP-46: Response error: ${response.error}');
      } else {
        print('✨ NIP-46: Response result: ${response.result}');
      }

      // Complete pending request
      final completer = _pendingRequests.remove(response.id);
      if (completer != null && !completer.isCompleted) {
        print('✅ NIP-46: Completing request ${response.id}');
        completer.complete(response);
      } else {
        print('⚠️ NIP-46: No pending request found for ID: ${response.id}');
      }
    } catch (e, stack) {
      print('❌ NIP-46: Error handling event: $e');
      print('📚 NIP-46: Stack trace: $stack');
      _errorController.add('Error handling event: $e');
    }
  }

  /// Handle request from bunker (bunker asking US something)
  Future<void> _handleBunkerRequest(
      Map<String, dynamic> requestJson, String bunkerPubkey) async {
    try {
      final requestId = requestJson['id'] as String;
      final method = requestJson['method'] as String;

      print('🔄 NIP-46: Handling bunker request: $method');
      print('   Request ID: $requestId');
      print('   From: ${bunkerPubkey.substring(0, 16)}...');

      String? result;
      String? error;

      // Handle different request types from bunker
      switch (method) {
        case 'get_public_key':
          // Bunker is asking for our user's public key
          // For now, return the bunker URL pubkey (the user's actual key)
          result = _session!.connection.remotePubkey;
          print('✅ NIP-46: Returning public key: ${result.substring(0, 16)}...');
          break;

        default:
          error = 'Method not supported: $method';
          print('❌ NIP-46: Unsupported method from bunker: $method');
      }

      // Send response back to bunker
      final response = {
        'id': requestId,
        'result': result,
        'error': error,
      };

      print('📤 NIP-46: Sending response to bunker request');
      print('   Response: $response');

      // Encrypt and send
      final responseJson = jsonEncode(response);
      
      // Use bunker URL pubkey for encryption (same as we did for requests)
      final conversationKey = NIP44.getConversationKey(
        _session!.ephemeralPrivateKey,
        _session!.connection.remotePubkey,
      );
      
      final encryptedContent = await NIP44.encrypt(responseJson, conversationKey);

      // Create event
      final createdAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final tags = [
        ['p', bunkerPubkey] // Tag the bunker's ephemeral pubkey
      ];

      final id = NostrEvent.computeId(
        pubkey: _session!.ephemeralPublicKey,
        createdAt: createdAt,
        kind: 24133,
        tags: tags,
        content: encryptedContent,
      );

      final signature = Schnorr.sign(id, _session!.ephemeralPrivateKey);

      final eventJson = {
        'id': id,
        'pubkey': _session!.ephemeralPublicKey,
        'created_at': createdAt,
        'kind': 24133,
        'tags': tags,
        'content': encryptedContent,
        'sig': signature,
      };

      // Publish to all connected relays
      final publishMessage = jsonEncode(['EVENT', eventJson]);
      for (final entry in _connections.entries) {
        try {
          entry.value.sink.add(publishMessage);
          print('✅ NIP-46: Response sent to ${entry.key}');
        } catch (e) {
          print('⚠️ NIP-46: Failed to send response to ${entry.key}: $e');
        }
      }
    } catch (e, stackTrace) {
      print('❌ NIP-46: Error handling bunker request: $e');
      print('📚 Stack trace: $stackTrace');
    }
  }

  /// Handle relay disconnect
  void _handleRelayDisconnect(String relayUrl) {
    print('🔌 NIP-46: Relay disconnected: $relayUrl');

    // Check if relay exists before removing (avoid concurrent modification)
    if (!_connections.containsKey(relayUrl)) {
      print('ℹ️ NIP-46: Relay $relayUrl already removed');
      return;
    }

    // Check if this will be the last connection BEFORE removing
    final willBeDisconnected = _connections.length == 1;

    // Mark as disconnected IMMEDIATELY if this is the last relay
    if (willBeDisconnected) {
      print('❌ NIP-46: Last relay disconnecting - marking as disconnected');
      _isConnected = false;

      // Fail all pending requests immediately
      final errorMessage = 'Connection lost: All relays disconnected';
      for (final entry in _pendingRequests.entries.toList()) {
        if (!entry.value.isCompleted) {
          print('❌ NIP-46: Failing pending request ${entry.key}');
          entry.value.completeError(Exception(errorMessage));
        }
      }
      _pendingRequests.clear();
    }

    // Schedule removal for next event loop to avoid concurrent modification
    Future.microtask(() {
      _connections.remove(relayUrl);

      print('⚠️ NIP-46: Unexpected disconnect from $relayUrl');
      _errorController.add('Disconnected from relay: $relayUrl');

      // If all relays disconnected, send error message
      if (_connections.isEmpty) {
        print('❌ NIP-46: All relays disconnected');

        final errorMessage = '''
NIP-46 Connection Failed: All relays disconnected.

Possible causes:
• Relay rejected the event (check signature validity)
• Network issues
• Invalid bunker configuration

Debug Steps:
1. Check console logs for relay responses
2. Verify bunker URL is correct
3. Ensure relay is accessible
''';

        _errorController.add(errorMessage);
      }
    });
  }

  /// Ensure client is connected
  void _ensureConnected() {
    if (!_isConnected || _session == null) {
      throw StateError('Not connected to remote signer. Call connect() first.');
    }
  }

  /// Generate unique request ID
  String _generateRequestId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Generate unique subscription ID
  String _generateSubscriptionId() {
    return 'sub_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Handle NIP-42 AUTH challenge
  Future<void> _handleAuth(String relayUrl, String challenge) async {
    if (_session == null) {
      print('⚠️ NIP-46: No session, cannot authenticate');
      return;
    }

    try {
      print('🔐 NIP-42: Authenticating to $relayUrl');

      // Create kind 22242 AUTH event
      final createdAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final tags = [
        ['relay', relayUrl],
        ['challenge', challenge],
      ];

      // Compute event ID
      final id = NostrEvent.computeId(
        pubkey: _session!.ephemeralPublicKey,
        createdAt: createdAt,
        kind: 22242,
        tags: tags,
        content: '',
      );

      // Sign event
      final signature = Schnorr.sign(id, _session!.ephemeralPrivateKey);

      final authEvent = {
        'id': id,
        'pubkey': _session!.ephemeralPublicKey,
        'created_at': createdAt,
        'kind': 22242,
        'tags': tags,
        'content': '',
        'sig': signature,
      };

      // Send AUTH response
      final authMessage = jsonEncode(['AUTH', authEvent]);
      final channel = _connections[relayUrl];
      if (channel != null) {
        channel.sink.add(authMessage);
        print('✅ NIP-42: Sent AUTH response to $relayUrl');
      }
    } catch (e, stackTrace) {
      print('❌ NIP-42: Auth failed: $e');
      print('📚 Stack trace: $stackTrace');
    }
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _errorController.close();
  }
}
