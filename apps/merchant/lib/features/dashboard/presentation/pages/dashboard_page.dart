import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/language_switcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../stalls/screens/stall_list_screen.dart';
import '../../../orders/screens/order_list_screen.dart';
import '../../../orders/providers/order_provider.dart';
import '../../../settings/screens/settings_screen.dart';
import '../../../notifications/widgets/notification_bell.dart';
import '../../../analytics/screens/analytics_screen.dart';
import '../../../receipts/screens/receipts_screen.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final pendingOrders = ref.watch(pendingOrdersProvider);
    final activeOrders = ref.watch(activeOrdersProvider);
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width < 600 ? 16.0 : 48.0;
    final isNarrow = width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          const LanguageSwitcher(),
          const NotificationBell(),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Receipts',
            onPressed: () => _navigateToReceipts(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settings,
            onPressed: () => _navigateToSettings(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                // Navigate to auth page
              }
            },
          ),
        ],
      ),
      body: authState.when(
        data: (state) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              Text(
                l10n.welcomeBack,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.manageYourBusiness,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),

              // Quick stats
              if (isNarrow) ...[
                _StatCard(
                  icon: Icons.pending_actions,
                  label: l10n.pendingOrders,
                  value: pendingOrders.length.toString(),
                  color: Colors.orange,
                  onTap: () => _navigateToOrders(context, OrderFilter.pending),
                ),
                const SizedBox(height: 12),
                _StatCard(
                  icon: Icons.restaurant,
                  label: l10n.activeOrders,
                  value: activeOrders.length.toString(),
                  color: Colors.blue,
                  onTap: () => _navigateToOrders(context, OrderFilter.active),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.pending_actions,
                        label: l10n.pendingOrders,
                        value: pendingOrders.length.toString(),
                        color: Colors.orange,
                        onTap: () => _navigateToOrders(context, OrderFilter.pending),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.restaurant,
                        label: l10n.activeOrders,
                        value: activeOrders.length.toString(),
                        color: Colors.blue,
                        onTap: () => _navigateToOrders(context, OrderFilter.active),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 32),

              // Main menu
              Text(
                l10n.quickActions,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              _MenuCard(
                icon: Icons.store,
                title: l10n.myStalls,
                subtitle: l10n.manageStalls,
                color: Colors.orange,
                onTap: () => _navigateToStalls(context),
              ),
              const SizedBox(height: 12),
              _MenuCard(
                icon: Icons.receipt_long,
                title: l10n.myOrders,
                subtitle: l10n.viewAndManageOrders,
                color: Colors.green,
                onTap: () => _navigateToOrders(context, OrderFilter.all),
              ),
              const SizedBox(height: 12),
              _MenuCard(
                icon: Icons.analytics,
                title: l10n.analytics,
                subtitle: l10n.analyticsSubtitle,
                color: Colors.blue,
                onTap: () => _navigateToAnalytics(context),
              ),
              const SizedBox(height: 12),
              _MenuCard(
                icon: Icons.settings,
                title: l10n.settings,
                subtitle: l10n.configureApp,
                color: Colors.grey,
                onTap: () => _navigateToSettings(context),
              ),

              const SizedBox(height: 32),

              // Account info
              if (state.publicKey != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.accountInformation,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Text(
                          '${l10n.publicKey}:',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.publicKey!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToStalls(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StallListScreen(),
      ),
    );
  }

  void _navigateToOrders(BuildContext context, OrderFilter filter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OrderListScreen(),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _navigateToAnalytics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AnalyticsScreen(),
      ),
    );
  }

  void _navigateToReceipts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReceiptsScreen(),
      ),
    );
  }
}

enum OrderFilter { all, pending, active }

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
