import 'package:flutter/material.dart';
import '../models/product.dart';
import '../../stalls/models/stall.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Stall stall;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.stall,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Product image/icon
                if (product.images.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.images.first,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage(context);
                      },
                    ),
                  )
                else
                  _buildPlaceholderImage(context),
                const SizedBox(width: 16),
                // Product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${product.price} ${product.currency}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (product.quantity != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Stock: ${product.quantity}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: (product.quantity ?? 0) > 0
                                    ? Colors.green[700]
                                    : Colors.red[700],
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (product.description?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Text(
                product.description!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            // Product details
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (product.categories.isNotEmpty)
                  ...product.categories.take(2).map(
                        (category) => Chip(
                          label: Text(
                            category,
                            style: const TextStyle(fontSize: 12),
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                if (product.preparationTime != null)
                  Chip(
                    avatar: const Icon(Icons.schedule, size: 16),
                    label: Text(
                      '${product.preparationTime} min',
                      style: const TextStyle(fontSize: 12),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                if (product.spicyLevel != null && product.spicyLevel! > 0)
                  Chip(
                    avatar: const Icon(Icons.whatshot, size: 16),
                    label: Text(
                      '🌶️' * product.spicyLevel!,
                      style: const TextStyle(fontSize: 12),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            // Actions
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.restaurant_menu,
        size: 40,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
