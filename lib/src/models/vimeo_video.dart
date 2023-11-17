import 'package:equatable/equatable.dart';

/// {@template VimeoVideo}
/// Vimeo video info model
/// {@endtemplate}
class VimeoVideo extends Equatable {
  /// {@macro VimeoVideo}
  const VimeoVideo({
    required this.videoId,
    required this.uri,
    required this.duration,
    required this.width,
    required this.height,
    required this.thumbnailUrl,
    required this.thumbnailUrlWithPlayButton,
    required this.thumbnailHeight,
    required this.thumbnailWidth,
  });

  /// Video id
  final String videoId;

  /// Video uri
  final String uri;

  /// Video duration
  final int duration;

  /// Video width
  final int width;

  /// Video height
  final int height;

  /// Video thumbnail url
  final String thumbnailUrl;

  /// Video thumbnail url with play button
  final String thumbnailUrlWithPlayButton;

  /// Video thumbnail height
  final int thumbnailHeight;

  /// Video thumbnail width
  final int thumbnailWidth;

  @override
  List<Object?> get props => [
        videoId,
        uri,
        duration,
        width,
        height,
        thumbnailUrl,
        thumbnailUrlWithPlayButton,
        thumbnailHeight,
        thumbnailWidth,
      ];
}
