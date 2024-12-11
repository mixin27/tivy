# Tivy

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]
![Pub Version (including pre-releases)](https://img.shields.io/pub/v/tivy?style=flat-square&color=3297D1&link=https%3A%2F%2Fpub.dev%2Fpackages%2Ftivy)

Utility package for getting video quality urls for vimeo and youtube.

## Installation 💻

**❗ In order to start using Tivy you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Add `tivy` to your `pubspec.yaml`:

```yaml
dependencies:
  tivy:
```

Install it:

```sh
flutter packages get
```

---

## Usage

- Import package

  ```dart
  import 'package:tivy/tivy.dart';
  ```

- For vimeo video

  ```dart
  final videoQualityUrls = await Tivy.getVideoQualityUrls(
    'your_private_vimeo_video_id',
    accessToken: 'your_access_token',
  );
  ```

- For YouTube video url.

  ```dart
  final youTubeVideoUrl = await Tivy.getYouTubeVideoQualityUrls(
    'your_youtube_video_url',
  );
  // Available muxed video links with audio and video
  // Note that muxed streams are limited in quality.
  final muxedUrls = youTubeVideoUrl.muxedUrls;

  // Available streams video links.
  final streamsUrls = youTubeVideoUrl.streamUrls;
  ```

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
