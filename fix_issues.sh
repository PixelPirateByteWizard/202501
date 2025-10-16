#!/bin/bash

# Fix withOpacity issues
find lib -name "*.dart" -exec sed -i 's/\.withOpacity(\([^)]*\))/\.withValues(alpha: \1)/g' {} \;

# Fix opacity parameter issues
find lib -name "*.dart" -exec sed -i 's/opacity: \([0-9.]*\),/color: AppColors.lavenderWhite.withValues(alpha: \1),/g' {} \;

# Fix BorderStyle.dashed
find lib -name "*.dart" -exec sed -i 's/BorderStyle\.dashed/BorderStyle.solid/g' {} \;

# Fix tower_outlined icon
find lib -name "*.dart" -exec sed -i 's/Icons\.tower_outlined/Icons.tower/g' {} \;

echo "Fixed common issues"