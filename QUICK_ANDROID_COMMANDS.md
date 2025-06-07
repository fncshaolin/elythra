# 📱 Quick Android Build Commands

**Copy and paste these commands one by one in your terminal:**

## 🚀 Essential Commands (Run These First)

```bash
# 1. Check Flutter installation
flutter --version

# 2. Check Flutter doctor
flutter doctor

# 3. Accept Android licenses (type 'y' for each prompt)
flutter doctor --android-licenses

# 4. Navigate to project (adjust path as needed)
cd /path/to/elythra

# 5. Clean previous builds
flutter clean

# 6. Get dependencies
flutter pub get
```

## 📱 Build Commands

```bash
# Build Debug APK (for testing)
flutter build apk --debug

# Build Release APK (for sharing)
flutter build apk --release

# Build with no shrinking (if normal build fails)
flutter build apk --debug --no-shrink
```

## 📁 Find Your APK Files

```bash
# List all APK files
ls -la build/app/outputs/flutter-apk/

# Check file sizes
ls -lh build/app/outputs/flutter-apk/*.apk
```

## 📱 Install on Device

```bash
# Check connected devices
flutter devices

# Install debug version on connected device
flutter install

# Run app directly on device
flutter run
```

## 🧹 Troubleshooting Commands

```bash
# Clean everything and start fresh
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..

# Check for issues
flutter analyze

# Verbose build (shows more details if build fails)
flutter build apk --debug --verbose
```

## 📍 File Locations

After successful build, your APK files will be at:
- **Debug APK**: `build/app/outputs/flutter-apk/app-debug.apk`
- **Release APK**: `build/app/outputs/flutter-apk/app-release.apk`

## ⚡ Quick Build Script

Save this as `build_android.sh` and run with `bash build_android.sh`:

```bash
#!/bin/bash
echo "🚀 Building Elythra Music for Android..."
flutter clean
flutter pub get
flutter build apk --release
echo "✅ Build complete! APK location:"
ls -lh build/app/outputs/flutter-apk/app-release.apk
```

## 🎯 Expected Build Time

- **First build**: 5-15 minutes (downloads dependencies)
- **Subsequent builds**: 2-5 minutes
- **Clean builds**: 3-8 minutes

**Note**: This project has native Android components, so builds take longer than typical Flutter apps.