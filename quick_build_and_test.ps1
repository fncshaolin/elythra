# Quick Build and Test Script for Elythra Music

Write-Host "🚀 Elythra Music - Quick Build & Test" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Step 1: Clean Flutter files
Write-Host "🧹 Cleaning Flutter interference..." -ForegroundColor Yellow
if (Test-Path "android\app\src\main\java\io\flutter") {
    Remove-Item "android\app\src\main\java\io\flutter" -Recurse -Force
    Write-Host "  ✅ Removed Flutter directory" -ForegroundColor Green
}
if (Test-Path ".flutter-plugins") {
    Remove-Item ".flutter-plugins" -Force
    Write-Host "  ✅ Removed .flutter-plugins" -ForegroundColor Green
}
if (Test-Path ".flutter-plugins-dependencies") {
    Remove-Item ".flutter-plugins-dependencies" -Force
    Write-Host "  ✅ Removed .flutter-plugins-dependencies" -ForegroundColor Green
}

# Step 2: Build APK
Write-Host ""
Write-Host "📱 Building ARM64 Debug APK..." -ForegroundColor Green
Set-Location "android"
& ".\gradlew.bat" "clean"
& ".\gradlew.bat" "assembleArm64Debug"

# Step 3: Check if build succeeded
Write-Host ""
$debugApk = "app\build\outputs\apk\arm64\debug\app-arm64-debug.apk"
$verboseApk = "app\build\outputs\apk\arm64\verbose\app-arm64-verbose.apk"

if (Test-Path $debugApk) {
    Write-Host "✅ Debug APK built successfully!" -ForegroundColor Green
    Write-Host "📂 Location: android\$debugApk" -ForegroundColor White
    
    # Step 4: Install APK
    Write-Host ""
    Write-Host "📦 Installing APK..." -ForegroundColor Yellow
    & adb install -r $debugApk
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ APK installed successfully!" -ForegroundColor Green
        
        # Step 5: Start basic logging
        Write-Host ""
        Write-Host "📊 Starting basic logging..." -ForegroundColor Yellow
        $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
        $logFile = "..\testing_logs\quick_session_$timestamp.log"
        
        # Create testing_logs directory if it doesn't exist
        if (!(Test-Path "..\testing_logs")) {
            New-Item -ItemType Directory -Path "..\testing_logs" | Out-Null
        }
        
        Write-Host ""
        Write-Host "🎯 Ready to test!" -ForegroundColor Green
        Write-Host "📱 App package: com.elythra.music.debug" -ForegroundColor White
        Write-Host "📊 Logs: $logFile" -ForegroundColor White
        Write-Host ""
        Write-Host "🔥 Test the app now! Press Ctrl+C when done." -ForegroundColor Cyan
        
        # Start logging
        & adb logcat -s "ElythraMusic:V" "AndroidRuntime:E" "System.err:E" | Tee-Object -FilePath $logFile
        
    } else {
        Write-Host "❌ APK installation failed!" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Build failed! APK not found." -ForegroundColor Red
    Write-Host "🔍 Check the build output above for errors." -ForegroundColor Yellow
}

Set-Location ".."