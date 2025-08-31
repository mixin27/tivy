import 'package:tivy/src/apis/youtube_api_client.dart';
import 'package:tivy/src/models/video_quality_url.dart';
import 'package:tivy/src/repositories/youtube/youtube_repository.dart';
import 'package:tivy/src/utls/result.dart';

/// {@macro YoutubeRepository}
class YoutubeRepositoryImpl implements YoutubeRepository {
  /// {@macro YoutubeRepository}
  YoutubeRepositoryImpl({required YoutubeApiClient apiClient})
    : _apiClient = apiClient;

  /// Youtube api client
  final YoutubeApiClient _apiClient;

  /// Implements basic local caching.
  /// See: https://docs.flutter.dev/get-started/fwe/local-caching
  final Map<String, YouTubeVideoUrl> _cachedData = {};

  /// {@macro getYouTubeVideoQualityUrls}
  @override
  Future<Result<YouTubeVideoUrl>> getYouTubeVideoQualityUrls(
    String idOrUrl, {
    bool live = false,
  }) async {
    if (!_cachedData.containsKey(idOrUrl)) {
      // No cached data, request api
      final result = await _apiClient.getYouTubeVideoQualityUrls(
        idOrUrl,
        live: live,
      );
      if (result is Ok) {
        _cachedData[idOrUrl] = result.asOk.value;
      }
      return result;
    } else {
      return Result.ok(_cachedData[idOrUrl]!);
    }
  }
}
