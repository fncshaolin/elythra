# Elythra APK Signing Setup Script (Windows PowerShell)
# This script helps create a keystore for signing release APKs

Write-Host "🔐 Elythra APK Signing Setup" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host ""

# Check if keystore directory exists
if (!(Test-Path "app\keystore")) {
    Write-Host "📁 Creating keystore directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "app\keystore" -Force | Out-Null
}

# Check if keystore already exists
if (Test-Path "app\keystore\release.keystore") {
    Write-Host "⚠️  Keystore already exists at app\keystore\release.keystore" -ForegroundColor Red
    Write-Host "   Delete it first if you want to create a new one." -ForegroundColor Red
    exit 1
}

Write-Host "🔑 Creating new release keystore..." -ForegroundColor Green
Write-Host ""
Write-Host "You'll be prompted for:" -ForegroundColor Yellow
Write-Host "- Keystore password (remember this!)" -ForegroundColor Yellow
Write-Host "- Key alias (e.g., 'elythra-release')" -ForegroundColor Yellow
Write-Host "- Key password (can be same as keystore password)" -ForegroundColor Yellow
Write-Host "- Your name/organization details" -ForegroundColor Yellow
Write-Host ""

# Check if keytool is available
try {
    $null = Get-Command keytool -ErrorAction Stop
} catch {
    Write-Host "❌ Error: keytool not found!" -ForegroundColor Red
    Write-Host "Please install Java JDK and ensure keytool is in your PATH" -ForegroundColor Red
    Write-Host "Download from: https://adoptium.net/" -ForegroundColor Yellow
    exit 1
}

# Generate keystore
Write-Host "🔧 Running keytool..." -ForegroundColor Cyan
keytool -genkey -v -keystore "app\keystore\release.keystore" -alias "elythra-release" -keyalg RSA -keysize 2048 -validity 10000

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Keystore created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📝 Next steps:" -ForegroundColor Cyan
    Write-Host "1. Set environment variables before building:" -ForegroundColor Yellow
    Write-Host "   `$env:STORE_PASSWORD='your_keystore_password'" -ForegroundColor White
    Write-Host "   `$env:KEY_ALIAS='elythra-release'" -ForegroundColor White
    Write-Host "   `$env:KEY_PASSWORD='your_key_password'" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Build signed release APK:" -ForegroundColor Yellow
    Write-Host "   .\gradlew.bat assembleArm64Release" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Your signed APK will be at:" -ForegroundColor Yellow
    Write-Host "   app\build\outputs\apk\arm64\release\app-arm64-release.apk" -ForegroundColor White
    Write-Host ""
    Write-Host "🛡️ Signed APKs have much lower false positive rates on VirusTotal!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "❌ Failed to create keystore!" -ForegroundColor Red
    Write-Host "Please check the error messages above." -ForegroundColor Red
}