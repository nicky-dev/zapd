import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nostr_core/nostr_core.dart';

const _keyPrivateKey = 'nostr_private_key';
const _keyPublicKey = 'nostr_public_key';

class AuthState {
  final String? privateKey;
  final String? publicKey;
  final bool isAuthenticated;

  const AuthState({
    this.privateKey,
    this.publicKey,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    String? privateKey,
    String? publicKey,
    bool? isAuthenticated,
  }) {
    return AuthState(
      privateKey: privateKey ?? this.privateKey,
      publicKey: publicKey ?? this.publicKey,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  FlutterSecureStorage get _storage => const FlutterSecureStorage();

  @override
  Future<AuthState> build() async {
    // Check if user has stored keys
    final privateKey = await _storage.read(key: _keyPrivateKey);
    final publicKey = await _storage.read(key: _keyPublicKey);

    if (privateKey != null && publicKey != null) {
      return AuthState(
        privateKey: privateKey,
        publicKey: publicKey,
        isAuthenticated: true,
      );
    }

    return const AuthState();
  }

  Future<void> savePrivateKey(String privateKey) async {
    // Derive public key from private key using secp256k1
    final publicKey = Schnorr.getPublicKey(privateKey);

    await _storage.write(key: _keyPrivateKey, value: privateKey);
    await _storage.write(key: _keyPublicKey, value: publicKey);

    state = AsyncData(
      AuthState(
        privateKey: privateKey,
        publicKey: publicKey,
        isAuthenticated: true,
      ),
    );
  }

  Future<void> logout() async {
    await _storage.delete(key: _keyPrivateKey);
    await _storage.delete(key: _keyPublicKey);

    state = const AsyncData(AuthState());
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
