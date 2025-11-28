import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  group('OrderScreen Widget Tests', () {
    testWidgets('Default view shows initial state correctly',
        (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const App());

      // Verify app bar title
      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Verify initial quantity is 1
      expect(find.text('1'), findsOneWidget);
      expect(find.text('Quantity: '), findsOneWidget);

      // Verify size switch labels
      expect(find.text('Six-inch'), findsOneWidget);
      expect(find.text('Footlong'), findsOneWidget);

      // Verify bread type dropdown is present
      expect(find.text('Bread Type'), findsWidgets);

      // Verify Add to Cart button
      expect(find.text('Add to Cart'), findsOneWidget);
      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);

      // Verify initial image path (footlong veggie delight)
      final Image image = tester.widget(find.byType(Image));
      final AssetImage assetImage = image.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/veggieDelight_footlong.png');
    });

    testWidgets('Increase quantity button works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to ensure button is visible
      await tester.ensureVisible(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Find the increase button (plus icon)
      final increaseButton = find.byIcon(Icons.add);

      // Initial quantity should be 1
      expect(find.text('1'), findsOneWidget);

      // Tap increase button
      await tester.tap(increaseButton);
      await tester.pump();

      // Quantity should now be 2
      expect(find.text('2'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      // Tap again
      await tester.tap(increaseButton);
      await tester.pump();

      // Quantity should now be 3
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('Decrease quantity button works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to ensure buttons are visible
      await tester.ensureVisible(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Find buttons
      final increaseButton = find.byIcon(Icons.add);
      final decreaseButton = find.byIcon(Icons.remove);

      // Increase to 3
      await tester.tap(increaseButton);
      await tester.pump();
      await tester.tap(increaseButton);
      await tester.pump();

      expect(find.text('3'), findsOneWidget);

      // Decrease once
      await tester.tap(decreaseButton);
      await tester.pump();

      expect(find.text('2'), findsOneWidget);

      // Decrease again
      await tester.tap(decreaseButton);
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Quantity cannot go below 0', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to ensure button is visible
      await tester.ensureVisible(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      final decreaseButton = find.byIcon(Icons.remove);

      // Initial quantity is 1
      expect(find.text('1'), findsOneWidget);

      // Decrease to 0
      await tester.tap(decreaseButton);
      await tester.pump();
      expect(find.text('0'), findsOneWidget);

      // Try to decrease below 0
      await tester.tap(decreaseButton);
      await tester.pump();

      // Should still be 0
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('Switch between footlong and six-inch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Find the switch
      final switchWidget = find.byType(Switch);

      // Initially should be footlong (true)
      Switch switchElement = tester.widget(switchWidget);
      expect(switchElement.value, true);

      // Verify initial image is footlong
      Image image = tester.widget(find.byType(Image));
      AssetImage assetImage = image.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/veggieDelight_footlong.png');

      // Tap switch to change to six-inch
      await tester.tap(switchWidget);
      await tester.pump();

      // Should now be six-inch (false)
      switchElement = tester.widget(switchWidget);
      expect(switchElement.value, false);

      // Verify image changed to six-inch
      image = tester.widget(find.byType(Image));
      assetImage = image.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/veggieDelight_six_inch.png');

      // Tap again to go back to footlong
      await tester.tap(switchWidget);
      await tester.pump();

      switchElement = tester.widget(switchWidget);
      expect(switchElement.value, true);

      // Verify image changed back to footlong
      image = tester.widget(find.byType(Image));
      assetImage = image.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/veggieDelight_footlong.png');
    });

/*     testWidgets('Change sandwich type updates correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Verify initial image
      Image image = tester.widget(find.byType(Image));
      AssetImage assetImage = image.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/veggieDelight_footlong.png');

      // Find sandwich type dropdown by type
      final sandwichDropdowns = find.byType(DropdownMenu<dynamic>);
      final sandwichDropdown = sandwichDropdowns.first;

      // Open sandwich type dropdown
      

      // Select Chicken Teriyaki
      await tester.tap(find.text('Veggie Delight').last);
      await tester.pumpAndSettle();

      // Verify image changed
      image = tester.widget(find.byType(Image));
      assetImage = image.image as AssetImage;
      expect(
          assetImage.assetName, 'assets/images/chickenTeriyaki_footlong.png');
    });
 */
    testWidgets('Change bread type updates correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Find bread type dropdown by key
      final breadDropdownFinder = find.byKey(const Key('breadTypeDropdown'));
      await tester.ensureVisible(breadDropdownFinder);
      await tester.pumpAndSettle();

      // Open bread type dropdown
      await tester.tap(breadDropdownFinder);
      await tester.pumpAndSettle();

      // Select wheat bread
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();

      // Verify selection successful (no error thrown)
      expect(find.byKey(const Key('breadTypeDropdown')), findsOneWidget);
    });

    testWidgets('Image updates when both sandwich type and size change',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Initial: Veggie Delight, footlong
      Image image = tester.widget(find.byType(Image));
      AssetImage assetImage = image.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/veggieDelight_footlong.png');

      // Change to six-inch
      final switchWidget = find.byType(Switch);
      await tester.tap(switchWidget);
      await tester.pump();

      // Verify: Veggie Delight, six-inch
      image = tester.widget(find.byType(Image));
      assetImage = image.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/veggieDelight_six_inch.png');

      // Change sandwich type to Tuna Melt
      final sandwichDropdown = find.byKey(const Key('sandwichTypeDropdown'));
      await tester.ensureVisible(sandwichDropdown);
      await tester.pumpAndSettle();
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tuna Melt').last);
      await tester.pumpAndSettle();

      // Verify: Tuna Melt, six-inch
      image = tester.widget(find.byType(Image));
      assetImage = image.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/tunaMelt_six_inch.png');

      // Change back to footlong
      await tester.tap(switchWidget);
      await tester.pump();

      // Verify: Tuna Melt, footlong
      image = tester.widget(find.byType(Image));
      assetImage = image.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/tunaMelt_footlong.png');
    });

    testWidgets('Add to cart shows correct confirmation message',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to ensure buttons are visible
      await tester.ensureVisible(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Set quantity to 2
      final increaseButton = find.byIcon(Icons.add);
      await tester.tap(increaseButton);
      await tester.pump();

      // Scroll to Add to Cart button
      await tester.ensureVisible(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Add to cart
      final addToCartButton = find.text('Add to Cart');
      await tester.tap(addToCartButton);
      await tester.pump();

      // Verify snackbar with correct message appears
      expect(
          find.text(
              'Added 2 footlong Veggie Delight sandwich(es) on white bread to cart'),
          findsOneWidget);
    });

    testWidgets(
        'Add to cart shows correct message for six-inch sandwich with different bread',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Change to six-inch
      final switchWidget = find.byType(Switch);
      await tester.tap(switchWidget);
      await tester.pump();

      // Change sandwich type to Meatball Marinara
      final sandwichDropdown = find.byKey(const Key('sandwichTypeDropdown'));
      await tester.ensureVisible(sandwichDropdown);
      await tester.pumpAndSettle();
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Meatball Marinara').last);
      await tester.pumpAndSettle();

      // Change bread type to wheat
      final breadDropdown = find.byKey(const Key('breadTypeDropdown'));
      await tester.ensureVisible(breadDropdown);
      await tester.pumpAndSettle();
      await tester.tap(breadDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();

      // Scroll to quantity buttons
      await tester.ensureVisible(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Set quantity to 3
      final increaseButton = find.byIcon(Icons.add);
      await tester.tap(increaseButton);
      await tester.pump();
      await tester.tap(increaseButton);
      await tester.pump();

      // Scroll to Add to Cart button
      await tester.ensureVisible(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Add to cart
      final addToCartButton = find.text('Add to Cart');
      await tester.tap(addToCartButton);
      await tester.pump();

      // Verify snackbar message
      expect(
          find.text(
              'Added 3 six-inch Meatball Marinara sandwich(es) on wheat bread to cart'),
          findsOneWidget);
    });

    testWidgets('Add to cart button disabled when quantity is 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Scroll to ensure button is visible
      await tester.ensureVisible(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      // Decrease quantity to 0
      final decreaseButton = find.byIcon(Icons.remove);
      await tester.tap(decreaseButton);
      await tester.pump();

      expect(find.text('0'), findsOneWidget);

      // Find the ElevatedButton
      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));

      // Button should be disabled (onPressed is null)
      expect(button.onPressed, isNull);
    });

    testWidgets('Multiple sandwich types available in dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Open sandwich type dropdown
      final sandwichDropdown = find.byKey(const Key('sandwichTypeDropdown'));
      await tester.ensureVisible(sandwichDropdown);
      await tester.pumpAndSettle();
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();

      // Verify all sandwich types are available
      expect(find.text('Veggie Delight'), findsWidgets);
      expect(find.text('Chicken Teriyaki'), findsWidgets);
      expect(find.text('Tuna Melt'), findsWidgets);
      expect(find.text('Meatball Marinara'), findsWidgets);
    });

    testWidgets('Multiple bread types available in dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Open bread type dropdown
      final breadDropdown = find.byKey(const Key('breadTypeDropdown'));
      await tester.ensureVisible(breadDropdown);
      await tester.pumpAndSettle();
      await tester.tap(breadDropdown);
      await tester.pumpAndSettle();

      // Verify all bread types are available
      expect(find.text('white'), findsWidgets);
      expect(find.text('wheat'), findsWidgets);
      expect(find.text('wholemeal'), findsWidgets);
    });
  });
}
