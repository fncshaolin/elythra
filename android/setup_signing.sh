#!/bin/bash

# Elythra APK Signing Setup Script
# This script helps create a keystore for signing release APKs

echo "🔐 Elythra APK Signing Setup"
echo "=========================="
echo ""

# Check if keystore directory exists
if [ ! -d "app/keystore" ]; then
    echo "📁 Creating keystore directory..."
    mkdir -p app/keystore
fi

# Check if keystore already exists
if [ -f "app/keystore/release.keystore" ]; then
    echo "⚠️  Keystore already exists at app/keystore/release.keystore"
    echo "   Delete it first if you want to create a new one."
    exit 1
fi

echo "🔑 Creating new release keystore..."
echo ""
echo "You'll be prompted for:"
echo "- Keystore password (remember this!)"
echo "- Key alias (e.g., 'elythra-release')"
echo "- Key password (can be same as keystore password)"
echo "- Your name/organization details"
echo ""

# Generate keystore
keytool -genkey -v -keystore app/keystore/release.keystore -alias elythra-release -keyalg RSA -keysize 2048 -validity 10000

echo ""
echo "✅ Keystore created successfully!"
echo ""
echo "📝 Next steps:"
echo "1. Set environment variables before building:"
echo "   export STORE_PASSWORD='your_keystore_password'"
echo "   export KEY_ALIAS='elythra-release'"
echo "   export KEY_PASSWORD='your_key_password'"
echo ""
echo "2. Build signed release APK:"
echo "   ./gradlew assembleArm64Release"
echo ""
echo "3. Your signed APK will be at:"
echo "   app/build/outputs/apk/arm64/release/app-arm64-release.apk"
echo ""
echo "🛡️ Signed APKs have much lower false positive rates on VirusTotal!"