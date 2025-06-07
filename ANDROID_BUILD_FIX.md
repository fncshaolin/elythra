# 🔧 Android Build Fix Guide

## 🚨 Problem
If you encounter build errors like:
```
error: cannot find symbol
import io.flutter.Log;
```

This happens because Flutter generates plugin files that interfere with the **native Android build**.

## ✅ Solution

### **Step 1: Clean Flutter Files (Windows)**
```powershell
# Run the cleanup script
.\clean_android_flutter_files.bat
```

### **Step 1: Clean Flutter Files (Linux/macOS)**
```bash
# Make script executable and run
chmod +x clean_android_flutter_files.sh
./clean_android_flutter_files.sh
```

### **Step 2: Manual Cleanup (if needed)**
```powershell
# Windows PowerShell
Remove-Item "android\app\src\main\java\io\flutter\" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item ".flutter-plugins" -Force -ErrorAction SilentlyContinue
Remove-Item ".flutter-plugins-dependencies" -Force -ErrorAction SilentlyContinue
```

### **Step 3: Clean and Build**
```powershell
cd android
.\gradlew clean
.\gradlew assembleArm64Debug
.\gradlew assembleArm64Release
```

## 🎯 Why This Happens

1. **Hybrid Architecture**: This project has both Flutter (desktop) and native Android code
2. **Flutter Interference**: Running `flutter pub get` in root generates Android plugin files
3. **Native Build**: The Android app is pure Kotlin, not Flutter-based
4. **Conflict**: Generated Flutter files break the native Android build

## 📱 Build Commands

### ARM64 APKs (Recommended)
```powershell
.\gradlew assembleArm64Debug    # Debug APK
.\gradlew assembleArm64Release  # Release APK
```

### Universal APKs (All architectures)
```powershell
.\gradlew assembleUniversalDebug    # Debug APK
.\gradlew assembleUniversalRelease  # Release APK
```

### All Variants
```powershell
.\gradlew assembleDebug     # All debug variants
.\gradlew assembleRelease   # All release variants
```

## 📂 APK Locations

After successful build, find APKs in:
```
android/app/build/outputs/apk/
├── arm64/
│   ├── debug/app-arm64-debug.apk
│   └── release/app-arm64-release.apk
└── universal/
    ├── debug/app-universal-debug.apk
    └── release/app-universal-release.apk
```

## 🔄 Prevention

To avoid this issue in the future:
1. **Don't run** `flutter pub get` in the root directory
2. **Only run** Flutter commands for desktop builds
3. **Use** the cleanup scripts before Android builds
4. **Build Android** from the `android/` directory only

## ✅ Success Indicators

Build successful when you see:
```
BUILD SUCCESSFUL in Xm Xs
```

And APK files are generated in the output directory.