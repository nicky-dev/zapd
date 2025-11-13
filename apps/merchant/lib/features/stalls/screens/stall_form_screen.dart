import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../models/stall.dart';
import '../models/stall_type.dart';
import '../providers/stall_provider.dart';
import '../widgets/stall_location_picker.dart';
import '../../../core/providers/nostr_provider.dart';

class StallFormScreen extends ConsumerStatefulWidget {
  final Stall? stall; // null = create new, non-null = edit

  const StallFormScreen({super.key, this.stall});

  @override
  ConsumerState<StallFormScreen> createState() => _StallFormScreenState();
}

class _StallFormScreenState extends ConsumerState<StallFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _currencyController;
  late TextEditingController _cuisineController;
  late TextEditingController _preparationTimeController;
  late TextEditingController _operatingHoursController;
  double? _latitude;
  double? _longitude;
  String? _locationName;

  StallType _selectedType = StallType.food;
  bool _acceptsOrders = true;
  List<ShippingZone> _shippingZones = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize with existing stall data or defaults
    _nameController = TextEditingController(text: widget.stall?.name ?? '');
    _descriptionController = TextEditingController(text: widget.stall?.description ?? '');
    _currencyController = TextEditingController(text: widget.stall?.currency ?? 'THB');
    _cuisineController = TextEditingController(text: widget.stall?.cuisine ?? '');
    _preparationTimeController = TextEditingController(
      text: widget.stall?.preparationTime?.toString() ?? '15'
    );
    _operatingHoursController = TextEditingController(
      text: widget.stall?.operatingHours ?? '09:00-22:00'
    );

    _selectedType = widget.stall?.stallType ?? StallType.food;
    _acceptsOrders = widget.stall?.acceptsOrders ?? true;
    _shippingZones = List.from(widget.stall?.shipping ?? [
      ShippingZone(
        id: 'zone_1',
        name: 'Local Delivery',
        cost: 30.0,
        regions: ['default'],
      ),
    ]);
    _latitude = widget.stall?.latitude;
    _longitude = widget.stall?.longitude;
    _locationName = widget.stall?.locationName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _currencyController.dispose();
    _cuisineController.dispose();
    _preparationTimeController.dispose();
    _operatingHoursController.dispose();
    super.dispose();
  }

  Future<void> _saveStall() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_shippingZones.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseAddShippingZone)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final stall = Stall(
        id: widget.stall?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        currency: _currencyController.text.trim(),
        shipping: _shippingZones,
        stallType: _selectedType,
        cuisine: _cuisineController.text.trim().isEmpty 
            ? null 
            : _cuisineController.text.trim(),
        preparationTime: int.tryParse(_preparationTimeController.text),
        operatingHours: _operatingHoursController.text.trim().isEmpty 
            ? null 
            : _operatingHoursController.text.trim(),
        acceptsOrders: _acceptsOrders,
        latitude: _latitude,
        longitude: _longitude,
        locationName: _locationName,
      );

      if (widget.stall == null) {
        final privateKey = ref.read(currentUserPrivateKeyProvider);
        await ref.read(stallNotifierProvider.notifier).createStall(stall, privateKey!);
      } else {
        final privateKey = ref.read(currentUserPrivateKeyProvider);
        await ref.read(stallNotifierProvider.notifier).updateStall(stall, privateKey!);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.stall == null ? l10n.stallCreatedSuccessfully : l10n.stallUpdatedSuccessfully)),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorWithMessage(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _addShippingZone() {
    showDialog(
      context: context,
      builder: (context) => _ShippingZoneDialog(
        onSave: (zone) {
          setState(() {
            _shippingZones.add(zone);
          });
        },
      ),
    );
  }

  void _editShippingZone(int index) {
    showDialog(
      context: context,
      builder: (context) => _ShippingZoneDialog(
        zone: _shippingZones[index],
        onSave: (zone) {
          setState(() {
            _shippingZones[index] = zone;
          });
        },
      ),
    );
  }

  void _deleteShippingZone(int index) {
    setState(() {
      _shippingZones.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stall == null ? l10n.createStall : l10n.editStall),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveStall,
              tooltip: l10n.save,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Basic Info Section
            _buildSectionHeader(l10n.basicInformation),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.stallNameRequired,
                hintText: l10n.stallNameHint,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.pleaseEnterStallName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.descriptionLabel,
                hintText: l10n.descriptionHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<StallType>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: l10n.stallTypeLabel,
                border: const OutlineInputBorder(),
              ),
              items: StallType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Text(type.icon, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(type.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _currencyController,
                    decoration: InputDecoration(
                      labelText: l10n.currencyLabel,
                      hintText: l10n.currencyHint,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.requiredLabel;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _preparationTimeController,
                    decoration: InputDecoration(
                      labelText: l10n.prepTimeLabel,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Food-specific fields
            if (_selectedType == StallType.food) ...[
              _buildSectionHeader(l10n.foodDetailsLabel),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _cuisineController,
                decoration: InputDecoration(
                  labelText: l10n.cuisineTypeLabel,
                  hintText: l10n.cuisineHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _operatingHoursController,
                decoration: InputDecoration(
                  labelText: l10n.operatingHoursLabel,
                  hintText: l10n.operatingHoursHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Location picker for food stalls
              Row(
                children: [
                  Expanded(
                    child: Text(_locationName ?? (_latitude != null ? '${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}' : 'No location selected')),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.location_on),
                    label: const Text('Pick location'),
                    onPressed: () async {
                      final result = await showModalBottomSheet<Map<String, dynamic>>(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => FractionallySizedBox(
                          heightFactor: 0.9,
                          child: SafeArea(child: StallLocationPicker()),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          _latitude = result['latitude'] as double?;
                          _longitude = result['longitude'] as double?;
                          _locationName = result['name'] as String?;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
            ],

            // Shipping Zones Section
            _buildSectionHeader(l10n.shippingZonesLabel),
            const SizedBox(height: 8),
            Text(
              l10n.shippingZonesDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),

            if (_shippingZones.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      l10n.noShippingZonesAdded,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              )
            else
              ..._shippingZones.asMap().entries.map((entry) {
                final index = entry.key;
                final zone = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(zone.name ?? l10n.zoneLabel(zone.id)),
                    subtitle: Text(
                      '${l10n.costLabel}: ${zone.cost} ${_currencyController.text}\n${l10n.regionsLabel}: ${zone.regions.isEmpty ? l10n.allRegions : zone.regions.join(", ")}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editShippingZone(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => _deleteShippingZone(index),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addShippingZone,
              icon: const Icon(Icons.add),
          label: Text(l10n.addShippingZone),
            ),
            const SizedBox(height: 24),

            // Settings
            _buildSectionHeader(l10n.settings),
            const SizedBox(height: 12),
            
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.acceptsOrders),
              subtitle: Text(AppLocalizations.of(context)!.acceptsOrdersDescription),
              value: _acceptsOrders,
              onChanged: (value) {
                setState(() {
                  _acceptsOrders = value;
                });
              },
            ),
            const SizedBox(height: 32),

            // Save Button
            FilledButton.icon(
              onPressed: _isLoading ? null : _saveStall,
              icon: const Icon(Icons.save),
              label: Text(widget.stall == null ? l10n.createStall : l10n.updateStall),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Dialog for adding/editing shipping zones
class _ShippingZoneDialog extends StatefulWidget {
  final ShippingZone? zone;
  final Function(ShippingZone) onSave;

  const _ShippingZoneDialog({
    this.zone,
    required this.onSave,
  });

  @override
  State<_ShippingZoneDialog> createState() => _ShippingZoneDialogState();
}

class _ShippingZoneDialogState extends State<_ShippingZoneDialog> {
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _costController;
  late TextEditingController _regionsController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(
      text: widget.zone?.id ?? 'zone_${DateTime.now().millisecondsSinceEpoch}',
    );
    _nameController = TextEditingController(text: widget.zone?.name ?? '');
    _costController = TextEditingController(text: widget.zone?.cost.toString() ?? '0');
    _regionsController = TextEditingController(
      text: widget.zone?.regions.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _costController.dispose();
    _regionsController.dispose();
    super.dispose();
  }

  void _save() {
    final cost = double.tryParse(_costController.text) ?? 0.0;
    final regions = _regionsController.text
        .split(',')
        .map((r) => r.trim())
        .where((r) => r.isNotEmpty)
        .toList();

    final zone = ShippingZone(
      id: _idController.text.trim(),
      name: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
      cost: cost,
      regions: regions,
    );

    widget.onSave(zone);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
  title: Text(widget.zone == null ? AppLocalizations.of(context)!.addShippingZone : AppLocalizations.of(context)!.editShippingZone),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.zoneIdLabel,
                hintText: AppLocalizations.of(context)!.zoneIdHint,
                border: const OutlineInputBorder(),
              ),
              enabled: widget.zone == null, // Can't change ID when editing
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.zoneNameLabel,
                hintText: AppLocalizations.of(context)!.zoneNameHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _costController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.shippingCostLabel,
                hintText: AppLocalizations.of(context)!.shippingCostHint,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _regionsController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.regionsLabel,
                hintText: AppLocalizations.of(context)!.regionsHint,
                helperText: AppLocalizations.of(context)!.regionsHelper,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(AppLocalizations.of(context)!.save),
        ),
      ],
    );
  }
}
