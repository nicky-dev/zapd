import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/language_switcher.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/stall_provider.dart';
import '../models/stall_type.dart';
import '../widgets/stall_card.dart';
import 'stall_form_screen.dart';

class StallListScreen extends ConsumerWidget {
  const StallListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final stallsAsync = ref.watch(stallNotifierProvider);
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width < 600 ? 16.0 : 48.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myStalls),
        actions: [
          const LanguageSwitcher(),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
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
                    l10n.noStallsYet,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.createFirstStall,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
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
              Text('${l10n.error}: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(stallNotifierProvider.notifier).loadStalls();
                },
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateStallDialog(context, ref),
        tooltip: l10n.newStall,
        icon: const Icon(Icons.add),
        label: Text(l10n.newStall),
      ),
    );
  }

  Future<void> _showCreateStallDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<StallType>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chooseStallType),
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
