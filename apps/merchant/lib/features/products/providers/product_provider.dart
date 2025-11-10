import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';
import '../../../core/providers/nostr_provider.dart';

/// Provider for ProductRepository
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final nostrClient = ref.watch(nostrClientProvider);
  final merchantPubkey = ref.watch(currentUserPubkeyProvider);

  return ProductRepository(
    nostrClient: nostrClient,
    merchantPubkey: merchantPubkey ?? '',
  );
});

/// Provider for fetching products by stall ID
final productListByStallProvider = FutureProvider.family<List<Product>, String>((ref, stallId) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.fetchProductsByStall(stallId);
});

/// Provider for a single product by ID
final productProvider = FutureProvider.family<Product?, String>((ref, productId) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.fetchProductById(productId);
});

/// State notifier for managing product operations
class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  ProductNotifier(this.ref, this.stallId) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  final Ref ref;
  final String stallId;

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(productRepositoryProvider);
      final products = await repository.fetchProductsByStall(stallId);
      state = AsyncValue.data(products);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createProduct(Product product, String privateKey) async {
    try {
      final repository = ref.read(productRepositoryProvider);
      await repository.saveProduct(product: product, privateKey: privateKey);
      await loadProducts();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product product, String privateKey) async {
    try {
      final repository = ref.read(productRepositoryProvider);
      await repository.saveProduct(product: product, privateKey: privateKey);
      await loadProducts();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId, String privateKey) async {
    try {
      final repository = ref.read(productRepositoryProvider);
      await repository.deleteProduct(productId: productId, privateKey: privateKey);
      await loadProducts();
    } catch (error) {
      rethrow;
    }
  }

  Future<Product> duplicateProduct(Product original, String privateKey) async {
    try {
      final repository = ref.read(productRepositoryProvider);
      final duplicated = repository.duplicateProduct(original);
      await repository.saveProduct(product: duplicated, privateKey: privateKey);
      await loadProducts();
      return duplicated;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> toggleAvailability(Product product, String privateKey) async {
    try {
      final repository = ref.read(productRepositoryProvider);
      await repository.toggleAvailability(product: product, privateKey: privateKey);
      await loadProducts();
    } catch (error) {
      rethrow;
    }
  }
}

/// Provider for ProductNotifier (per stall)
final productNotifierProvider = StateNotifierProvider.family<ProductNotifier, AsyncValue<List<Product>>, String>((ref, stallId) {
  return ProductNotifier(ref, stallId);
});
