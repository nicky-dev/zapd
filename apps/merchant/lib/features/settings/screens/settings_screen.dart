import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostr_core/nostr_core.dart';
import '../../../core/providers/nostr_provider.dart';
import '../../../core/providers/media_server_provider.dart';
import '../../../core/widgets/language_switcher.dart';
import '../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final nostrClient = ref.watch(nostrClientProvider);
    final stats = nostrClient.stats;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        actions: const [
          LanguageSwitcher(),
        ],
      ),
      body: authState.when(
        data: (state) => ListView(
          children: [
            // Account Section
            _buildSectionHeader(l10n.account),
            _buildAccountTile(
              l10n.publicKey,
              state.publicKey != null ? NIP19.encodePublicKey(state.publicKey!) : l10n.notAvailable,
              Icons.key,
            ),
            if (state.privateKey != null)
              _buildPrivateKeyTile(state.privateKey!),
            const Divider(height: 32),

            // Relay Section
            _buildSectionHeader(l10n.nostrRelays),
            _buildRelayStats(stats),
            _buildRelayListTile(),
            const Divider(height: 32),

            // Media Server Section
            _buildSectionHeader(l10n.mediaServer),
            _buildMediaServerSettings(),
            const Divider(height: 32),

            // App Info Section
            _buildSectionHeader(l10n.about),
            _buildInfoTile(l10n.version, '1.0.0', Icons.info_outline),
            _buildInfoTile(l10n.protocol, 'Nostr + NIP-15', Icons.hub),
            _buildInfoTile(l10n.encryption, 'NIP-44 (XChaCha20)', Icons.lock),
            const Divider(height: 32),

            // Danger Zone
            _buildSectionHeader(l10n.dangerZone),
            _buildDangerTile(
              l10n.exportPrivateKey,
              l10n.backupPrivateKey,
              Icons.download,
              onTap: () => _exportPrivateKey(state.privateKey),
            ),
            _buildDangerTile(
              l10n.logout,
              l10n.signOutAccount,
              Icons.logout,
              onTap: _confirmLogout,
            ),
            const SizedBox(height: 32),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(l10n.errorLoadingSettings(error.toString())),
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
    final l10n = AppLocalizations.of(context)!;
    final nsec = NIP19.encodePrivateKey(privateKey);
    
    return ListTile(
      leading: const Icon(Icons.vpn_key),
      title: Text(l10n.privateKey),
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
            onPressed: () => _copyToClipboard(nsec, l10n.privateKey),
          ),
        ],
      ),
    );
  }

  Widget _buildRelayStats(Map<String, dynamic> stats) {
    final l10n = AppLocalizations.of(context)!;
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
              l10n.connectionStatus,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(l10n.total, total, Colors.blue),
                _buildStatColumn(l10n.connected, connected, Colors.green),
                _buildStatColumn(l10n.healthy, healthy, Colors.teal),
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
    final l10n = AppLocalizations.of(context)!;
    final nostrClient = ref.watch(nostrClientProvider);
    final relays = nostrClient.relays;

    return ExpansionTile(
      leading: const Icon(Icons.dns),
      title: Text(l10n.relayList),
      subtitle: Text(l10n.relaysConfigured(relays.length)),
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

  Widget _buildMediaServerSettings() {
    final l10n = AppLocalizations.of(context)!;
    final mediaServer = ref.watch(mediaServerProvider);

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.cloud_upload),
          title: Text(l10n.imageUploadServerTitle),
          subtitle: Text(
            "${mediaServer.isNIP96 ? l10n.serverNameWithTag(mediaServer.name, l10n.nip96Tag) : l10n.serverNameWithTag(mediaServer.name, l10n.legacyTag)}\n${mediaServer.serverUrl}",
            style: const TextStyle(fontSize: 12),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showMediaServerDialog,
            tooltip: l10n.changeServer,
          ),
        ),
      ],
    );
  }

  void _showMediaServerDialog() {
    final l10n = AppLocalizations.of(context)!;
    final currentServer = ref.read(mediaServerProvider);

    showDialog(
      context: context,
        builder: (context) => AlertDialog(
        title: Text(l10n.mediaServerSettingsTitle),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.selectMediaServerDescription),
              const SizedBox(height: 16),
              
              // Predefined servers
              ...MediaServerConfig.predefinedServers.map((server) {
                final isSelected = server.serverUrl == currentServer.serverUrl;
                return RadioListTile<String>(
                  dense: true,
                  value: server.serverUrl,
                  groupValue: currentServer.serverUrl,
          title: server.isNIP96
            ? Text(l10n.serverNameWithTag(server.name, l10n.nip96Tag))
            : Text(server.name),
                  subtitle: Text(
                    server.serverUrl,
                    style: const TextStyle(fontSize: 11),
                  ),
                  selected: isSelected,
                  onChanged: (value) {
                    ref.read(mediaServerProvider.notifier).setMediaServer(server);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.mediaServerChangedTo(server.name))),
                    );
                  },
                );
              }),
              
              const Divider(),
              
              // Custom server option
              ListTile(
                dense: true,
                leading: const Icon(Icons.add),
                title: Text(l10n.customServerTitle),
                onTap: () {
                  Navigator.pop(context);
                  _showCustomServerDialog();
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showCustomServerDialog() {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final urlController = TextEditingController();

    showDialog(
      context: context,
        builder: (context) => AlertDialog(
        title: Text(l10n.customServerTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.serverNameLabel,
                hintText: l10n.serverNameHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: l10n.uploadUrlLabel,
                hintText: l10n.uploadUrlHint,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final url = urlController.text.trim();
              
              if (name.isEmpty || url.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.pleaseFillAllFields)),
                );
                return;
              }
              
              if (!url.startsWith('http://') && !url.startsWith('https://')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.invalidUrlFormat)),
                );
                return;
              }
              
              ref.read(mediaServerProvider.notifier).setCustomMediaServer(url, name);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.mediaServerChangedTo(name))),
              );
            },
            child: Text(l10n.save),
          ),
        ],
      ),
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
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.copiedToClipboard(label))),
    );
  }

  void _exportPrivateKey(String? privateKey) {
    final l10n = AppLocalizations.of(context)!;
    if (privateKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.privateKeyNotAvailable)),
      );
      return;
    }

    final nsec = NIP19.encodePrivateKey(privateKey);

    showDialog(
      context: context,
        builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 8),
            Text(l10n.exportPrivateKey),
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
            child: Text(l10n.close),
          ),
          ElevatedButton.icon(
            onPressed: () {
              _copyToClipboard(nsec, l10n.privateKey);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.copy),
            label: Text(l10n.copyNsec),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
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
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}
