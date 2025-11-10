import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'product_form_screen.dart';
import '../../stalls/models/stall.dart';
import '../../auth/presentation/providers/auth_provider.dart';

class ProductListScreen extends ConsumerWidget {
  final Stall stall;

  const ProductListScreen({
    super.key,
    required this.stall,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productNotifierProvider(stall.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('${stall.name} - Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(productNotifierProvider(stall.id).notifier).loadProducts();
            },
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No products yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first product to start selling',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _navigateToAddProduct(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(productNotifierProvider(stall.id).notifier).loadProducts();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ProductCard(
                    product: product,
                    stall: stall,
                    onEdit: () => _navigateToEditProduct(context, ref, product),
                    onDelete: () => _deleteProduct(context, ref, product),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load products',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.read(productNotifierProvider(stall.id).notifier).loadProducts();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: productsAsync.maybeWhen(
        data: (products) => products.isNotEmpty
            ? FloatingActionButton(
                onPressed: () => _navigateToAddProduct(context, ref),
                child: const Icon(Icons.add),
              )
            : null,
        orElse: () => null,
      ),
    );
  }

  void _navigateToAddProduct(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(stallId: stall.id),
      ),
    ).then((_) {
      // Refresh list after returning
      ref.read(productNotifierProvider(stall.id).notifier).loadProducts();
    });
  }

  void _navigateToEditProduct(BuildContext context, WidgetRef ref, product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(
          stallId: stall.id,
          product: product,
        ),
      ),
    ).then((_) {
      // Refresh list after returning
      ref.read(productNotifierProvider(stall.id).notifier).loadProducts();
    });
  }

  Future<void> _deleteProduct(BuildContext context, WidgetRef ref, product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Get private key from auth provider
      final authState = await ref.read(authProvider.future);
      final privateKey = authState.privateKey;

      if (privateKey == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication required')),
          );
        }
        return;
      }

      try {
        await ref
            .read(productNotifierProvider(stall.id).notifier)
            .deleteProduct(product.id, privateKey);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete product: $e')),
          );
        }
      }
    }
  }
}

