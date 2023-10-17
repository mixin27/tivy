# Tivy

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

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

- Use with vimeo video url

  ```dart
  final videoQualityUrls = await tivy.getVideoQualityUrls(
    'https://vimeo.com/663563090',
  );
  ```

- Use with vimeo video id

  ```dart
  final videoQualityUrls = await tivy.getVideoQualityUrls(
    '663563090',
  );
  ```

- For vimeo private video

  ```dart
  final videoQualityUrls = await tivy.getPrivateVimeoVideoQualityUrls(
    '663563090',
    {
      'key': 'value',
    },
  );
  ```

- For YouTube video url.

  ```dart
  final videoQualityUrls = await tivy.getYouTubeVideoQualityUrls(
    'https://www.youtube.com/watch?v=CRLPsOl4AAA',
  );
  ```

- For YouTube live streaming video url.

  ```dart
  final videoQualityUrls = await tivy.getYouTubeVideoQualityUrls(
    'https://www.youtube.com/watch?v=CRLPsOl4AAA',
    live: true,
  );
  ```

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
