// filepath: test/models/sandwich_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('BreadType enum', () {
    test('contains expected values in order', () {
      expect(BreadType.values.map((e) => e.name).toList(),
          ['white', 'wheat', 'wholemeal']);
    });
  });

  group('Sandwich.name', () {
    test('returns correct human-friendly names for all SandwichType values',
        () {
      const expected = {
        SandwichType.veggieDelight: 'Veggie Delight',
        SandwichType.chickenTeriyaki: 'Chicken Teriyaki',
        SandwichType.tunaMelt: 'Tuna Melt',
        SandwichType.meatballMarinara: 'Meatball Marinara',
      };

      expected.forEach((type, expectedName) {
        final s = Sandwich(type: type, isFootlong: true, breadType: BreadType.white);
        expect(s.name, expectedName);
      });
    });
  });

  group('Sandwich.image', () {
    test('builds footlong image path using enum name', () {
      final s = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.wheat,
      );
      expect(s.image, 'assets/images/${SandwichType.chickenTeriyaki.name}_footlong.png');
    });

    test('builds six_inch image path when isFootlong is false', () {
      final s = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );
      expect(s.image, 'assets/images/${SandwichType.veggieDelight.name}_six_inch.png');
    });
  });

  group('Sandwich properties', () {
    test('stores breadType and isFootlong correctly', () {
      final s = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wholemeal,
      );
      expect(s.breadType, BreadType.wholemeal);
      expect(s.isFootlong, isFalse);
      expect(s.type, SandwichType.tunaMelt);
    });
  });
}