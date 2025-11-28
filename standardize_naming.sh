#!/bin/bash

# Script to standardize file naming across branches 5-7
# This script applies the same naming standardization done in branch 8

echo "Starting file naming standardization across branches..."

# Array of branches to update
branches=("5" "6" "7")

# Store current branch
current_branch=$(git branch --show-current)
echo "Current branch: $current_branch"

for branch in "${branches[@]}"; do
    echo "Processing branch $branch..."
    
    # Switch to the branch
    git checkout "$branch"
    
    # Check if the problematic files exist in this branch
    if [[ -f "lib/views/cart_view_screen.dart" ]]; then
        echo "  Found cart_view_screen.dart, standardizing..."
        
        # Update class name in cart_view_screen.dart
        sed -i '' 's/class CartViewScreen/class CartScreen/g' lib/views/cart_view_screen.dart
        sed -i '' 's/_CartViewScreenState/_CartScreenState/g' lib/views/cart_view_screen.dart
        sed -i '' 's/State<CartViewScreen>/State<CartScreen>/g' lib/views/cart_view_screen.dart
        sed -i '' "s/title: 'Cart View'/title: 'Cart'/g" lib/views/cart_view_screen.dart
        
        # Rename the file
        mv lib/views/cart_view_screen.dart lib/views/cart_screen.dart
        
        # Update imports in other files
        find . -name "*.dart" -type f -exec sed -i '' 's|cart_view_screen\.dart|cart_screen.dart|g' {} \;
        find . -name "*.dart" -type f -exec sed -i '' 's/CartViewScreen/CartScreen/g' {} \;
    fi
    
    if [[ -f "lib/views/order_screen_view.dart" ]]; then
        echo "  Found order_screen_view.dart, standardizing..."
        
        # Rename the file (class name OrderScreen is already correct)
        mv lib/views/order_screen_view.dart lib/views/order_screen.dart
        
        # Update imports in other files
        find . -name "*.dart" -type f -exec sed -i '' 's|order_screen_view\.dart|order_screen.dart|g' {} \;
    fi
    
    # Handle test files if they exist
    if [[ -f "test/views/cart_view_screen_test.dart" ]]; then
        echo "  Updating cart test file..."
        mv test/views/cart_view_screen_test.dart test/views/cart_screen_test.dart
        sed -i '' 's/CartViewScreen/CartScreen/g' test/views/cart_screen_test.dart
        sed -i '' "s/'Cart View'/'Cart'/g" test/views/cart_screen_test.dart
    fi
    
    if [[ -f "test/views/order_screen_view_test.dart" ]]; then
        echo "  Updating order test file..."
        mv test/views/order_screen_view_test.dart test/views/order_screen_test.dart
    fi
    
    # Commit changes if any files were modified
    if [[ -n $(git status --porcelain) ]]; then
        git add .
        git commit -m "Standardize screen file naming: cart_view_screen -> cart_screen, order_screen_view -> order_screen"
        echo "  ✓ Changes committed to branch $branch"
    else
        echo "  ℹ No changes needed in branch $branch"
    fi
done

# Return to original branch
git checkout "$current_branch"
echo "Returned to branch $current_branch"
echo "File naming standardization complete!"