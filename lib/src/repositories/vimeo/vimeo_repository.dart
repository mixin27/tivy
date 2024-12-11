import 'package:tivy/src/models/models.dart';
import 'package:tivy/src/utls/result.dart';

/// {@template VimeoRepository}
/// Vimeo video repository.
/// {@endtemplate}
abstract class VimeoRepository {
  /// {@template getVimeoVideoInfo}
  /// Get vimeo video info by url.
  /// {@endtemplate}
  Future<Result<VimeoVideoInfo>> getVimeoVideoInfo(String url);

  /// {@template getVimeoVideoQualityUrls}
  /// Get vimeo video quality urls
  /// {@endtemplate}
  Future<Result<List<VideoQualityUrl>>> getVimeoVideoQualityUrls(
    String videoId, {
    Map<String, String>? httpHeader,
  });
}
