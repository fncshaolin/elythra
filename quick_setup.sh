#!/bin/bash

# Elythra Music - Quick Setup Script
echo "🚀 Elythra Music - Quick Setup"
echo "================================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed!"
    echo ""
    echo "Please install Flutter first:"
    echo "1. Visit: https://flutter.dev/docs/get-started/install"
    echo "2. Download Flutter SDK for your platform"
    echo "3. Add Flutter to your PATH"
    echo "4. Run 'flutter doctor' to verify installation"
    echo ""
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n1)"
echo ""

# Check Flutter doctor
echo "🔍 Running Flutter Doctor..."
flutter doctor

echo ""
echo "📦 Getting dependencies..."
flutter pub get

echo ""
echo "🎯 Available build commands:"
echo ""
echo "📱 Android:"
echo "  flutter build apk --debug          # Debug APK"
echo "  flutter build apk --release        # Release APK"
echo "  flutter build appbundle --release  # Play Store AAB"
echo ""
echo "🍎 iOS (macOS only):"
echo "  flutter build ios --debug          # Debug build"
echo "  flutter build ios --release        # Release build"
echo "  flutter build ipa --release        # IPA for distribution"
echo ""
echo "🖥️ Desktop:"
echo "  flutter build windows --release    # Windows executable"
echo "  flutter build macos --release      # macOS app (macOS only)"
echo "  flutter build linux --release      # Linux executable"
echo ""
echo "🌐 Web:"
echo "  flutter build web --release        # Web build"
echo ""
echo "🧪 Testing:"
echo "  flutter run                        # Run on connected device"
echo "  flutter run -d chrome              # Run web version"
echo ""
echo "✨ Setup complete! Choose your platform and start building!"