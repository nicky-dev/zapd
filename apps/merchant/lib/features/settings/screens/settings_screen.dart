import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostr_core/nostr_core.dart';
import '../../../core/providers/nostr_provider.dart';
import '../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _showPrivateKey = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final nostrClient = ref.watch(nostrClientProvider);
    final stats = nostrClient.stats;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: authState.when(
        data: (state) => ListView(
          children: [
            // Account Section
            _buildSectionHeader('Account'),
            _buildAccountTile(
              'Public Key (npub)',
              state.publicKey != null ? NIP19.encodePublicKey(state.publicKey!) : 'Not available',
              Icons.key,
            ),
            if (state.privateKey != null)
              _buildPrivateKeyTile(state.privateKey!),
            const Divider(height: 32),

            // Relay Section
            _buildSectionHeader('Nostr Relays'),
            _buildRelayStats(stats),
            _buildRelayListTile(),
            const Divider(height: 32),

            // App Info Section
            _buildSectionHeader('About'),
            _buildInfoTile('Version', '1.0.0', Icons.info_outline),
            _buildInfoTile('Protocol', 'Nostr + NIP-15', Icons.hub),
            _buildInfoTile('Encryption', 'NIP-44 (XChaCha20)', Icons.lock),
            const Divider(height: 32),

            // Danger Zone
            _buildSectionHeader('Danger Zone'),
            _buildDangerTile(
              'Export Private Key',
              'Backup your private key',
              Icons.download,
              onTap: () => _exportPrivateKey(state.privateKey),
            ),
            _buildDangerTile(
              'Logout',
              'Sign out from your account',
              Icons.logout,
              onTap: _confirmLogout,
            ),
            const SizedBox(height: 32),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading settings: $error'),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildAccountTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(
        value.length > 16 ? '${value.substring(0, 16)}...' : value,
        style: const TextStyle(fontFamily: 'monospace'),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.copy),
        onPressed: () => _copyToClipboard(value, label),
      ),
    );
  }

  Widget _buildPrivateKeyTile(String privateKey) {
    final nsec = NIP19.encodePrivateKey(privateKey);
    
    return ListTile(
      leading: const Icon(Icons.vpn_key),
      title: const Text('Private Key (nsec)'),
      subtitle: Text(
        _showPrivateKey
            ? (nsec.length > 32
                ? '${nsec.substring(0, 32)}...'
                : nsec)
            : '••••••••••••••••',
        style: const TextStyle(fontFamily: 'monospace'),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(_showPrivateKey ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _showPrivateKey = !_showPrivateKey;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => _copyToClipboard(nsec, 'Private Key (nsec)'),
          ),
        ],
      ),
    );
  }

  Widget _buildRelayStats(Map<String, dynamic> stats) {
    final total = stats['total'] as int? ?? 0;
    final connected = stats['connected'] as int? ?? 0;
    final healthy = stats['healthy'] as int? ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connection Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Total', total, Colors.blue),
                _buildStatColumn('Connected', connected, Colors.green),
                _buildStatColumn('Healthy', healthy, Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildRelayListTile() {
    final nostrClient = ref.watch(nostrClientProvider);
    final relays = nostrClient.relays;

    return ExpansionTile(
      leading: const Icon(Icons.dns),
      title: const Text('Relay List'),
      subtitle: Text('${relays.length} relays configured'),
      children: relays.map((relay) {
        final stats = nostrClient.stats['relays'] as Map<String, dynamic>? ?? {};
        final relayStats = stats[relay.url] as Map<String, dynamic>? ?? {};
        final status = relayStats['status'] as String? ?? 'unknown';
        final isHealthy = relayStats['isHealthy'] as bool? ?? false;

        return ListTile(
          dense: true,
          leading: Icon(
            isHealthy ? Icons.check_circle : Icons.error,
            color: isHealthy ? Colors.green : Colors.red,
            size: 20,
          ),
          title: Text(
            relay.url.replaceAll('wss://', '').replaceAll('ws://', ''),
            style: const TextStyle(fontSize: 13),
          ),
          subtitle: Text(
            status,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
          trailing: relayStats['messagesSent'] != null
              ? Text(
                  '↑${relayStats['messagesSent']} ↓${relayStats['messagesReceived']}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                )
              : null,
        );
      }).toList(),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }

  Widget _buildDangerTile(
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.red[700]),
      title: Text(
        title,
        style: TextStyle(color: Colors.red[700]),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied to clipboard')),
    );
  }

  void _exportPrivateKey(String? privateKey) {
    if (privateKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Private key not available')),
      );
      return;
    }

    final nsec = NIP19.encodePrivateKey(privateKey);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Export Private Key'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚠️ Never share your private key with anyone!\n\n'
              'This key gives full access to your account.\n\n'
              'Store it safely offline.',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Text(
              'Format: nsec (bech32)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                nsec,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Format: hex',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                privateKey,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              _copyToClipboard(nsec, 'Private key (nsec)');
              Navigator.pop(context);
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy nsec'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close settings
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
