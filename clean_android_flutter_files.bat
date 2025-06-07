@echo off
REM Clean Android Flutter Files Script (Windows)
REM This script removes Flutter-generated files that interfere with native Android builds

echo 🧹 Cleaning Flutter-generated files from Android project...

REM Remove Flutter plugin registrant files
if exist "android\app\src\main\java\io\flutter\plugins\GeneratedPluginRegistrant.java" (
    echo   ❌ Removing GeneratedPluginRegistrant.java
    del /f "android\app\src\main\java\io\flutter\plugins\GeneratedPluginRegistrant.java"
)

REM Remove entire Flutter directory if it exists
if exist "android\app\src\main\java\io\flutter" (
    echo   ❌ Removing Flutter directory from Android project
    rmdir /s /q "android\app\src\main\java\io\flutter"
)

REM Clean Flutter-generated plugin files in root
if exist ".flutter-plugins" (
    echo   ❌ Removing .flutter-plugins
    del /f ".flutter-plugins"
)

if exist ".flutter-plugins-dependencies" (
    echo   ❌ Removing .flutter-plugins-dependencies
    del /f ".flutter-plugins-dependencies"
)

echo ✅ Android Flutter cleanup complete!
echo.
echo 📱 You can now build the Android APK with:
echo    cd android
echo    .\gradlew assembleArm64Debug
echo    .\gradlew assembleArm64Release