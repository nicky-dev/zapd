enum StallType {
  food,
  shop;

  String get displayName {
    switch (this) {
      case StallType.food:
        return 'Restaurant / Food';
      case StallType.shop:
        return 'Shop / Mart';
    }
  }

  String get icon {
    switch (this) {
      case StallType.food:
        return '🍽️';
      case StallType.shop:
        return '🏪';
    }
  }

  String get description {
    switch (this) {
      case StallType.food:
        return 'Restaurants, cafes, food stalls';
      case StallType.shop:
        return 'Retail shops, marts, grocery stores';
    }
  }
}
