@echo off
REM Elythra APK Signing Setup Script (Windows Batch)
REM This script helps create a keystore for signing release APKs

echo.
echo 🔐 Elythra APK Signing Setup
echo ==========================
echo.

REM Check if keystore directory exists
if not exist "app\keystore" (
    echo 📁 Creating keystore directory...
    mkdir "app\keystore"
)

REM Check if keystore already exists
if exist "app\keystore\release.keystore" (
    echo ⚠️  Keystore already exists at app\keystore\release.keystore
    echo    Delete it first if you want to create a new one.
    pause
    exit /b 1
)

echo 🔑 Creating new release keystore...
echo.
echo You'll be prompted for:
echo - Keystore password (remember this!)
echo - Key alias (e.g., 'elythra-release')
echo - Key password (can be same as keystore password)
echo - Your name/organization details
echo.

REM Check if keytool is available
keytool -help >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: keytool not found!
    echo Please install Java JDK and ensure keytool is in your PATH
    echo Download from: https://adoptium.net/
    pause
    exit /b 1
)

REM Generate keystore
echo 🔧 Running keytool...
keytool -genkey -v -keystore "app\keystore\release.keystore" -alias "elythra-release" -keyalg RSA -keysize 2048 -validity 10000

if %errorlevel% equ 0 (
    echo.
    echo ✅ Keystore created successfully!
    echo.
    echo 📝 Next steps:
    echo 1. Set environment variables before building:
    echo    set STORE_PASSWORD=your_keystore_password
    echo    set KEY_ALIAS=elythra-release
    echo    set KEY_PASSWORD=your_key_password
    echo.
    echo 2. Build signed release APK:
    echo    gradlew.bat assembleArm64Release
    echo.
    echo 3. Your signed APK will be at:
    echo    app\build\outputs\apk\arm64\release\app-arm64-release.apk
    echo.
    echo 🛡️ Signed APKs have much lower false positive rates on VirusTotal!
) else (
    echo.
    echo ❌ Failed to create keystore!
    echo Please check the error messages above.
)

echo.
pause