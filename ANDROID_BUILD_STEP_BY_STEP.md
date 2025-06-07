# 📱 Android Build - Complete Beginner Guide

Follow these exact steps to build your first Android APK of Elythra Music.

## 🎯 What We're Going to Build
- **Debug APK**: For testing (larger file, includes debugging info)
- **Release APK**: For distribution (smaller, optimized file)

---

## 📋 Step 1: Install Required Software

### Install Flutter SDK
1. **Download Flutter**:
   - Go to: https://flutter.dev/docs/get-started/install
   - Choose your operating system (Windows/macOS/Linux)
   - Download the Flutter SDK

2. **Extract Flutter**:
   - **Windows**: Extract to `C:\flutter`
   - **macOS/Linux**: Extract to `/Users/[username]/flutter` or `/home/[username]/flutter`

3. **Add Flutter to PATH**:
   - **Windows**: Add `C:\flutter\bin` to your PATH environment variable
   - **macOS/Linux**: Add this line to your `.bashrc` or `.zshrc`:
     ```bash
     export PATH="$PATH:/path/to/flutter/bin"
     ```

### Install Android Studio
1. **Download Android Studio**:
   - Go to: https://developer.android.com/studio
   - Download and install Android Studio

2. **Install Android SDK**:
   - Open Android Studio
   - Go to: Tools → SDK Manager
   - Install Android SDK (API levels 21-34)
   - Install Android SDK Build-Tools
   - Install Android SDK Platform-Tools

3. **Accept Licenses**:
   - This is important! We'll do this in the terminal later.

---

## 🚀 Step 2: Verify Installation

Open your terminal/command prompt and run these commands one by one:

### Check Flutter Installation
```bash
flutter --version
```
**Expected output**: Should show Flutter version (like "Flutter 3.x.x")

### Check Flutter Doctor
```bash
flutter doctor
```
**Expected output**: Should show checkmarks ✓ for most items. Some X marks are okay for now.

### Accept Android Licenses
```bash
flutter doctor --android-licenses
```
**What to do**: Type `y` and press Enter for each license prompt (there will be several)

### Final Check
```bash
flutter doctor
```
**Expected output**: Should now show ✓ for Android toolchain

---

## 📁 Step 3: Navigate to Project

### Clone the Repository (if you haven't already)
```bash
git clone https://github.com/fncshaolin/elythra.git
cd elythra
```

### Or Navigate to Existing Project
```bash
cd /path/to/your/elythra/folder
```

### Verify You're in the Right Place
```bash
ls
```
**Expected output**: Should see files like `pubspec.yaml`, `android/`, `lib/`, etc.

---

## 📦 Step 4: Install Dependencies

### Get Flutter Dependencies
```bash
flutter pub get
```
**What this does**: Downloads all the packages your app needs
**Expected output**: Should end with "Got dependencies!"

### Check for Issues
```bash
flutter analyze
```
**What this does**: Checks your code for potential problems
**Expected output**: Should show "No issues found!" or list any problems

---

## 🔧 Step 5: Build Debug APK (For Testing)

### Clean Previous Builds (Recommended)
```bash
flutter clean
```
**What this does**: Removes old build files to ensure a fresh build

### Get Dependencies Again
```bash
flutter pub get
```
**What this does**: Ensures all dependencies are properly installed

### Build Debug APK
```bash
flutter build apk --debug
```
**What this does**: Creates a debug version of your app
**Time**: Takes 3-8 minutes on first build (this project has native Android components)
**Expected output**: Should end with "Built build/app/outputs/flutter-apk/app-debug.apk"

### If Build Fails, Try Alternative Method
```bash
flutter build apk --debug --no-shrink
```
**What this does**: Builds without code shrinking (sometimes fixes build issues)

### Find Your Debug APK
```bash
ls -la build/app/outputs/flutter-apk/
```
**Expected output**: Should show `app-debug.apk` file

### Check APK Size
```bash
ls -lh build/app/outputs/flutter-apk/app-debug.apk
```
**Expected output**: Should show file size (typically 50-100MB for debug)

---

## 🚀 Step 6: Build Release APK (For Distribution)

### Build Release APK
```bash
flutter build apk --release
```
**What this does**: Creates an optimized version for distribution
**Time**: Takes 3-7 minutes
**Expected output**: Should end with "Built build/app/outputs/flutter-apk/app-release.apk"

### Find Your Release APK
```bash
ls -la build/app/outputs/flutter-apk/
```
**Expected output**: Should show both `app-debug.apk` and `app-release.apk`

### Check Release APK Size
```bash
ls -lh build/app/outputs/flutter-apk/app-release.apk
```
**Expected output**: Should show smaller size than debug (typically 20-40MB)

---

## 📱 Step 7: Test Your APK

### Option A: Install on Connected Android Device

1. **Enable Developer Options** on your Android device:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
   - Go back to Settings → Developer Options
   - Enable "USB Debugging"

2. **Connect Device** via USB cable

3. **Check Device Connection**:
   ```bash
   flutter devices
   ```
   **Expected output**: Should show your connected Android device

4. **Install Debug APK**:
   ```bash
   flutter install
   ```
   **What this does**: Installs the debug version on your connected device

### Option B: Share APK File

1. **Copy APK to Safe Location**:
   ```bash
   cp build/app/outputs/flutter-apk/app-release.apk ~/Desktop/elythra-music.apk
   ```

2. **Share the APK**:
   - The APK file is now on your Desktop
   - You can share it via email, cloud storage, etc.
   - Others can install it by enabling "Install from Unknown Sources"

---

## 🎯 Step 8: Build Variations (Optional)

### Build APK for Specific Architecture (Smaller Size)
```bash
flutter build apk --release --split-per-abi
```
**What this does**: Creates separate APKs for different phone types
**Output**: Creates multiple APK files in the same folder

### Build Android App Bundle (For Play Store)
```bash
flutter build appbundle --release
```
**What this does**: Creates an AAB file for Google Play Store
**Output**: Creates `build/app/outputs/bundle/release/app-release.aab`

---

## 🐛 Troubleshooting Common Issues

### Issue: "Flutter not found"
**Solution**: Make sure Flutter is in your PATH. Restart terminal after adding to PATH.

### Issue: "Android licenses not accepted"
**Solution**: Run `flutter doctor --android-licenses` and accept all licenses.

### Issue: "No connected devices"
**Solution**: 
- Enable USB Debugging on your Android device
- Use a data cable (not charge-only cable)
- Install device drivers if on Windows

### Issue: "Build failed"
**Solution**: 
1. Clean the project: `flutter clean`
2. Get dependencies: `flutter pub get`
3. Try building again

### Issue: "Gradle build failed"
**Solution**:
1. Check internet connection (this project downloads many dependencies)
2. Wait and try again (Gradle downloads dependencies)
3. Clear Gradle cache: `cd android && ./gradlew clean`
4. If still failing, try: `flutter build apk --debug --no-shrink`

### Issue: "Out of memory during build"
**Solution**:
1. Close other applications
2. Try building with: `flutter build apk --debug --dart-define=flutter.inspector.structuredErrors=false`
3. Increase system RAM if possible

### Issue: "Native Android build errors"
**Solution**:
This project has native Android components. If you see errors related to:
- Kotlin compilation
- Hilt/Dagger
- Native libraries
Try:
1. `cd android && ./gradlew clean`
2. `cd .. && flutter clean && flutter pub get`
3. Build again

### Issue: "Very long build time (>10 minutes)"
**This is normal** for this project on first build because:
- It has native Android modules (innertube, kizzy, kugou, lrclib)
- Many dependencies need to be downloaded
- Kotlin compilation takes time
- Subsequent builds will be much faster

---

## ✅ Success Checklist

After following all steps, you should have:
- [ ] Flutter installed and working (`flutter doctor` shows ✓)
- [ ] Android licenses accepted
- [ ] Project dependencies installed (`flutter pub get` completed)
- [ ] Debug APK built successfully (`app-debug.apk` exists)
- [ ] Release APK built successfully (`app-release.apk` exists)
- [ ] APK tested on device or ready for sharing

---

## 📍 File Locations Summary

After successful build, your files will be at:
- **Debug APK**: `build/app/outputs/flutter-apk/app-debug.apk`
- **Release APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **App Bundle**: `build/app/outputs/bundle/release/app-release.aab`
- **Split APKs**: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (and others)

---

## 🎉 Next Steps

Once you have your APK:
1. **Test thoroughly** using the TESTING_CHECKLIST.md
2. **Share with beta testers** for feedback
3. **Report any bugs** you find
4. **Prepare for Play Store** submission (if desired)

**Ready to start? Let's begin with Step 1! 🚀**