@echo off
REM Build Testing APK with Enhanced Logging

echo 🔨 Building Elythra Music Testing APK
echo =====================================

echo 🧹 Cleaning Flutter interference...
call clean_android_flutter_files.bat

echo.
echo 📱 Building Verbose Debug APK...
cd android
call gradlew clean
call gradlew assembleArm64Verbose

echo.
if exist "app\build\outputs\apk\arm64\verbose\app-arm64-verbose.apk" (
    echo ✅ Verbose APK built successfully!
    echo 📂 Location: android\app\build\outputs\apk\arm64\verbose\app-arm64-verbose.apk
) else (
    echo ❌ Build failed! APK not found.
    echo 🔍 Check the build output above for errors.
    pause
    exit /b 1
)
echo.
echo 🚀 Next steps:
echo 1. Run: testing_scripts\start_testing_session.bat
echo 2. Test the app thoroughly
echo 3. Share the generated logs

cd ..