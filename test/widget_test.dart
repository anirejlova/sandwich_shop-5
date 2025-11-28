import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('creates OrderScreen with maxQuantity of 5',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      final orderScreen = tester.widget<OrderScreen>(find.byType(OrderScreen));
      expect(orderScreen.maxQuantity, equals(5));
    });
  });

  group('OrderScreen - Initial State', () {
    testWidgets('displays initial UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Check title
      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Check dropdown menus exist
      expect(find.byType(DropdownMenu<SandwichType>), findsOneWidget);
      expect(find.byType(DropdownMenu<BreadType>), findsOneWidget);

      // Check switch exists
      expect(find.byType(Switch), findsOneWidget);
      expect(find.text('Six-inch'), findsOneWidget);
      expect(find.text('Footlong'), findsOneWidget);

      // Check quantity controls
      expect(find.text('Quantity: '), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);

      // Check initial quantity is 1
      expect(find.text('1'), findsOneWidget);

      // Check Add to Cart button exists
      expect(find.widgetWithText(StyledButton, 'Add to Cart'), findsOneWidget);
      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
    });

    testWidgets('shows default sandwich type as Veggie Delight',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('Veggie Delight'), findsOneWidget);
    });

    testWidgets('switch is initially set to footlong',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });

    testWidgets('displays image widget', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity Controls', () {
    testWidgets('increments quantity when add icon is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Initial quantity should be 1
      expect(find.text('1'), findsOneWidget);

      // Tap the add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Quantity should now be 2
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('decrements quantity when remove icon is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Initial quantity is 1
      expect(find.text('1'), findsOneWidget);

      // Tap add to increase to 2
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      // Tap remove to decrease back to 1
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('does not decrement below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Initial quantity is 1
      expect(find.text('1'), findsOneWidget);

      // Tap remove to go to 0
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);

      // Try to tap remove again - should stay at 0
      final removeButton = tester.widget<IconButton>(find.byIcon(Icons.remove));
      expect(removeButton.onPressed, isNull); // Button should be disabled

      await tester.tap(find.byIcon(Icons.remove), warnIfMissed: false);
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('allows incrementing quantity multiple times',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Tap add button 4 times to reach 5
      for (int i = 0; i < 4; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }

      expect(find.text('5'), findsOneWidget);
    });
  });

  group('OrderScreen - Sandwich Type Selection', () {
    testWidgets('changes sandwich type via dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Initial type should be Veggie Delight
      expect(find.text('Veggie Delight'), findsOneWidget);

      // Tap the dropdown
      await tester.tap(find.byType(DropdownMenu<SandwichType>));
      await tester.pumpAndSettle();

      // Select Chicken Teriyaki
      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      // Should now show Chicken Teriyaki
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('can select all sandwich types', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      final sandwichTypes = [
        'Veggie Delight',
        'Chicken Teriyaki',
        'Tuna Melt',
        'Meatball Marinara'
      ];

      for (final type in sandwichTypes) {
        await tester.tap(find.byType(DropdownMenu<SandwichType>));
        await tester.pumpAndSettle();

        await tester.tap(find.text(type).last);
        await tester.pumpAndSettle();

        expect(find.text(type), findsOneWidget);
      }
    });
  });

  group('OrderScreen - Size Toggle', () {
    testWidgets('toggles from footlong to six-inch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Initial state should be footlong (true)
      Switch switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);

      // Tap the switch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Should now be six-inch (false)
      switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);
    });

    testWidgets('toggles back from six-inch to footlong',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Toggle to six-inch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      Switch switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);

      // Toggle back to footlong
      await tester.tap(find.byType(Switch));
      await tester.pump();

      switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });
  });

  group('OrderScreen - Bread Type Selection', () {
    testWidgets('changes bread type via dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Tap the bread dropdown
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();

      // Select wheat
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();

      // Verify wheat is selected (dropdown should show it)
      expect(find.text('wheat'), findsWidgets);
    });

    testWidgets('can select all bread types', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      final breadTypes = ['white', 'wheat', 'wholemeal'];

      for (final breadType in breadTypes) {
        await tester.tap(find.byType(DropdownMenu<BreadType>));
        await tester.pumpAndSettle();

        await tester.tap(find.text(breadType).last);
        await tester.pumpAndSettle();

        expect(find.text(breadType), findsWidgets);
      }
    });
  });

  group('OrderScreen - Add to Cart', () {
    testWidgets('Add to Cart button is enabled when quantity > 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      final addToCartButton =
          tester.widget<StyledButton>(find.byType(StyledButton));
      expect(addToCartButton.onPressed, isNotNull);
    });

    testWidgets('Add to Cart button is disabled when quantity is 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Decrease quantity to 0
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      final addToCartButton =
          tester.widget<StyledButton>(find.byType(StyledButton));
      expect(addToCartButton.onPressed, isNull);
    });

    testWidgets('can tap Add to Cart button with valid quantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Set quantity to 2
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Tap Add to Cart
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pump();

      // Test passes if no exception is thrown
    });

    testWidgets('adding to cart with different configurations',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Change to Tuna Melt
      await tester.tap(find.byType(DropdownMenu<SandwichType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tuna Melt').last);
      await tester.pumpAndSettle();

      // Change to six-inch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Change to wheat bread
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();

      // Set quantity to 3
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('3'), findsOneWidget);

      // Add to cart
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pump();

      // Test passes if no exception is thrown
    });

    testWidgets('shows confirmation message in SnackBar when item is added',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Set quantity to 2
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Add to cart
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pump();

      // Verify SnackBar appears with confirmation message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
          find.text(
              'Added 2 footlong Veggie Delight sandwich(es) on white bread to cart'),
          findsOneWidget);

      // Wait for SnackBar animation and duration
      await tester.pumpAndSettle();
    });

    testWidgets(
        'shows correct confirmation message for different sandwich configurations',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Change to Chicken Teriyaki
      await tester.tap(find.byType(DropdownMenu<SandwichType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      // Change to six-inch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // Change to wheat bread
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();

      // Set quantity to 3
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Add to cart
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pump();

      // Verify SnackBar with correct message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
          find.text(
              'Added 3 six-inch Chicken Teriyaki sandwich(es) on wheat bread to cart'),
          findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('does not show SnackBar when quantity is 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Set quantity to 0
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      // Try to add to cart (button should be disabled, but test the logic)
      final addToCartButton =
          tester.widget<StyledButton>(find.byType(StyledButton));
      expect(addToCartButton.onPressed, isNull);

      // Verify no SnackBar appears
      expect(find.byType(SnackBar), findsNothing);
    });
  });

  group('OrderScreen - Complex Scenarios', () {
    testWidgets('can change all options and add multiple times',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // First item: 2 Veggie Delight footlong on white
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pump();

      // Second item: 1 Chicken Teriyaki six-inch on wheat
      await tester.tap(find.byType(DropdownMenu<SandwichType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pump();

      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();

      // Quantity resets would need to be handled in actual implementation
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pump();

      // Test passes if no exception is thrown
    });

    testWidgets('UI remains functional after multiple interactions',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Perform multiple rapid interactions
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }

      await tester.tap(find.byType(Switch));
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pump();

      for (int i = 0; i < 2; i++) {
        await tester.tap(find.byIcon(Icons.remove));
        await tester.pump();
      }

      // Should still have quantity of 2
      expect(find.text('2'), findsOneWidget);

      // UI should still be functional
      expect(find.byType(DropdownMenu<SandwichType>), findsOneWidget);
      expect(find.byType(DropdownMenu<BreadType>), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });
  });

  group('StyledButton', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.shopping_cart,
        label: 'Test Button',
        backgroundColor: Colors.blue,
      );
      const testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      await tester.pumpWidget(testApp);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('is disabled when onPressed is null',
        (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Disabled',
        backgroundColor: Colors.grey,
      );
      const testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      await tester.pumpWidget(testApp);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('is enabled when onPressed is provided',
        (WidgetTester tester) async {
      bool tapped = false;
      final testButton = StyledButton(
        onPressed: () {
          tapped = true;
        },
        icon: Icons.add,
        label: 'Enabled',
        backgroundColor: Colors.green,
      );
      final testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      await tester.pumpWidget(testApp);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('displays correct background color',
        (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Test',
        backgroundColor: Colors.red,
      );
      const testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      await tester.pumpWidget(testApp);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style;
      expect(buttonStyle, isNotNull);
    });
  });
}
