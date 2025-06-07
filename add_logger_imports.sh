#!/bin/bash

files=(
"lib/ui/widgets/sliding_up_panel.dart"
"lib/ui/widgets/songinfo_bottom_sheet.dart"
"lib/ui/widgets/link_piped.dart"
"lib/ui/widgets/backup_dialog.dart"
"lib/ui/widgets/up_next_queue.dart"
"lib/ui/widgets/restore_dialog.dart"
"lib/ui/player/player.dart"
"lib/ui/home.dart"
"lib/ui/screens/Settings/settings_screen.dart"
"lib/ui/screens/Library/library_controller.dart"
"lib/ui/screens/Album/album_screen_controller.dart"
"lib/ui/screens/Search/search_result_screen_controller.dart"
"lib/ui/screens/Home/home_screen_controller.dart"
"lib/ui/screens/Playlist/playlist_screen_controller.dart"
"lib/ui/utils/theme_controller.dart"
"lib/services/piped_service.dart"
"lib/services/downloader.dart"
"lib/services/music_service.dart"
"lib/services/audio_handler.dart"
"lib/services/windows_audio_service.dart"
"lib/services/continuations.dart"
"lib/services/synced_lyrics_service.dart"
"lib/utils/house_keeping.dart"
"lib/utils/helper.dart"
"lib/utils/app_link_controller.dart"
)

for file in "${files[@]}"; do
    if [ -f "$file" ] && ! grep -q "import.*logger_service.dart" "$file"; then
        echo "Adding import to: $file"
        # Find the last import line and add after it
        sed -i '/^import.*dart.*;$/a import '\''package:elythra/services/logger_service.dart'\'';' "$file"
    fi
done

echo "Logger imports added!"