import 'package:equatable/equatable.dart';

/// Video quality url model.
class VideoQalityUrl extends Equatable {
  /// Constructor of [VideoQalityUrl]
  const VideoQalityUrl({
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
