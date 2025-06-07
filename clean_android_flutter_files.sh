#!/bin/bash

# Clean Android Flutter Files Script
# This script removes Flutter-generated files that interfere with native Android builds

echo "🧹 Cleaning Flutter-generated files from Android project..."

# Remove Flutter plugin registrant files
if [ -f "android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java" ]; then
    echo "  ❌ Removing GeneratedPluginRegistrant.java"
    rm -f "android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java"
fi

# Remove entire Flutter directory if it exists
if [ -d "android/app/src/main/java/io/flutter" ]; then
    echo "  ❌ Removing Flutter directory from Android project"
    rm -rf "android/app/src/main/java/io/flutter"
fi

# Clean Flutter-generated plugin files in root
if [ -f ".flutter-plugins" ]; then
    echo "  ❌ Removing .flutter-plugins"
    rm -f ".flutter-plugins"
fi

if [ -f ".flutter-plugins-dependencies" ]; then
    echo "  ❌ Removing .flutter-plugins-dependencies"
    rm -f ".flutter-plugins-dependencies"
fi

echo "✅ Android Flutter cleanup complete!"
echo ""
echo "📱 You can now build the Android APK with:"
echo "   cd android"
echo "   ./gradlew assembleArm64Debug"
echo "   ./gradlew assembleArm64Release"