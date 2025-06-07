import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'logger_service.dart';
import 'error_handler.dart';

// Import the existing AudioQuality enum from music_service.dart
import 'music_service.dart' show AudioQuality;

class AudioStreamInfo {
  final String url;
  final AudioQuality quality;
  final int bitrate;
  final String codec;
  final int? contentLength;
  final Duration? duration;

  const AudioStreamInfo({
    required this.url,
    required this.quality,
    required this.bitrate,
    required this.codec,
    this.contentLength,
    this.duration,
  });

  Map<String, dynamic> toJson() => {
    'url': url,
    'quality': quality.name,
    'bitrate': bitrate,
    'codec': codec,
    'contentLength': contentLength,
    'duration': duration?.inSeconds,
  };
}

class YouTubeAudioExtractor {
  static YouTubeAudioExtractor? _instance;
  static YouTubeAudioExtractor get instance => _instance ??= YouTubeAudioExtractor._();
  
  YouTubeAudioExtractor._();

  final YoutubeExplode _yt = YoutubeExplode();
  final Dio _dio = Dio();

  /// Extract audio streams from YouTube video with quality options
  Future<List<AudioStreamInfo>> extractAudioStreams(String videoId) async {
    return await safeExecute<List<AudioStreamInfo>>(
      () async {
        logInfo('Extracting audio streams for video: $videoId', tag: 'YouTubeAudioExtractor');
        
        final manifest = await _yt.videos.streamsClient.getManifest(videoId);
        final audioStreams = manifest.audioOnly.toList();
        
        if (audioStreams.isEmpty) {
          throw const AudioException('No audio streams found', code: 'AUDIO_STREAM_NOT_FOUND');
        }

        final List<AudioStreamInfo> streamInfos = [];
        
        // Sort streams by bitrate (highest first)
        audioStreams.sort((a, b) => b.bitrate.bitsPerSecond.compareTo(a.bitrate.bitsPerSecond));
        
        // Map streams to quality levels
        for (final stream in audioStreams) {
          final quality = _mapBitrateToQuality(stream.bitrate.bitsPerSecond);
          
          // Skip if we already have this quality level
          if (streamInfos.any((info) => info.quality == quality)) continue;
          
          streamInfos.add(AudioStreamInfo(
            url: stream.url.toString(),
            quality: quality,
            bitrate: stream.bitrate.kiloBitsPerSecond.round(),
            codec: stream.audioCodec,
            contentLength: stream.size.totalBytes,
            duration: stream.size.totalBytes != null ? null : null, // Duration from video info
          ));
        }

        // Ensure we have all quality levels by creating fallbacks if needed
        await _ensureAllQualityLevels(streamInfos, videoId);
        
        logInfo('Extracted ${streamInfos.length} audio streams', tag: 'YouTubeAudioExtractor');
        return streamInfos;
      },
      context: 'extractAudioStreams',
      fallback: [],
    ) ?? [];
  }

  /// Get best audio stream for specified quality
  Future<AudioStreamInfo?> getBestAudioStream(String videoId, AudioQuality preferredQuality) async {
    final streams = await extractAudioStreams(videoId);
    
    // Try to find exact quality match
    var stream = streams.where((s) => s.quality == preferredQuality).firstOrNull;
    
    // Fallback to closest quality
    if (stream == null && streams.isNotEmpty) {
      stream = _findClosestQuality(streams, preferredQuality);
      logWarning('Preferred quality ${preferredQuality.displayName} not available, using ${stream?.quality.displayName}', 
                 tag: 'YouTubeAudioExtractor');
    }
    
    return stream;
  }

  /// Extract audio URL directly (faster for immediate playback)
  Future<String?> getDirectAudioUrl(String videoId, AudioQuality quality) async {
    final stream = await getBestAudioStream(videoId, quality);
    return stream?.url;
  }

  /// Convert video to audio with specified quality (for downloading)
  Future<AudioStreamInfo?> convertVideoToAudio(String videoId, AudioQuality targetQuality) async {
    return await safeExecute<AudioStreamInfo?>(
      () async {
        logInfo('Converting video $videoId to ${targetQuality.displayName} audio', tag: 'YouTubeAudioExtractor');
        
        // For now, we'll use the direct stream extraction
        // In the future, this could implement actual transcoding
        final stream = await getBestAudioStream(videoId, targetQuality);
        
        if (stream == null) {
          throw const AudioException('Failed to convert video to audio', code: 'CONVERSION_FAILED');
        }

        // Validate stream URL
        if (!await _validateStreamUrl(stream.url)) {
          throw const AudioException('Invalid audio stream URL', code: 'INVALID_STREAM_URL');
        }

        return stream;
      },
      context: 'convertVideoToAudio',
    );
  }

  /// Get video metadata for audio extraction
  Future<Map<String, dynamic>?> getVideoMetadata(String videoId) async {
    return await safeExecute<Map<String, dynamic>?>(
      () async {
        final video = await _yt.videos.get(videoId);
        return {
          'id': video.id.value,
          'title': video.title,
          'author': video.author,
          'duration': video.duration?.inSeconds,
          'description': video.description,
          'thumbnails': video.thumbnails.map((t) => {
            'url': t.url.toString(),
            'width': t.width,
            'height': t.height,
          }).toList(),
        };
      },
      context: 'getVideoMetadata',
    );
  }

  AudioQuality _mapBitrateToQuality(int bitsPerSecond) {
    final kbps = bitsPerSecond ~/ 1000;
    
    if (kbps >= 256) return AudioQuality.High;
    if (kbps >= 192) return AudioQuality.Medium;
    return AudioQuality.Low;
  }

  AudioStreamInfo? _findClosestQuality(List<AudioStreamInfo> streams, AudioQuality target) {
    if (streams.isEmpty) return null;
    
    return streams.reduce((a, b) {
      final aDiff = (a.quality.bitrate - target.bitrate).abs();
      final bDiff = (b.quality.bitrate - target.bitrate).abs();
      return aDiff <= bDiff ? a : b;
    });
  }

  Future<void> _ensureAllQualityLevels(List<AudioStreamInfo> streams, String videoId) async {
    final availableQualities = streams.map((s) => s.quality).toSet();
    
    // If we're missing quality levels, we could implement transcoding here
    // For now, we'll just log what's available
    for (final quality in AudioQuality.values) {
      if (!availableQualities.contains(quality)) {
        logWarning('Quality ${quality.displayName} not available for video $videoId', 
                   tag: 'YouTubeAudioExtractor');
      }
    }
  }

  Future<bool> _validateStreamUrl(String url) async {
    try {
      final response = await _dio.head(url);
      return response.statusCode == 200;
    } catch (e) {
      logWarning('Stream URL validation failed: $e', tag: 'YouTubeAudioExtractor');
      return false;
    }
  }

  /// Search for videos and return results with audio extraction capability
  Future<List<Map<String, dynamic>>> searchVideos(String query, {int maxResults = 20}) async {
    return await safeExecute<List<Map<String, dynamic>>>(
      () async {
        logInfo('Searching videos for: $query', tag: 'YouTubeAudioExtractor');
        
        final searchResults = await _yt.search.search(query);
        final videos = searchResults.whereType<Video>().take(maxResults).toList();
        
        return videos.map((video) => {
          'id': video.id.value,
          'title': video.title,
          'author': video.author,
          'duration': video.duration?.inSeconds,
          'thumbnails': video.thumbnails.map((t) => {
            'url': t.url.toString(),
            'width': t.width,
            'height': t.height,
          }).toList(),
          'viewCount': video.engagement.viewCount,
          'uploadDate': video.uploadDate?.toIso8601String(),
        }).toList();
      },
      context: 'searchVideos',
      fallback: [],
    ) ?? [];
  }

  void dispose() {
    _yt.close();
    _dio.close();
  }
}

// Global convenience functions
Future<AudioStreamInfo?> extractAudio(String videoId, AudioQuality quality) {
  return YouTubeAudioExtractor.instance.getBestAudioStream(videoId, quality);
}

Future<String?> getAudioUrl(String videoId, AudioQuality quality) {
  return YouTubeAudioExtractor.instance.getDirectAudioUrl(videoId, quality);
}

Future<List<Map<String, dynamic>>> searchYouTubeVideos(String query, {int maxResults = 20}) {
  return YouTubeAudioExtractor.instance.searchVideos(query, maxResults: maxResults);
}