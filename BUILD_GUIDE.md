# 🚀 Elythra Music - Complete Build Guide

This guide will help you build Elythra Music for all supported platforms. Follow the instructions for your target platform(s).

## 📋 Prerequisites

### Required Tools
1. **Flutter SDK** (latest stable)
2. **Git** (for version control)
3. **Platform-specific tools** (see each section)

### Initial Setup
```bash
# Clone the repository
git clone https://github.com/fncshaolin/elythra.git
cd elythra

# Get Flutter dependencies
flutter pub get

# Verify Flutter installation
flutter doctor
```

---

## 📱 Android Build

### Prerequisites
- **Android Studio** or **Android SDK Command Line Tools**
- **Java JDK 11** or higher
- **Android SDK** (API level 21-36)

### Setup Android Environment
```bash
# Check Android setup
flutter doctor --android-licenses

# Accept all licenses
flutter doctor --android-licenses
```

### Build Commands

#### Debug Build (for testing)
```bash
# APK for testing
flutter build apk --debug

# Install on connected device
flutter install
```

#### Release Build (for distribution)
```bash
# Release APK
flutter build apk --release

# Android App Bundle (recommended for Play Store)
flutter build appbundle --release

# Split APKs by architecture (smaller downloads)
flutter build apk --release --split-per-abi
```

### Output Locations
- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **AAB**: `build/app/outputs/bundle/release/app-release.aab`
- **Split APKs**: `build/app/outputs/flutter-apk/`

### Testing
```bash
# Run on connected Android device
flutter run

# Run with specific device
flutter devices
flutter run -d <device-id>
```

---

## 🍎 iOS Build

### Prerequisites
- **macOS** (required for iOS builds)
- **Xcode** (latest version)
- **iOS Developer Account** (for device testing/App Store)
- **CocoaPods** (`sudo gem install cocoapods`)

### Setup iOS Environment
```bash
# Install CocoaPods dependencies
cd ios
pod install
cd ..

# Check iOS setup
flutter doctor
```

### Build Commands

#### Debug Build
```bash
# Build for iOS Simulator
flutter build ios --debug --simulator

# Build for iOS Device (requires signing)
flutter build ios --debug
```

#### Release Build
```bash
# Release build for App Store
flutter build ios --release

# Build IPA for distribution
flutter build ipa --release
```

### Xcode Configuration
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your development team
3. Configure signing certificates
4. Set deployment target (iOS 12.0+)

### Output Locations
- **iOS App**: `build/ios/iphoneos/Runner.app`
- **IPA**: `build/ios/ipa/elythra.ipa`

### Testing
```bash
# Run on iOS Simulator
flutter run

# Run on connected iOS device
flutter run -d <ios-device-id>
```

---

## 🖥️ Desktop Builds

### Windows Build

#### Prerequisites
- **Windows 10/11**
- **Visual Studio 2022** (with C++ tools)
- **Flutter Windows Desktop** enabled

#### Setup
```bash
# Enable Windows desktop
flutter config --enable-windows-desktop

# Check Windows setup
flutter doctor
```

#### Build Commands
```bash
# Debug build
flutter build windows --debug

# Release build
flutter build windows --release
```

#### Output Location
- **Executable**: `build/windows/x64/runner/Release/elythra.exe`
- **Full Package**: `build/windows/x64/runner/Release/` (entire folder)

### macOS Build

#### Prerequisites
- **macOS** (10.14+)
- **Xcode** (latest version)
- **Flutter macOS Desktop** enabled

#### Setup
```bash
# Enable macOS desktop
flutter config --enable-macos-desktop

# Install CocoaPods dependencies
cd macos
pod install
cd ..
```

#### Build Commands
```bash
# Debug build
flutter build macos --debug

# Release build
flutter build macos --release
```

#### Output Location
- **App Bundle**: `build/macos/Build/Products/Release/elythra.app`

### Linux Build

#### Prerequisites
- **Linux** (Ubuntu 18.04+ recommended)
- **Required packages**:
```bash
sudo apt-get update
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
```

#### Setup
```bash
# Enable Linux desktop
flutter config --enable-linux-desktop

# Check Linux setup
flutter doctor
```

#### Build Commands
```bash
# Debug build
flutter build linux --debug

# Release build
flutter build linux --release
```

#### Output Location
- **Executable**: `build/linux/x64/release/bundle/elythra`
- **Full Package**: `build/linux/x64/release/bundle/` (entire folder)

---

## 🌐 Web Build

### Prerequisites
- **Flutter Web** enabled
- **Modern web browser**

### Setup
```bash
# Enable web support
flutter config --enable-web

# Check web setup
flutter doctor
```

### Build Commands
```bash
# Debug build
flutter build web --debug

# Release build
flutter build web --release

# Build with specific renderer
flutter build web --release --web-renderer canvaskit
flutter build web --release --web-renderer html
```

### Output Location
- **Web Files**: `build/web/`

### Testing
```bash
# Run web version locally
flutter run -d chrome

# Serve built web files
cd build/web
python -m http.server 8000
# Open http://localhost:8000
```

---

## 📦 Package Distribution

### Android
- **Play Store**: Upload AAB file
- **Direct Distribution**: Share APK file
- **F-Droid**: Submit for open-source distribution

### iOS
- **App Store**: Upload IPA via Xcode or Transporter
- **TestFlight**: Beta testing distribution
- **Enterprise**: Ad-hoc distribution

### Windows
- **Microsoft Store**: Package as MSIX
- **Direct Distribution**: Share executable folder
- **Installer**: Create with tools like Inno Setup

### macOS
- **Mac App Store**: Submit via Xcode
- **Direct Distribution**: Share .app bundle
- **DMG**: Create disk image for distribution

### Linux
- **Snap Store**: Package as snap
- **AppImage**: Create portable application
- **DEB/RPM**: Use packaging configs in `linux/packaging/`

### Web
- **Web Hosting**: Deploy `build/web/` to any web server
- **GitHub Pages**: Host static web version
- **CDN**: Deploy for global distribution

---

## 🧪 Testing Checklist

### Functionality Testing
- [ ] Audio playback works correctly
- [ ] Search functionality operates
- [ ] Download features function
- [ ] UI responds properly
- [ ] Settings save correctly
- [ ] Performance is acceptable

### Platform-Specific Testing
- [ ] **Android**: Test on different screen sizes and Android versions
- [ ] **iOS**: Test on iPhone and iPad, different iOS versions
- [ ] **Windows**: Test on different Windows versions
- [ ] **macOS**: Test on different macOS versions
- [ ] **Linux**: Test on different distributions
- [ ] **Web**: Test on different browsers

### Performance Testing
- [ ] App startup time
- [ ] Memory usage
- [ ] Battery consumption (mobile)
- [ ] Network usage
- [ ] Storage usage

---

## 🐛 Common Issues & Solutions

### Build Issues
1. **Dependency conflicts**: Run `flutter clean && flutter pub get`
2. **Platform tools missing**: Run `flutter doctor` and follow suggestions
3. **Signing issues (iOS)**: Check Xcode signing configuration
4. **Android license issues**: Run `flutter doctor --android-licenses`

### Runtime Issues
1. **Performance problems**: Check for debug mode vs release mode
2. **Network issues**: Verify internet permissions
3. **Storage issues**: Check file system permissions
4. **Audio issues**: Verify audio service configuration

---

## 📞 Support

If you encounter issues:
1. Check the [Flutter documentation](https://flutter.dev/docs)
2. Review platform-specific guides
3. Check the repository issues
4. Create a new issue with detailed error information

---

## 🎯 Next Steps

After building:
1. **Test thoroughly** on target devices
2. **Gather user feedback** from beta testing
3. **Optimize performance** based on testing results
4. **Prepare for distribution** on respective app stores
5. **Plan updates** and maintenance schedule

Happy building! 🚀