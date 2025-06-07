@echo off
REM Elythra Music - Testing Session Starter (Windows)

echo 🧪 Starting Elythra Music Testing Session
echo ==========================================

REM Create testing directory
if not exist "testing_logs" mkdir testing_logs

REM Get current timestamp for log files (PowerShell method for Windows 10+)
for /f "usebackq delims=" %%i in (`powershell -command "Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'"`) do set "timestamp=%%i"

echo 📱 Device Information:
adb shell getprop ro.product.model
adb shell getprop ro.build.version.release
adb shell getprop ro.build.version.sdk

echo.
echo 📦 Installing Verbose APK...
if exist "android\app\build\outputs\apk\arm64\verbose\app-arm64-verbose.apk" (
    adb install -r android\app\build\outputs\apk\arm64\verbose\app-arm64-verbose.apk
    echo ✅ APK installed successfully!
) else (
    echo ❌ APK not found! Please build it first with: .\testing_scripts\build_testing_apk.bat
    pause
    exit /b 1
)

echo.
echo 🔧 Setting up logging...
adb shell setprop log.tag.ElythraVerboseMode VERBOSE
adb shell setprop log.tag.UserAction VERBOSE
adb shell setprop log.tag.Performance VERBOSE
adb shell setprop log.tag.Network VERBOSE
adb shell setprop log.tag.Audio VERBOSE
adb shell setprop log.tag.UI VERBOSE

echo.
echo 📊 Starting log capture...
echo Starting Elythra Testing Session - %timestamp% > testing_logs\session_%timestamp%.log
echo Device: >> testing_logs\session_%timestamp%.log
adb shell getprop ro.product.model >> testing_logs\session_%timestamp%.log
echo Android Version: >> testing_logs\session_%timestamp%.log
adb shell getprop ro.build.version.release >> testing_logs\session_%timestamp%.log
echo ================================== >> testing_logs\session_%timestamp%.log

echo.
echo 🚀 Ready to test! 
echo.
echo 📋 Instructions:
echo 1. Use the app normally
echo 2. Try all features systematically
echo 3. Note any issues you encounter
echo 4. Press Ctrl+C when done testing
echo.
echo 📊 Logs will be saved to: testing_logs\session_%timestamp%.log
echo.

REM Start continuous logging (Windows compatible)
echo Starting logcat capture...
adb logcat -s ElythraVerboseMode:V UserAction:V Performance:V Network:V Audio:V UI:V AndroidRuntime:E System.err:E > testing_logs\session_%timestamp%.log