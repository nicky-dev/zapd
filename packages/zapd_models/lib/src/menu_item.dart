import 'package:equatable/equatable.dart';

/// Menu item model
class MenuItem extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<String> allergens;
  final bool isAvailable;
  final List<MenuItemOption> options;

  const MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.allergens = const [],
    this.isAvailable = true,
    this.options = const [],
  });

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        name,
        description,
        price,
        imageUrl,
        category,
        allergens,
        isAvailable,
        options,
      ];

  Map<String, dynamic> toJson() => {
        'id': id,
        'restaurantId': restaurantId,
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'category': category,
        'allergens': allergens,
        'isAvailable': isAvailable,
        'options': options.map((o) => o.toJson()).toList(),
      };

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      allergens: List<String>.from(json['allergens'] ?? []),
      isAvailable: json['isAvailable'] as bool? ?? true,
      options: (json['options'] as List?)
              ?.map((o) => MenuItemOption.fromJson(o))
              .toList() ??
          [],
    );
  }
}

/// Menu item option (e.g., size, toppings)
class MenuItemOption extends Equatable {
  final String name;
  final List<String> choices;
  final bool isRequired;
  final int maxSelections;

  const MenuItemOption({
    required this.name,
    required this.choices,
    this.isRequired = false,
    this.maxSelections = 1,
  });

  @override
  List<Object?> get props => [name, choices, isRequired, maxSelections];

  Map<String, dynamic> toJson() => {
        'name': name,
        'choices': choices,
        'isRequired': isRequired,
        'maxSelections': maxSelections,
      };

  factory MenuItemOption.fromJson(Map<String, dynamic> json) {
    return MenuItemOption(
      name: json['name'] as String,
      choices: List<String>.from(json['choices']),
      isRequired: json['isRequired'] as bool? ?? false,
      maxSelections: json['maxSelections'] as int? ?? 1,
    );
  }
}
