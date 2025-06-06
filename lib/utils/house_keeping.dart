import 'dart:io';
import 'package:elythra/services/logger_service.dart';

import 'package:get/get.dart';
import 'package:elythra/services/logger_service.dart';
import '/models/media_Item_builder.dart';
import 'package:elythra/services/logger_service.dart';
import '/ui/screens/Library/library_controller.dart';
import 'package:elythra/services/logger_service.dart';
import 'package:hive/hive.dart';
import 'package:elythra/services/logger_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:elythra/services/logger_service.dart';
import '../services/utils.dart';
import 'package:elythra/services/logger_service.dart';
import 'helper.dart';
import 'package:elythra/services/logger_service.dart';

void startHouseKeeping() {
  removeExpiredSongsUrlFromDb();
}

Future<void> removeExpiredSongsUrlFromDb() async {
  try {
    final songsUrlCacheBox = Hive.box("SongsUrlCache");
    final songsUrlCacheKeysList =
        songsUrlCacheBox.keys.whereType<String>().toList();
    for (var i = 0; i < songsUrlCacheKeysList.length; i++) {
      final songUrlKey = songsUrlCacheKeysList[i];
      final streamData = songsUrlCacheBox.get(songUrlKey)[1];
      if (streamData == null ||
          streamData.runtimeType == String ||
          (streamData != null && isExpired(url: streamData['url'] as String))) {
        await songsUrlCacheBox.delete(songUrlKey);
      }
    }
  } catch (e) {
    LoggerService.logger.e("Error in removeExpiredSongsUrlFromDb: $e");
  } finally {
    removeDeletedOfflineSongsFromDb();
  }
}

Future<void> removeDeletedOfflineSongsFromDb() async {
  final supportDir = (await getApplicationSupportDirectory()).path;
  try {
    final songDownloadsBox = Hive.box("SongDownloads");
    final downloadedSongs = songDownloadsBox.values.toList();
    final LibrarySongsController librarySongsController =
        Get.find<LibrarySongsController>();
    for (var i = 0; i < downloadedSongs.length; i++) {
      final songKey = downloadedSongs[i]['videoId'];
      final songUrl = downloadedSongs[i]['url'];
      if (await File(songUrl).exists() == false) {
        await songDownloadsBox.delete(songKey);
        await librarySongsController.removeSong(
            MediaItemBuilder.fromJson(downloadedSongs[i]), true);
        final thumbNailPath = "$supportDir/thumbnails/$songKey.png";
        if (await File(thumbNailPath).exists()) {
          await File(thumbNailPath).delete();
        }
      }
    }
  } catch (e) {
    LoggerService.logger.e("Error in removeDeletedOfflineSongsFromDb: $e");
  }
}
