import 'package:equatable/equatable.dart';

/// {@template YouTubeVideoUrl}
/// YouTube video url include `muxed` and `streams`.
/// {@endtemplate}
class YouTubeVideoUrl extends Equatable {
  /// {@macro YouTubeVideoUrl}
  const YouTubeVideoUrl({
    required this.muxedUrls,
    required this.streamUrls,
  });

  /// `muxed` video urls
  final List<VideoQualityUrl> muxedUrls;

  /// `streams` urls
  final List<VideoQualityUrl> streamUrls;

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

/// {@template VideoQualityUrl}
/// Video quality url model.
/// {@endtemplate}
class VideoQualityUrl extends Equatable {
  /// {@macro VideoQualityUrl}
  const VideoQualityUrl({
    required this.quality,
    required this.url,
  });

  /// Video quality.
  final int quality;

  /// Video url.
  final String url;

  @override
  List<Object?> get props => [quality, url];
}
