import '../repositories/pricing_repository.dart';
import 'sandwich.dart';

class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem({
    required this.sandwich,
    required this.quantity,
  });

  String get name => sandwich.name;

  double get unitPrice {
    final repo = PricingRepository();
    return repo.calculatePrice(quantity: 1, isFootlong: sandwich.isFootlong);
  }

  double get totalPrice {
    final repo = PricingRepository();
    return repo.calculatePrice(
        quantity: quantity, isFootlong: sandwich.isFootlong);
  }
}

class Cart {
  final List<CartItem> _items = [];
  final PricingRepository _pricingRepository = PricingRepository();

  /// Adds an item to the cart. If the item already exists, increases its quantity.
  void addItem(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;

    // Check if item already exists in cart
    final existingItemIndex = _items.indexWhere(
      (item) => _isSameSandwich(item.sandwich, sandwich),
    );

    if (existingItemIndex != -1) {
      // Item exists, increase quantity
      _items[existingItemIndex].quantity += quantity;
    } else {
      // New item, add to cart
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  /// Removes an item from the cart by matching sandwich properties
  bool removeItem(Sandwich sandwich) {
    final index = _items.indexWhere(
      (item) => _isSameSandwich(item.sandwich, sandwich),
    );

    if (index != -1) {
      _items.removeAt(index);
      return true;
    }
    return false;
  }

  /// Updates the quantity of an existing item in the cart
  bool updateQuantity(Sandwich sandwich, int newQuantity) {
    if (newQuantity < 0) return false;

    final index = _items.indexWhere(
      (item) => _isSameSandwich(item.sandwich, sandwich),
    );

    if (index != -1) {
      if (newQuantity == 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      return true;
    }
    return false;
  }

  /// Calculates the total price of all items in the cart using PricingRepository
  double calculateTotal() {
    double total = 0.0;
    for (final item in _items) {
      total += _pricingRepository.calculatePrice(
          quantity: item.quantity, isFootlong: item.sandwich.isFootlong);
    }
    return total;
  }

  /// Returns a list of all items in the cart
  List<CartItem> getItems() {
    return List.unmodifiable(_items);
  }

  /// Clears all items from the cart
  void clear() {
    _items.clear();
  }

  /// Returns the total number of items in the cart
  int get itemCount => _items.length;

  /// Returns the total quantity of all items in the cart
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Helper method to check if two sandwiches are the same
  bool _isSameSandwich(Sandwich s1, Sandwich s2) {
    return s1.type == s2.type &&
        s1.isFootlong == s2.isFootlong &&
        s1.breadType == s2.breadType;
  }
}
