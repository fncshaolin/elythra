# Elythra Music - Testing Session Starter (PowerShell)

Write-Host "🧪 Starting Elythra Music Testing Session" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Create testing directory
if (!(Test-Path "testing_logs")) {
    New-Item -ItemType Directory -Path "testing_logs" | Out-Null
}

# Get current timestamp for log files
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

Write-Host "📱 Device Information:" -ForegroundColor Yellow
$deviceModel = & adb shell getprop ro.product.model
$androidVersion = & adb shell getprop ro.build.version.release
$sdkVersion = & adb shell getprop ro.build.version.sdk

Write-Host "Device: $deviceModel" -ForegroundColor White
Write-Host "Android: $androidVersion (API $sdkVersion)" -ForegroundColor White

Write-Host ""
Write-Host "📦 Installing Verbose APK..." -ForegroundColor Yellow
$apkPath = "android\app\build\outputs\apk\arm64\verbose\app-arm64-verbose.apk"
if (Test-Path $apkPath) {
    & adb install -r $apkPath
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ APK installed successfully!" -ForegroundColor Green
    } else {
        Write-Host "❌ APK installation failed!" -ForegroundColor Red
        Read-Host "Press Enter to continue"
        exit 1
    }
} else {
    Write-Host "❌ APK not found! Please build it first with: .\testing_scripts\build_testing_apk.ps1" -ForegroundColor Red
    Read-Host "Press Enter to continue"
    exit 1
}

Write-Host ""
Write-Host "🔧 Setting up logging..." -ForegroundColor Yellow
& adb shell setprop log.tag.ElythraVerboseMode VERBOSE
& adb shell setprop log.tag.UserAction VERBOSE
& adb shell setprop log.tag.Performance VERBOSE
& adb shell setprop log.tag.Network VERBOSE
& adb shell setprop log.tag.Audio VERBOSE
& adb shell setprop log.tag.UI VERBOSE

Write-Host ""
Write-Host "📊 Starting log capture..." -ForegroundColor Yellow
$logFile = "testing_logs\session_$timestamp.log"

# Write session header
@"
Starting Elythra Testing Session - $timestamp
Device: $deviceModel
Android Version: $androidVersion (API $sdkVersion)
==================================
"@ | Out-File -FilePath $logFile -Encoding UTF8

Write-Host ""
Write-Host "🚀 Ready to test!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Instructions:" -ForegroundColor Cyan
Write-Host "1. Use the app normally" -ForegroundColor White
Write-Host "2. Try all features systematically" -ForegroundColor White
Write-Host "3. Note any issues you encounter" -ForegroundColor White
Write-Host "4. Press Ctrl+C when done testing" -ForegroundColor White
Write-Host ""
Write-Host "📊 Logs will be saved to: $logFile" -ForegroundColor Yellow
Write-Host ""

# Start continuous logging
Write-Host "Starting logcat capture..." -ForegroundColor Green
try {
    & adb logcat -s ElythraVerboseMode:V UserAction:V Performance:V Network:V Audio:V UI:V AndroidRuntime:E System.err:E | Tee-Object -FilePath $logFile
} catch {
    Write-Host "❌ Error starting logcat: $_" -ForegroundColor Red
    Write-Host "💡 Make sure your device is connected and USB debugging is enabled" -ForegroundColor Yellow
}