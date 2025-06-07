@echo off
REM Elythra Music - Testing Session Starter (Windows)

echo 🧪 Starting Elythra Music Testing Session
echo ==========================================

REM Create testing directory
if not exist "testing_logs" mkdir testing_logs

REM Get current timestamp for log files
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "timestamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"

echo 📱 Device Information:
adb shell getprop ro.product.model
adb shell getprop ro.build.version.release
adb shell getprop ro.build.version.sdk

echo.
echo 📦 Installing Testing APK...
adb install -r android\app\build\outputs\apk\arm64\testing\app-arm64-testing.apk

echo.
echo 🔧 Setting up logging...
adb shell setprop log.tag.ElythraTestingMode VERBOSE
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

REM Start continuous logging
adb logcat -s ElythraTestingMode:V UserAction:V Performance:V Network:V Audio:V UI:V AndroidRuntime:E System.err:E | tee testing_logs\session_%timestamp%.log