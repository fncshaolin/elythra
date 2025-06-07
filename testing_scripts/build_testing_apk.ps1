# Elythra Music - Build Testing APK (PowerShell)

Write-Host "🔨 Building Elythra Music Verbose APK" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

Write-Host "🧹 Cleaning Flutter interference..." -ForegroundColor Yellow
& ".\clean_android_flutter_files.bat"

Write-Host ""
Write-Host "📱 Building Verbose Debug APK..." -ForegroundColor Green
Set-Location "android"
& ".\gradlew.bat" "clean"
& ".\gradlew.bat" "assembleArm64Verbose"

Write-Host ""
$apkPath = "app\build\outputs\apk\arm64\verbose\app-arm64-verbose.apk"
if (Test-Path $apkPath) {
    Write-Host "✅ Verbose APK built successfully!" -ForegroundColor Green
    Write-Host "📂 Location: android\$apkPath" -ForegroundColor White
} else {
    Write-Host "❌ Build failed! APK not found." -ForegroundColor Red
    Write-Host "🔍 Check the build output above for errors." -ForegroundColor Yellow
    Read-Host "Press Enter to continue"
    exit 1
}

Write-Host ""
Write-Host "🚀 Next steps:" -ForegroundColor Cyan
Write-Host "1. Run: .\testing_scripts\start_testing_session.ps1" -ForegroundColor White
Write-Host "2. Test the app thoroughly" -ForegroundColor White
Write-Host "3. Share the generated logs" -ForegroundColor White

Set-Location ".."