// ignore_for_file: one_member_abstracts

import 'package:tivy/src/models/models.dart';
import 'package:tivy/src/utls/result.dart';

/// {@template YoutubeRepository}
/// YouTube video api repository.
/// {@endtemplate}
abstract class YoutubeRepository {
  /// {@macro getYouTubeVideoQualityUrls}
  Future<Result<YouTubeVideoUrl>> getYouTubeVideoQualityUrls(
    String idOrUrl, {
    bool live = false,
  });
}
