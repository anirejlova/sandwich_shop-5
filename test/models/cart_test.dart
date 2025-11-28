import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
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

    test('add adds new items and increases quantity for existing items', () {
      cart.add(s1);
      expect(cart.length, 1);
      expect(cart.countOfItems, 1);
      expect(cart.getQuantity(s1), 1);

      // add same sandwich should increase quantity, not length
      cart.add(s1, quantity: 2);
      expect(cart.length, 1);
      expect(cart.countOfItems, 3);
      expect(cart.getQuantity(s1), 3);

      // add different sandwich
      cart.add(s2, quantity: 4);
      expect(cart.length, 2);
      expect(cart.countOfItems, 7);
      expect(cart.getQuantity(s2), 4);
    });

    test(
        'remove decreases quantity and removes item when quantity reaches zero',
        () {
      cart.add(s1, quantity: 5);
      cart.add(s2, quantity: 2);

      // remove 2 from s1, should still have 3 left
      cart.remove(s1, quantity: 2);
      expect(cart.length, 2);
      expect(cart.getQuantity(s1), 3);

      // remove more than quantity, should remove item completely
      cart.remove(s1, quantity: 10);
      expect(cart.length, 1);
      expect(cart.getQuantity(s1), 0);
      expect(cart.isEmpty, isFalse);

      // remove from s2
      cart.remove(s2, quantity: 2);
      expect(cart.isEmpty, isTrue);
    });

    test('remove with default quantity removes 1', () {
      cart.add(s1, quantity: 3);
      cart.remove(s1);
      expect(cart.getQuantity(s1), 2);
    });

    test('remove non-existing item does nothing', () {
      cart.add(s1);
      cart.remove(s2);
      expect(cart.length, 1);
      expect(cart.getQuantity(s1), 1);
    });

    test('totalPrice calculates correctly using PricingRepository', () {
      final repo = PricingRepository();

      cart.add(s1, quantity: 2);
      cart.add(s2, quantity: 3);

      final expectedS1 =
          repo.calculatePrice(quantity: 2, isFootlong: s1.isFootlong);
      final expectedS2 =
          repo.calculatePrice(quantity: 3, isFootlong: s2.isFootlong);
      final expected = expectedS1 + expectedS2;

      expect(cart.totalPrice, expected);
    });

    test('totalPrice returns 0 for empty cart', () {
      expect(cart.totalPrice, 0.0);
    });

    test('items returns an unmodifiable map', () {
      cart.add(s1, quantity: 2);
      final items = cart.items;

      // Should throw when trying to modify
      expect(() => items[s2] = 5, throwsUnsupportedError);
    });

    test('clear removes all items', () {
      cart.add(s1, quantity: 3);
      cart.add(s2, quantity: 2);
      expect(cart.length, 2);
      expect(cart.isEmpty, isFalse);

      cart.clear();
      expect(cart.length, 0);
      expect(cart.isEmpty, isTrue);
      expect(cart.countOfItems, 0);
    });

    test('isEmpty returns correct value', () {
      expect(cart.isEmpty, isTrue);

      cart.add(s1);
      expect(cart.isEmpty, isFalse);

      cart.clear();
      expect(cart.isEmpty, isTrue);
    });

    test('length returns correct number of unique items', () {
      expect(cart.length, 0);

      cart.add(s1, quantity: 5);
      expect(cart.length, 1);

      cart.add(s2, quantity: 3);
      expect(cart.length, 2);

      cart.add(s1, quantity: 2); // same sandwich
      expect(cart.length, 2);
    });

    test('countOfItems returns total quantity across all items', () {
      expect(cart.countOfItems, 0);

      cart.add(s1, quantity: 5);
      expect(cart.countOfItems, 5);

      cart.add(s2, quantity: 3);
      expect(cart.countOfItems, 8);

      cart.add(s1, quantity: 2);
      expect(cart.countOfItems, 10);
    });

    test('getQuantity returns 0 for non-existing item', () {
      expect(cart.getQuantity(s1), 0);

      cart.add(s1, quantity: 3);
      expect(cart.getQuantity(s1), 3);
      expect(cart.getQuantity(s2), 0);
    });
  });

  group('Cart with different sandwich configurations', () {
    late Cart cart;

    setUp(() {
      cart = Cart();
    });

    test('treats sandwiches with different types as different items', () {
      final veggie = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final chicken = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.white,
      );

      cart.add(veggie, quantity: 2);
      cart.add(chicken, quantity: 3);

      expect(cart.length, 2);
      expect(cart.getQuantity(veggie), 2);
      expect(cart.getQuantity(chicken), 3);
    });

    test('treats sandwiches with different sizes as different items', () {
      final footlong = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final sixInch = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );

      cart.add(footlong, quantity: 2);
      cart.add(sixInch, quantity: 3);

      expect(cart.length, 2);
      expect(cart.getQuantity(footlong), 2);
      expect(cart.getQuantity(sixInch), 3);
    });

    test('treats sandwiches with different bread types as different items', () {
      final white = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final wheat = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.wheat,
      );

      cart.add(white, quantity: 2);
      cart.add(wheat, quantity: 3);

      expect(cart.length, 2);
      expect(cart.getQuantity(white), 2);
      expect(cart.getQuantity(wheat), 3);
    });

    test('recognizes identical sandwiches as same item', () {
      final sandwich1 = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wholemeal,
      );
      final sandwich2 = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wholemeal,
      );

      cart.add(sandwich1, quantity: 2);
      cart.add(sandwich2, quantity: 3);

      // Should be treated as the same item
      expect(cart.length, 1);
      expect(cart.countOfItems, 5);
    });
  });
}
