import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stall.dart';
import '../repositories/stall_repository.dart';
import '../../../core/providers/nostr_provider.dart';

/// Provider for StallRepository
final stallRepositoryProvider = Provider<StallRepository>((ref) {
  final nostrClient = ref.watch(nostrClientProvider);
  final merchantPubkey = ref.watch(currentUserPubkeyProvider);

  return StallRepository(
    nostrClient: nostrClient,
    merchantPubkey: merchantPubkey ?? '',
  );
});

/// Provider for fetching list of stalls
final stallListProvider = FutureProvider<List<Stall>>((ref) async {
  final repository = ref.watch(stallRepositoryProvider);
  return repository.fetchMyStalls();
});

/// Provider for a single stall by ID
final stallProvider = FutureProvider.family<Stall?, String>((ref, stallId) async {
  final repository = ref.watch(stallRepositoryProvider);
  return repository.fetchStallById(stallId);
});

/// State notifier for managing stall operations
class StallNotifier extends StateNotifier<AsyncValue<List<Stall>>> {
  StallNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadStalls();
  }

  final Ref ref;

  Future<void> loadStalls() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(stallRepositoryProvider);
      final stalls = await repository.fetchMyStalls();
      state = AsyncValue.data(stalls);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createStall(Stall stall, String privateKey) async {
    try {
      final repository = ref.read(stallRepositoryProvider);
      await repository.saveStall(stall: stall, privateKey: privateKey);
      await loadStalls();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateStall(Stall stall, String privateKey) async {
    try {
      final repository = ref.read(stallRepositoryProvider);
      await repository.saveStall(stall: stall, privateKey: privateKey);
      await loadStalls();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteStall(String stallId, String privateKey) async {
    try {
      final repository = ref.read(stallRepositoryProvider);
      await repository.deleteStall(stallId: stallId, privateKey: privateKey);
      await loadStalls();
    } catch (error) {
      rethrow;
    }
  }

  Future<Stall> duplicateStall(Stall original, String privateKey) async {
    try {
      final repository = ref.read(stallRepositoryProvider);
      final duplicated = repository.duplicateStall(original);
      await repository.saveStall(stall: duplicated, privateKey: privateKey);
      await loadStalls();
      return duplicated;
    } catch (error) {
      rethrow;
    }
  }
}

/// Provider for StallNotifier
final stallNotifierProvider =
    StateNotifierProvider<StallNotifier, AsyncValue<List<Stall>>>((ref) {
  return StallNotifier(ref);
});
