// ignore_for_file: avoid_dynamic_calls

import 'dart:developer';
import 'dart:io';

import 'package:tivy/src/apis/vimeo_api_client.dart';
import 'package:tivy/src/apis/youtube_api_client.dart';
import 'package:tivy/src/models/models.dart';
import 'package:tivy/src/repositories/vimeo/vimeo_repository.dart';
import 'package:tivy/src/repositories/vimeo/vimeo_repository_impl.dart';
import 'package:tivy/src/repositories/youtube/youtube_repository.dart';
import 'package:tivy/src/repositories/youtube/youtube_repository_impl.dart';
import 'package:tivy/src/utls/result.dart';

/// {@template tivy}
/// Utility package for getting video quality urls for vimeo and youtube.
/// {@endtemplate}
class Tivy {
  /// Repository for getting `Vimeo` videos.
  static VimeoRepository vimeoRepository = VimeoRepositoryImpl(
    apiClient: VimeoApiClient(),
  );

  /// Repository for getting `YouTube` videos.
  static YoutubeRepository youtubeRepository = YoutubeRepositoryImpl(
    apiClient: const YoutubeApiClient(),
  );

  /// Get `vimeo` vide information from url.
  ///
  /// `url` - Vimeo video url
  static Future<VimeoVideoInfo> getVimeoVideoInfo(String url) async {
    final repository = VimeoRepositoryImpl(apiClient: VimeoApiClient());
    final result = await repository.getVimeoVideoInfo(url);
    switch (result) {
      case Ok():
        return result.asOk.value;
      case Error():
        throw result.error;
    }
  }

  /// {@macro getVimeoVideoQualityUrls}
  static Future<List<VideoQualityUrl>> getVimeoVideoQualityUrls(
    String videoId, {
    required String accessToken,
  }) async {
    final repository = VimeoRepositoryImpl(apiClient: VimeoApiClient());
    final result = await repository.getVimeoVideoQualityUrls(
      videoId,
      httpHeader: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
    );
    switch (result) {
      case Ok():
        return result.asOk.value;
      case Error():
        log('${result.error}');
        throw result.error;
    }
  }

  /// {@macro getYouTubeVideoQualityUrls}
  static Future<YouTubeVideoUrl> getYouTubeVideoQualityUrls(
    String idOrUrl, {
    bool live = false,
  }) async {
    final repository = YoutubeRepositoryImpl(
      apiClient: const YoutubeApiClient(),
    );
    final result = await repository.getYouTubeVideoQualityUrls(
      idOrUrl,
      live: live,
    );
    switch (result) {
      case Ok():
        return result.asOk.value;
      case Error():
        throw result.error;
    }
  }
}
