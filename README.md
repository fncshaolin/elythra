# Elythra Music

[![Android Build](https://github.com/fncshaolin/elythra/actions/workflows/android_build.yml/badge.svg)](https://github.com/fncshaolin/elythra/actions/workflows/android_build.yml)
[![Version](https://img.shields.io/badge/version-1.12.0-blue.svg)](https://github.com/fncshaolin/elythra/releases)

A cross platform music streaming app with hybrid architecture:
- **Android**: Native Android app (Kotlin/Jetpack Compose) for superior performance
- **Windows/Linux**: Flutter app for desktop platforms

# Features
* Ability to play song from Ytube/Ytube Music.
* Song cache while playing
* Radio feature support
* Background music
* Playlist creation & bookmark support
* Artist & Album bookmark support
* Import song,Playlist,Album,Artist via sharing from Ytube/Ytube Music.
* Streaming quality control
* Song downloading support
* Language support
* Skip silence
* Dynamic Theme
* Flexibility to switch between Bottom & Side Nav bar
* Equalizer support
* Android Auto support
* Synced & Plain Lyrics support
* Sleep Timer
* No Advertisment
* No Login required
* Piped playlist integration


# Download

## Android v0.5 (Current Release)
🚀 **Native Android App** - Download the latest Android APK from [GitHub Releases](https://github.com/fncshaolin/elythra/releases/latest)

> **⚠️ Security Note**: Unsigned APKs may trigger false positives on some antivirus scanners. This is normal for legitimate music apps. See [SECURITY.md](SECURITY.md) for details.

## Desktop (Coming Soon)
- **Windows**: Flutter app (v1.0.0 planned)
- **Linux**: Flutter app (v1.0.0 planned) 

# Translation
Translation support coming soon.

# Troubleshoot
* if you are facing Notification control issue or music playback stopped by system optimization, please enable ignore battery optimization option from settings

# License
```
Elythra is a free software licensed under GPL v3.0 with following condition.

- Copied/Modified version of this software can not be used for 'non-free' and profit purposes.
- You can not publish copied/modified version of this app on closed source app repository
  like PlayStore/AppStore.

```


# Disclaimer
```
This project has been created while learning & learning is the main intention.
This project is not sponsored or affiliated with, funded, authorized, endorsed by any content provider.
Any Song, content, trademark used in this app are intellectual property of their respective owners.
Elythra is not responsible for any infringement of copyright or other intellectual property rights that may result
from the use of the songs and other content available through this app.

This Software is released "as-is", without any warranty, responsibility or liability.
In no event shall the Author of this Software be liable for any special, consequential,
incidental or indirect damages whatsoever (including, without limitation, any 
other pecuniary loss) arising out of the use of inability to use this product, even if
Author of this Sotware is aware of the possibility of such damages and known defect.
```

# Learning References & Credits
<a href = 'https://docs.flutter.dev/'>Flutter documentation</a> - a best guide to learn cross platform Ui/app developemnt<br/>
<a href = 'https://suragch.medium.com/'>Suragch</a>'s Article related to Just audio & state management,architectural style<br/>
<a href = 'https://github.com/sigma67'>sigma67</a>'s unofficial ytmusic api project<br/>
App UI inspired by <a href = 'https://github.com/vfsfitvnm'>vfsfitvnm</a>'s ViMusic<br/>
Synced lyrics provided by <a href = 'https://lrclib.net' >LRCLIB</a> <br/>
<a href = 'https://piped.video' >Piped</a> for playlists.

#### Major Packages used
* just_audio: ^0.9.40  -  audio player for android
* media_kit: ^1.1.9 - audio player for linux and windows
* audio_service: ^0.18.15 - manage background music & platform audio services
* get: ^4.6.6 -  package for high-performance state management, intelligent dependency injection, and route management
* youtube_explode_dart: ^2.0.2 - Third party package to provide song url
* hive: ^2.2.3 - offline db used 
* hive_flutter: ^1.1.0


