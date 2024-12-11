import 'package:tivy/src/apis/vimeo_api_client.dart';
import 'package:tivy/src/models/models.dart';
import 'package:tivy/src/repositories/vimeo/vimeo_repository.dart';
import 'package:tivy/src/utls/result.dart';

/// {@macro VimeoRepository}
class VimeoRepositoryImpl implements VimeoRepository {
  /// {@macro VimeoRepository}
  VimeoRepositoryImpl({
    required VimeoApiClient apiClient,
  }) : _apiClient = apiClient;

  /// Vimeo api client
  final VimeoApiClient _apiClient;

  /// Implements basic local caching.
  /// See: https://docs.flutter.dev/get-started/fwe/local-caching
  final Map<String, VimeoVideoInfo> _cachedVideoInfoData = {};

  /// Implements basic local caching.
  /// See: https://docs.flutter.dev/get-started/fwe/local-caching
  final Map<String, List<VideoQualityUrl>> _cachedVideoUrls = {};

  /// {@macro getVimeoVideoInfo}
  @override
  Future<Result<VimeoVideoInfo>> getVimeoVideoInfo(String url) async {
    if (!_cachedVideoInfoData.containsKey(url)) {
      // No cached data, request api
      final result = await _apiClient.getVimeoVideoInfo(url);
      if (result is Ok) {
        _cachedVideoInfoData[url] = result.asOk.value;
      }
      return result;
    } else {
      return Result.ok(_cachedVideoInfoData[url]!);
    }
  }

  /// {@macro getVimeoVideoQualityUrls}
  @override
  Future<Result<List<VideoQualityUrl>>> getVimeoVideoQualityUrls(
    String videoId, {
    Map<String, String>? httpHeader,
  }) async {
    if (!_cachedVideoUrls.containsKey(videoId)) {
      // No cached data, request api
      final result = await _apiClient.getVimeoVideoQualityUrls(
        videoId,
        httpHeader: httpHeader,
      );
      if (result is Ok) {
        _cachedVideoUrls[videoId] = result.asOk.value;
      }
      return result;
    } else {
      return Result.ok(_cachedVideoUrls[videoId]!);
    }
  }
}
