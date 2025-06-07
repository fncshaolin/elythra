@echo off
REM Build Testing APK with Enhanced Logging

echo 🔨 Building Elythra Music Testing APK
echo =====================================

echo 🧹 Cleaning Flutter interference...
call clean_android_flutter_files.bat

echo.
echo 📱 Building Testing APK...
cd android
call gradlew clean
call gradlew assembleArm64Testing

echo.
echo ✅ Testing APK built successfully!
echo 📂 Location: android\app\build\outputs\apk\arm64\testing\app-arm64-testing.apk
echo.
echo 🚀 Next steps:
echo 1. Run: testing_scripts\start_testing_session.bat
echo 2. Test the app thoroughly
echo 3. Share the generated logs

cd ..