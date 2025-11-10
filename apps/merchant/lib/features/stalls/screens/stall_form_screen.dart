import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stall.dart';
import '../models/stall_type.dart';
import '../providers/stall_provider.dart';
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
    if (!_formKey.currentState!.validate()) return;
    if (_shippingZones.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one shipping zone')),
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
          SnackBar(content: Text('Stall ${widget.stall == null ? "created" : "updated"} successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stall == null ? 'Create Stall' : 'Edit Stall'),
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
              tooltip: 'Save',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Basic Info Section
            _buildSectionHeader('Basic Information'),
            const SizedBox(height: 12),
            
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Stall Name *',
                hintText: 'e.g., Thai Street Food',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter stall name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your stall...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<StallType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Stall Type *',
                border: OutlineInputBorder(),
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
                    decoration: const InputDecoration(
                      labelText: 'Currency *',
                      hintText: 'THB, USD, BTC',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _preparationTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Prep Time (min)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Food-specific fields
            if (_selectedType == StallType.food) ...[
              _buildSectionHeader('Food Details'),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _cuisineController,
                decoration: const InputDecoration(
                  labelText: 'Cuisine Type',
                  hintText: 'e.g., Thai, Japanese, Italian',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _operatingHoursController,
                decoration: const InputDecoration(
                  labelText: 'Operating Hours',
                  hintText: '09:00-22:00',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Shipping Zones Section
            _buildSectionHeader('Shipping Zones (NIP-15)'),
            const SizedBox(height: 8),
            Text(
              'Define delivery zones with their costs and regions',
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
                      'No shipping zones added',
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
                    title: Text(zone.name ?? 'Zone ${zone.id}'),
                    subtitle: Text(
                      'Cost: ${zone.cost} ${_currencyController.text}\n'
                      'Regions: ${zone.regions.isEmpty ? "All" : zone.regions.join(", ")}',
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
              label: const Text('Add Shipping Zone'),
            ),
            const SizedBox(height: 24),

            // Settings
            _buildSectionHeader('Settings'),
            const SizedBox(height: 12),
            
            SwitchListTile(
              title: const Text('Accepts Orders'),
              subtitle: const Text('Allow customers to place orders'),
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
              label: Text(widget.stall == null ? 'Create Stall' : 'Update Stall'),
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
      title: Text(widget.zone == null ? 'Add Shipping Zone' : 'Edit Shipping Zone'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'Zone ID *',
                hintText: 'zone_1',
                border: OutlineInputBorder(),
              ),
              enabled: widget.zone == null, // Can't change ID when editing
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Zone Name',
                hintText: 'e.g., Local Delivery, Express',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _costController,
              decoration: const InputDecoration(
                labelText: 'Shipping Cost *',
                hintText: '30.00',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _regionsController,
              decoration: const InputDecoration(
                labelText: 'Regions',
                hintText: 'region1, region2, region3',
                helperText: 'Comma-separated list (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
