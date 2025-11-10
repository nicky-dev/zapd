import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../../../core/providers/nostr_provider.dart';
import '../../../core/providers/image_upload_provider.dart';
import '../../auth/presentation/providers/auth_provider.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final String stallId;
  final Product? product; // null = create new, non-null = edit

  const ProductFormScreen({
    super.key,
    required this.stallId,
    this.product,
  });

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _currencyController;
  late TextEditingController _quantityController;
  late TextEditingController _preparationTimeController;
  late TextEditingController _dailyLimitController;
  late TextEditingController _spicyLevelController;

  List<String> _images = [];
  List<ProductSpec> _specs = [];
  List<ProductShipping> _shipping = [];
  List<String> _categories = [];
  bool _available = true;
  bool _isLoading = false;
  bool _isUploadingImage = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '0');
    _currencyController = TextEditingController(text: widget.product?.currency ?? 'THB');
    _quantityController = TextEditingController(
      text: widget.product?.quantity?.toString() ?? '',
    );
    _preparationTimeController = TextEditingController(
      text: widget.product?.preparationTime?.toString() ?? '',
    );
    _dailyLimitController = TextEditingController(
      text: widget.product?.dailyLimit?.toString() ?? '',
    );
    _spicyLevelController = TextEditingController(
      text: widget.product?.spicyLevel?.toString() ?? '0',
    );

    _images = List.from(widget.product?.images ?? []);
    _specs = List.from(widget.product?.specs ?? []);
    _shipping = List.from(widget.product?.shipping ?? []);
    _categories = List.from(widget.product?.categories ?? []);
    _available = widget.product?.available ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _currencyController.dispose();
    _quantityController.dispose();
    _preparationTimeController.dispose();
    _dailyLimitController.dispose();
    _spicyLevelController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final product = Product(
        id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        stallId: widget.stallId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        images: _images,
        currency: _currencyController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0.0,
        quantity: _quantityController.text.trim().isEmpty 
            ? null 
            : int.tryParse(_quantityController.text),
        specs: _specs,
        shipping: _shipping,
        available: _available,
        categories: _categories,
        spicyLevel: int.tryParse(_spicyLevelController.text),
        preparationTime: int.tryParse(_preparationTimeController.text),
        dailyLimit: int.tryParse(_dailyLimitController.text),
      );

      final privateKey = ref.read(currentUserPrivateKeyProvider);
      if (privateKey == null) {
        throw Exception('Private key not available');
      }

      await ref.read(productRepositoryProvider).saveProduct(
        product: product,
        privateKey: privateKey,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product ${widget.product == null ? "created" : "updated"} successfully')),
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

  void _addSpec() {
    showDialog(
      context: context,
      builder: (context) => _SpecDialog(
        onSave: (spec) {
          setState(() {
            _specs.add(spec);
          });
        },
      ),
    );
  }

  void _editSpec(int index) {
    showDialog(
      context: context,
      builder: (context) => _SpecDialog(
        spec: _specs[index],
        onSave: (spec) {
          setState(() {
            _specs[index] = spec;
          });
        },
      ),
    );
  }

  void _deleteSpec(int index) {
    setState(() {
      _specs.removeAt(index);
    });
  }

  void _addShipping() {
    showDialog(
      context: context,
      builder: (context) => _ShippingDialog(
        onSave: (shipping) {
          setState(() {
            _shipping.add(shipping);
          });
        },
      ),
    );
  }

  void _editShipping(int index) {
    showDialog(
      context: context,
      builder: (context) => _ShippingDialog(
        shipping: _shipping[index],
        onSave: (shipping) {
          setState(() {
            _shipping[index] = shipping;
          });
        },
      ),
    );
  }

  void _deleteShipping(int index) {
    setState(() {
      _shipping.removeAt(index);
    });
  }

  void _addCategory() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Category'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Category Name',
              hintText: 'e.g., Main Course, Dessert',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _categories.add(controller.text.trim());
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickAndUploadImage() async {
    try {
      // Pick image
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() => _isUploadingImage = true);

      // Read image bytes
      final bytes = await pickedFile.readAsBytes();

      // Get private key for NIP-98 auth
      final authState = await ref.read(authProvider.future);
      final privateKey = authState.privateKey;

      if (privateKey == null) {
        throw Exception('Private key not available for authentication');
      }

      // Upload using NIP-96
      final nip96Service = ref.read(nip96ServiceProvider);
      final response = await nip96Service.uploadFile(
        imageBytes: bytes,
        fileName: pickedFile.name,
        privateKey: privateKey,
      );

      if (!response.isSuccess || response.nip94Event?.url == null) {
        throw Exception(response.message);
      }

      final imageUrl = response.nip94Event!.url!;

      // Add to images list
      setState(() {
        _images.add(imageUrl);
        _isUploadingImage = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully')),
        );
      }
    } catch (e) {
      setState(() => _isUploadingImage = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Create Product' : 'Edit Product'),
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
              onPressed: _saveProduct,
              tooltip: 'Save',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Basic Info
            _buildSectionHeader('Basic Information'),
            const SizedBox(height: 12),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name *',
                hintText: 'e.g., Pad Thai',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe the product...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Images Section
            _buildSectionHeader('Product Images'),
            const SizedBox(height: 8),
            Text(
              'Upload images to showcase your product',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),

            if (_images.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.image, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('No images added'),
                      ],
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(right: 8),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          Image.network(
                            _images[index],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              );
                            },
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black54,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(4),
                                minimumSize: const Size(32, 32),
                              ),
                              onPressed: () => _removeImage(index),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _isUploadingImage ? null : _pickAndUploadImage,
              icon: _isUploadingImage
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_photo_alternate),
              label: Text(_isUploadingImage ? 'Uploading...' : 'Add Image'),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _currencyController,
                    decoration: const InputDecoration(
                      labelText: 'Currency *',
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
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                hintText: 'Leave empty for unlimited',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Food-specific
            _buildSectionHeader('Food Details'),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _spicyLevelController,
                    decoration: const InputDecoration(
                      labelText: 'Spicy Level (0-5)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
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
            const SizedBox(height: 16),

            TextFormField(
              controller: _dailyLimitController,
              decoration: const InputDecoration(
                labelText: 'Daily Limit',
                hintText: 'Max orders per day',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Categories
            _buildSectionHeader('Categories'),
            const SizedBox(height: 12),

            if (_categories.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text('No categories added'),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((category) {
                  return Chip(
                    label: Text(category),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        _categories.remove(category);
                      });
                    },
                  );
                }).toList(),
              ),

            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addCategory,
              icon: const Icon(Icons.add),
              label: const Text('Add Category'),
            ),
            const SizedBox(height: 24),

            // Product Specs (NIP-15)
            _buildSectionHeader('Product Specifications (NIP-15)'),
            const SizedBox(height: 12),

            if (_specs.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text('No specs added'),
                  ),
                ),
              )
            else
              ..._specs.asMap().entries.map((entry) {
                final index = entry.key;
                final spec = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(spec.key),
                    subtitle: Text(spec.value),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _editSpec(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          color: Colors.red,
                          onPressed: () => _deleteSpec(index),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addSpec,
              icon: const Icon(Icons.add),
              label: const Text('Add Specification'),
            ),
            const SizedBox(height: 24),

            // Shipping (NIP-15)
            _buildSectionHeader('Shipping Costs (NIP-15)'),
            const SizedBox(height: 8),
            Text(
              'Extra shipping costs per zone',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),

            if (_shipping.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text('No shipping overrides'),
                  ),
                ),
              )
            else
              ..._shipping.asMap().entries.map((entry) {
                final index = entry.key;
                final ship = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.local_shipping),
                    title: Text('Zone: ${ship.id}'),
                    subtitle: Text('Extra cost: ${ship.cost}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _editShipping(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          color: Colors.red,
                          onPressed: () => _deleteShipping(index),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addShipping,
              icon: const Icon(Icons.add),
              label: const Text('Add Shipping Override'),
            ),
            const SizedBox(height: 24),

            // Availability
            _buildSectionHeader('Availability'),
            const SizedBox(height: 12),

            SwitchListTile(
              title: const Text('Available for Order'),
              subtitle: const Text('Customers can order this product'),
              value: _available,
              onChanged: (value) {
                setState(() {
                  _available = value;
                });
              },
            ),
            const SizedBox(height: 32),

            // Save Button
            FilledButton.icon(
              onPressed: _isLoading ? null : _saveProduct,
              icon: const Icon(Icons.save),
              label: Text(widget.product == null ? 'Create Product' : 'Update Product'),
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

// Dialog for adding/editing specs
class _SpecDialog extends StatefulWidget {
  final ProductSpec? spec;
  final Function(ProductSpec) onSave;

  const _SpecDialog({
    this.spec,
    required this.onSave,
  });

  @override
  State<_SpecDialog> createState() => _SpecDialogState();
}

class _SpecDialogState extends State<_SpecDialog> {
  late TextEditingController _keyController;
  late TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(text: widget.spec?.key ?? '');
    _valueController = TextEditingController(text: widget.spec?.value ?? '');
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _save() {
    if (_keyController.text.trim().isEmpty || _valueController.text.trim().isEmpty) {
      return;
    }

    final spec = ProductSpec(
      key: _keyController.text.trim(),
      value: _valueController.text.trim(),
    );

    widget.onSave(spec);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.spec == null ? 'Add Specification' : 'Edit Specification'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _keyController,
            decoration: const InputDecoration(
              labelText: 'Key *',
              hintText: 'e.g., Size, Weight, Material',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _valueController,
            decoration: const InputDecoration(
              labelText: 'Value *',
              hintText: 'e.g., Large, 500g, Cotton',
              border: OutlineInputBorder(),
            ),
          ),
        ],
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

// Dialog for adding/editing shipping
class _ShippingDialog extends StatefulWidget {
  final ProductShipping? shipping;
  final Function(ProductShipping) onSave;

  const _ShippingDialog({
    this.shipping,
    required this.onSave,
  });

  @override
  State<_ShippingDialog> createState() => _ShippingDialogState();
}

class _ShippingDialogState extends State<_ShippingDialog> {
  late TextEditingController _idController;
  late TextEditingController _costController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.shipping?.id ?? '');
    _costController = TextEditingController(text: widget.shipping?.cost.toString() ?? '0');
  }

  @override
  void dispose() {
    _idController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _save() {
    final cost = double.tryParse(_costController.text) ?? 0.0;

    final shipping = ProductShipping(
      id: _idController.text.trim(),
      cost: cost,
    );

    widget.onSave(shipping);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.shipping == null ? 'Add Shipping Override' : 'Edit Shipping Override'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _idController,
            decoration: const InputDecoration(
              labelText: 'Zone ID *',
              hintText: 'Must match stall shipping zone',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _costController,
            decoration: const InputDecoration(
              labelText: 'Extra Cost *',
              hintText: 'Additional shipping cost',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
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
