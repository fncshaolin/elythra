#!/bin/bash

# Script to replace debug prints with proper logging

echo "Fixing debug prints in Dart files..."

# Find all Dart files with print statements
find /workspace/elythra/lib -name "*.dart" -exec grep -l "print\|debugPrint" {} \; | while read file; do
    echo "Processing: $file"
    
    # Check if LoggerService import already exists
    if ! grep -q "import.*logger_service.dart" "$file"; then
        # Add LoggerService import after other imports
        sed -i '/^import.*dart.*;$/a import '\''package:elythra/services/logger_service.dart'\'';' "$file"
    fi
    
    # Replace common print patterns
    sed -i 's/printINFO(\([^)]*\));/LoggerService.logger.i(\1);/g' "$file"
    sed -i 's/printERROR(\([^)]*\));/LoggerService.logger.e(\1);/g' "$file"
    sed -i 's/printWARNING(\([^)]*\));/LoggerService.logger.w(\1);/g' "$file"
    sed -i 's/print(\([^)]*\));/LoggerService.logger.d(\1);/g' "$file"
    sed -i 's/debugPrint(\([^)]*\));/LoggerService.logger.d(\1);/g' "$file"
    
    # Handle multiline print statements (basic case)
    sed -i 's/print(/LoggerService.logger.d(/g' "$file"
    sed -i 's/debugPrint(/LoggerService.logger.d(/g' "$file"
done

echo "Debug print replacement completed!"