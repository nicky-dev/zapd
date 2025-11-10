import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stall_provider.dart';
import '../models/stall_type.dart';
import '../widgets/stall_card.dart';
import 'stall_form_screen.dart';

class StallListScreen extends ConsumerWidget {
  const StallListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stallsAsync = ref.watch(stallNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Stalls'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(stallNotifierProvider.notifier).loadStalls();
            },
          ),
        ],
      ),
      body: stallsAsync.when(
        data: (stalls) {
          if (stalls.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No stalls yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first stall to get started',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: stalls.length,
            itemBuilder: (context, index) {
              return StallCard(stall: stalls[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(stallNotifierProvider.notifier).loadStalls();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateStallDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New Stall'),
      ),
    );
  }

  Future<void> _showCreateStallDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<StallType>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Stall Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: StallType.values.map((type) {
            return ListTile(
              leading: Text(type.icon, style: const TextStyle(fontSize: 32)),
              title: Text(type.displayName),
              subtitle: Text(type.description),
              onTap: () => Navigator.pop(context, type),
            );
          }).toList(),
        ),
      ),
    );

    if (result != null && context.mounted) {
      // Navigate to form screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StallFormScreen(),
        ),
      ).then((_) {
        // Refresh stalls list after returning from form
        ref.read(stallNotifierProvider.notifier).loadStalls();
      });
    }
  }
}
