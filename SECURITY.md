# Security Information

## VirusTotal False Positives

Elythra may occasionally trigger false positives on antivirus scanners. This is common for legitimate Android music apps due to the following reasons:

### Why False Positives Occur

1. **Unsigned APKs**: Release builds are unsigned by default, which some AV engines flag as suspicious
2. **Legitimate Permissions**: Required for music streaming functionality:
   - `INTERNET` - For YouTube/streaming access
   - `FOREGROUND_SERVICE` - For background music playback
   - `WAKE_LOCK` - To prevent device sleep during playback
   - `RECEIVE_BOOT_COMPLETED` - For service restart after reboot

3. **YouTube Integration**: Intent filters for YouTube URLs may trigger heuristic detection
4. **Media Libraries**: NewPipe Extractor and Media3 ExoPlayer are legitimate but powerful libraries
5. **Code Obfuscation**: ProGuard optimization can trigger heuristic scanners

### Verification Steps

To verify Elythra's legitimacy:

1. **Source Code**: All source code is publicly available on GitHub
2. **Build Process**: APKs are built using GitHub Actions with transparent workflows
3. **Dependencies**: All dependencies are well-known, open-source libraries
4. **No Malicious Behavior**: 
   - No data collection or tracking
   - No ads or monetization
   - No network access except for music streaming
   - No file system access beyond app data

### For Developers

If you're building from source and want to minimize false positives:

1. **Sign Your APKs**: Use your own signing key for release builds
2. **Submit to AV Vendors**: Report false positives to improve detection
3. **Use Debug Builds**: For testing, debug builds are less likely to be flagged

### Reporting Issues

If you encounter security concerns:
1. Check the source code on GitHub
2. Build from source to verify
3. Report false positives to your AV vendor
4. Open an issue on GitHub for discussion

## Privacy

Elythra respects your privacy:
- No user data collection
- No analytics or tracking
- No account creation required
- All data stays on your device
- Open source and auditable

## Permissions Explained

- `INTERNET`: Stream music from YouTube/services
- `ACCESS_NETWORK_STATE`: Check connectivity status
- `FOREGROUND_SERVICE`: Background music playback
- `WAKE_LOCK`: Prevent sleep during playback
- `POST_NOTIFICATIONS`: Show playback controls
- `RECEIVE_BOOT_COMPLETED`: Restart services after reboot

All permissions are used solely for music playback functionality.