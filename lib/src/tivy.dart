// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tivy/src/models/models.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// [Tivy] instance
const tivy = Tivy();

/// {@template tivy}
/// Utility package for getting video quality urls for vimeo and youtube.
/// {@endtemplate}
class Tivy {
  /// {@macro}
  const Tivy();

  /// Get `Vimeo` video quality urls.
  ///
  /// `videoIdOrUrl` - Vimeo video id or url.
  ///
  ///
  /// Example:
  /// ```dart
  /// final videoQualityUrls = await tivy.getVideoQualityUrls(
  ///    'https://vimeo.com/663563090',
  ///  );
  /// ```
  Future<List<VideoQalityUrl>> getVimeoVideoQualityUrls(
    String videoIdOrUrl, {
    String? hash,
  }) async {
    try {
      String videoId;

      if (videoIdOrUrl.startsWith('https://vimeo.com')) {
        final videoInfo = await getVimeoVideoInfo(videoIdOrUrl);
        videoId = videoInfo.videoId;
      } else {
        videoId = videoIdOrUrl;
      }

      final response = await _makeRequestHash(videoId: videoId, hash: hash);
      final jsonData = jsonDecode(response.body)['request']['files']
          ['progressive'] as List<dynamic>;
      final progressiveUrls = List.generate(
        jsonData.length,
        (index) => VideoQalityUrl(
          quality: int.parse(
            (jsonData[index]['quality'] as String?)?.split('p').first ?? '0',
          ),
          url: jsonData[index]['url'] as String,
        ),
      );
      if (progressiveUrls.isEmpty) {
        final jsonRes =
            jsonDecode(response.body)['request']['files']['hls']['cdns'];
        for (final element in (jsonRes as Map).entries.toList()) {
          progressiveUrls.add(
            VideoQalityUrl(
              quality: 720,
              url: element.value['url'] as String,
            ),
          );
          break;
        }
      }

      return progressiveUrls;
    } catch (error) {
      if (error.toString().contains('XMLHttpRequest')) {
        log(
          '(INFO) To play vimeo video in WEB, Please enable CORS in your browser',
        );
      }
      debugPrint('===== VIMEO API ERROR: $error ==========');
      rethrow;
    }
  }

  /// Get `Vimeo` video quality urls.
  ///
  /// `videoId` - Vimeo video id.
  ///
  /// `httpHeader` - Http header values to request.
  ///
  /// Example:
  /// ```dart
  ///  final videoQualityUrls = await tivy.getPrivateVimeoVideoQualityUrls(
  ///    '663563090',
  ///    {
  ///      'key': 'value',
  ///    },
  ///  );
  /// ```
  Future<List<VideoQalityUrl>> getPrivateVimeoVideoQualityUrls(
    String videoId,
    Map<String, String> httpHeader,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.vimeo.com/videos/$videoId'),
        headers: httpHeader,
      );
      final jsonData = jsonDecode(response.body)['files'] as List<dynamic>;

      final list = <VideoQalityUrl>[];
      for (var i = 0; i < jsonData.length; i++) {
        final quality =
            (jsonData[i]['rendition'] as String?)?.split('p').first ?? '0';
        final number = int.tryParse(quality);
        if (number != null && number != 0) {
          list.add(
            VideoQalityUrl(
              quality: number,
              url: jsonData[i]['link'] as String,
            ),
          );
        }
      }

      return list;
    } catch (error) {
      if (error.toString().contains('XMLHttpRequest')) {
        log(
          '(INFO) To play vimeo video in WEB, Please enable CORS in your browser',
        );
      }
      debugPrint('===== VIMEO API ERROR: $error ==========');
      rethrow;
    }
  }

  /// Get `YouTube` video quality urls.
  ///
  /// `idOrUrl` - Vimeo youtube `id` or youtube video `url`.
  ///
  /// `live` - Set `true` if the youtube video url is `live` streaming ur.
  /// Default value is `false`.
  ///
  /// Example:
  /// ```dart
  /// final videoQualityUrls = await tivy.getYouTubeVideoQualityUrls(
  ///    'https://www.youtube.com/watch?v=CRLPsOl4AAA',
  ///  );
  /// ```
  Future<List<VideoQalityUrl>> getYouTubeVideoQualityUrls(
    String idOrUrl, {
    bool live = false,
  }) async {
    try {
      final yt = YoutubeExplode();
      final urls = <VideoQalityUrl>[];

      if (live) {
        final url = await yt.videos.streamsClient.getHttpLiveStreamUrl(
          VideoId(idOrUrl),
        );
        urls.add(
          VideoQalityUrl(
            quality: 360,
            url: url,
          ),
        );
      } else {
        final manifest = await yt.videos.streamsClient.getManifest(idOrUrl);
        urls.addAll(
          manifest.muxed.map(
            (element) => VideoQalityUrl(
              quality: int.parse(element.qualityLabel.split('p')[0]),
              url: element.url.toString(),
            ),
          ),
        );
      }
      // Close the YoutubeExplode's http client.
      yt.close();

      return urls;
    } catch (error) {
      if (error.toString().contains('XMLHttpRequest')) {
        log(
          '(INFO) To play youtube video in WEB, Please enable CORS in your browser',
        );
      }
      debugPrint('===== YOUTUBE API ERROR: $error ==========');
      rethrow;
    }
  }

  /// Request vimeo config request.
  ///
  /// `videoId` - Vimeo video id.
  ///
  /// `hash` - Hash value of vimeo video
  Future<http.Response> _makeRequestHash({
    required String videoId,
    String? hash,
  }) async {
    if (hash == null) {
      return http.get(
        Uri.parse('https://player.vimeo.com/video/$videoId/config'),
      );
    } else {
      return http.get(
        Uri.parse('https://player.vimeo.com/video/$videoId/config?h=$hash'),
      );
    }
  }

  /// Get `vimeo` vide information from url.
  ///
  /// `url` - Vimeo video url
  Future<VimeoVideo> getVimeoVideoInfo(String url) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://vimeo.com/api/oembed.json?url=$url',
        ),
      );

      final jsonData = jsonDecode(response.body);

      return VimeoVideo(
        videoId: '${jsonData['video_id'] as int}',
        uri: jsonData['uri'] as String,
        duration: jsonData['video_id'] as int? ?? 0,
        width: jsonData['width'] as int? ?? 0,
        height: jsonData['height'] as int? ?? 0,
        thumbnailUrl: jsonData['thumbnail_url'] as String,
        thumbnailUrlWithPlayButton:
            jsonData['thumbnail_url_with_play_button'] as String,
        thumbnailHeight: jsonData['thumbnail_height'] as int? ?? 0,
        thumbnailWidth: jsonData['thumbnail_width'] as int? ?? 0,
      );
    } catch (error) {
      debugPrint('===== VIMEO INFO API ERROR: $error ==========');
      rethrow;
    }
  }
}
