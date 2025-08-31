// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tivy/src/models/models.dart';
import 'package:tivy/src/utls/result.dart';

/// Api client for `vimeo` videos
class VimeoApiClient {
  /// [VimeoApiClient] constructor.
  VimeoApiClient({http.Client Function()? clientFactory})
    : _clientFactory = clientFactory ?? http.Client.new;

  final http.Client Function() _clientFactory;

  /// Get vimeo video info.
  Future<Result<VimeoVideoInfo>> getVimeoVideoInfo(String url) async {
    final client = _clientFactory();

    try {
      final uri = Uri.parse('https://vimeo.com/api/oembed.json?url=$url');
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Result.ok(VimeoVideoInfo.fromJson(json));
      } else {
        return Result.error(const HttpException('Invalid response.'));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  /// {@template getVimeoVideoQualityUrls}
  /// Get `Vimeo` video quality urls.
  ///
  /// `videoId` - Vimeo video id.
  ///
  /// `httpHeader` - Http header values to request.
  ///
  /// Example:
  /// ```dart
  ///  final videoQualityUrls = await tivy.getPrivateVimeoVideoQualityUrls(
  ///    '663563090',
  ///    httpHeader: {
  ///      'key': 'value',
  ///    },
  ///  );
  /// ```
  ///
  /// 1. Create your app from https://developer.vimeo.com/apps/new
  /// 2. Generate Access Token
  /// 3. Pass this access token:
  ///   ```dart
  ///   httpHeader: {
  ///     'Authorization': 'Bearer {your_token}',
  ///   }
  ///   ```
  ///
  /// NOTE: Get video file and download links from the API This feature requires a Vimeo Standard and
  /// higher or Vimeo Pro and higher membership.
  /// {@endtemplate}
  Future<Result<List<VideoQualityUrl>>> getVimeoVideoQualityUrls(
    String videoId, {
    Map<String, String>? httpHeader,
  }) async {
    final client = _clientFactory();

    try {
      final uri = Uri.parse('https://api.vimeo.com/videos/$videoId');
      final response = await client.get(uri, headers: httpHeader);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final files = json['files'] as List<dynamic>? ?? [];

        final list = <VideoQualityUrl>[];

        for (var i = 0; i < files.length; i++) {
          final quality =
              (files[i]['rendition'] as String?)?.split('p').first ?? '0';
          final number = int.tryParse(quality);
          if (number != null && number != 0) {
            list.add(
              VideoQualityUrl(quality: number, url: files[i]['link'] as String),
            );
          }
        }
        return Result.ok(list);
      } else {
        return Result.error(const HttpException('Invalid response'));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }
}
