import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('CartItem', () {
    test('name, unitPrice and totalPrice use Sandwich and PricingRepository',
        () {
      final sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.wheat,
      );

      final item = CartItem(sandwich: sandwich, quantity: 3);

      final repo = PricingRepository();
      final expectedUnit =
          repo.calculatePrice(quantity: 1, isFootlong: sandwich.isFootlong);
      final expectedTotal =
          repo.calculatePrice(quantity: 3, isFootlong: sandwich.isFootlong);

      expect(item.name, sandwich.name);
      expect(item.unitPrice, expectedUnit);
      expect(item.totalPrice, expectedTotal);
    });
  });

  group('Cart basic operations', () {
    late Cart cart;
    late Sandwich s1;
    late Sandwich s2;

    setUp(() {
      cart = Cart();
      s1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );
      s2 = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );
    });

    test('addItem adds new items and increases quantity for existing items',
        () {
      cart.addItem(s1);
      expect(cart.itemCount, 1);
      expect(cart.totalQuantity, 1);

      // add same sandwich should increase quantity, not itemCount
      cart.addItem(s1, quantity: 2);
      expect(cart.itemCount, 1);
      expect(cart.totalQuantity, 3);

      // add different sandwich
      cart.addItem(s2, quantity: 4);
      expect(cart.itemCount, 2);
      expect(cart.totalQuantity, 7);
    });

    test('removeItem removes existing item and returns correct boolean', () {
      cart.addItem(s1);
      cart.addItem(s2);

      final removed = cart.removeItem(s1);
      expect(removed, isTrue);
      expect(cart.itemCount, 1);

      // removing non-existing item returns false
      final removedAgain = cart.removeItem(s1);
      expect(removedAgain, isFalse);
    });

    test('updateQuantity updates, removes at zero, and rejects negative', () {
      cart.addItem(s1, quantity: 5);

      final ok = cart.updateQuantity(s1, 2);
      expect(ok, isTrue);
      expect(cart.totalQuantity, 2);

      // setting to zero removes item
      final removed = cart.updateQuantity(s1, 0);
      expect(removed, isTrue);
      expect(cart.itemCount, 0);

      // negative quantity is rejected
      cart.addItem(s2, quantity: 1);
      final bad = cart.updateQuantity(s2, -1);
      expect(bad, isFalse);
      expect(cart.itemCount, 1);
    });

    test('calculateTotal sums prices using PricingRepository', () {
      final repo = PricingRepository();

      cart.addItem(s1, quantity: 2);
      cart.addItem(s2, quantity: 3);

      final items = cart.getItems();
      double expected = 0;
      for (final it in items) {
        expected += repo.calculatePrice(
            quantity: it.quantity, isFootlong: it.sandwich.isFootlong);
      }

      expect(cart.calculateTotal(), expected);
    });

    test('getItems returns an unmodifiable list', () {
      cart.addItem(s1);
      final items = cart.getItems();
      expect(() => items.add(CartItem(sandwich: s1, quantity: 1)),
          throwsUnsupportedError);
    });

    test('clear removes all items', () {
      cart.addItem(s1);
      cart.addItem(s2);
      expect(cart.itemCount, greaterThan(0));
      cart.clear();
      expect(cart.itemCount, 0);
      expect(cart.totalQuantity, 0);
    });
  });
}
