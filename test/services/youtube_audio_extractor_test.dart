import 'package:flutter_test/flutter_test.dart';
import 'package:elythra/services/youtube_audio_extractor.dart';
import 'package:elythra/services/music_service.dart';

void main() {
  group('YouTubeAudioExtractor Tests', () {
    late YouTubeAudioExtractor extractor;

    setUp(() {
      extractor = YouTubeAudioExtractor.instance;
    });

    test('AudioQuality enum has correct values', () {
      expect(AudioQuality.Low.displayName, equals('128kbps'));
      expect(AudioQuality.Medium.displayName, equals('256kbps'));
      expect(AudioQuality.High.displayName, equals('320kbps'));
      
      expect(AudioQuality.Low.bitrate, equals(128));
      expect(AudioQuality.Medium.bitrate, equals(256));
      expect(AudioQuality.High.bitrate, equals(320));
    });

    test('AudioStreamInfo can be created correctly', () {
      const streamInfo = AudioStreamInfo(
        url: 'https://example.com/audio.mp3',
        quality: AudioQuality.High,
        bitrate: 320,
        codec: 'mp4a',
      );

      expect(streamInfo.url, equals('https://example.com/audio.mp3'));
      expect(streamInfo.quality, equals(AudioQuality.High));
      expect(streamInfo.bitrate, equals(320));
      expect(streamInfo.codec, equals('mp4a'));
    });

    test('AudioStreamInfo toJson works correctly', () {
      const streamInfo = AudioStreamInfo(
        url: 'https://example.com/audio.mp3',
        quality: AudioQuality.Medium,
        bitrate: 256,
        codec: 'mp4a',
        contentLength: 1024000,
      );

      final json = streamInfo.toJson();
      expect(json['url'], equals('https://example.com/audio.mp3'));
      expect(json['quality'], equals('Medium'));
      expect(json['bitrate'], equals(256));
      expect(json['codec'], equals('mp4a'));
      expect(json['contentLength'], equals(1024000));
    });

    test('Global convenience functions exist', () {
      // These should not throw exceptions when called
      expect(() => extractAudio('test', AudioQuality.High), returnsNormally);
      expect(() => getAudioUrl('test', AudioQuality.Medium), returnsNormally);
      expect(() => searchYouTubeVideos('test'), returnsNormally);
    });

    // Note: Integration tests with actual YouTube API would require network access
    // and should be run separately from unit tests
  });
}