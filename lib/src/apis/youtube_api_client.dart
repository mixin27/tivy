import 'package:tivy/src/models/models.dart';
import 'package:tivy/src/utls/result.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yted;

/// {@template YoutubeApiClient}
/// Api client for `YouTube` videos
/// {@endtemplate}
class YoutubeApiClient {
  /// {@macro YoutubeApiClient}
  const YoutubeApiClient();

  /// {@template getYouTubeVideoQualityUrls}
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
  /// {@endtemplate}
  Future<Result<YouTubeVideoUrl>> getYouTubeVideoQualityUrls(
    String idOrUrl, {
    bool live = false,
  }) async {
    final yt = yted.YoutubeExplode();
    final muxedUrls = <VideoQualityUrl>[];
    final streamsUrls = <VideoQualityUrl>[];

    try {
      if (live) {
        final url = await yt.videos.streamsClient.getHttpLiveStreamUrl(
          yted.VideoId(idOrUrl),
        );
        muxedUrls.add(
          VideoQualityUrl(
            quality: 360,
            url: url,
          ),
        );
      } else {
        final manifest = await yt.videos.streamsClient.getManifest(
          idOrUrl,
          ytClients: [
            yted.YoutubeApiClient.safari,
            yted.YoutubeApiClient.androidVr,
            yted.YoutubeApiClient.android,
            yted.YoutubeApiClient.ios,
            yted.YoutubeApiClient.tv,
            yted.YoutubeApiClient.mweb,
          ],
        );

        muxedUrls.addAll(
          manifest.muxed.map(
            (element) {
              return VideoQualityUrl(
                quality: int.tryParse(element.qualityLabel.split('p')[0]) ?? 0,
                url: element.url.toString(),
              );
            },
          ),
        );

        streamsUrls.addAll(
          manifest.streams.map(
            (element) {
              return VideoQualityUrl(
                quality: int.tryParse(element.qualityLabel.split('p')[0]) ?? 0,
                url: element.url.toString(),
              );
            },
          ),
        );
      }

      return Result.ok(
        YouTubeVideoUrl(
          muxedUrls: muxedUrls,
          streamUrls: streamsUrls,
        ),
      );
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      // Close the YoutubeExplode's http client.
      yt.close();
    }
  }
}
