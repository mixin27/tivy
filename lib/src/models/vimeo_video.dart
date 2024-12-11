// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';

/// {@template VimeoVideoInfo}
/// Vimeo video info model
/// {@endtemplate}
class VimeoVideoInfo extends Equatable {
  /// {@macro VimeoVideoInfo}
  const VimeoVideoInfo({
    required this.videoId,
    required this.uri,
    required this.duration,
    required this.width,
    required this.height,
    required this.thumbnailUrl,
    required this.thumbnailUrlWithPlayButton,
    required this.thumbnailHeight,
    required this.thumbnailWidth,
    required this.html,
    required this.title,
  });

  factory VimeoVideoInfo.fromJson(Map<String, dynamic> json) => VimeoVideoInfo(
        videoId: (json['videoId'] as int? ?? 0).toString(),
        uri: json['uri'] as String? ?? '',
        duration: json['duration'] as int? ?? 0,
        width: json['width'] as int? ?? 0,
        height: json['height'] as int? ?? 0,
        thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
        thumbnailUrlWithPlayButton:
            json['thumbnailUrlWithPlayButton'] as String? ?? '',
        thumbnailHeight: json['thumbnailHeight'] as int? ?? 0,
        thumbnailWidth: json['thumbnailWidth'] as int? ?? 0,
        html: json['html'] as String? ?? '',
        title: json['title'] as String? ?? '',
      );

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

  /// Video html embeded content
  final String html;

  /// Video title
  final String title;

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
