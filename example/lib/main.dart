import 'package:flutter/material.dart';
import 'package:tivy/tivy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tivy Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tivy Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<VideoQalityUrl> _youtubeVideoUrls = [];
  List<VideoQalityUrl> _vimeoVideoUrls = [];

  @override
  void initState() {
    _getYouTubeData();
    _getVimeoData();
    super.initState();
  }

  _getYouTubeData() async {
    final ytResult = await tivy.getYouTubeVideoQualityUrls(
      'https://www.youtube.com/watch?v=_EYk-E29edo',
    );

    setState(() {
      _youtubeVideoUrls = ytResult;
    });
  }

  _getVimeoData() async {
    final vimeoResult = await tivy.getVimeoVideoQualityUrls(
      'https://vimeo.com/6718739',
    );

    setState(() {
      _vimeoVideoUrls = vimeoResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(16),
              child: Text(
                "YouTube URI : https://www.youtube.com/watch?v=_EYk-E29edo",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 15,
                    ),
              ),
            ),
            Text(
              "YouTube Video Quality Links",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            _youtubeVideoUrls.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final videoUrl = _youtubeVideoUrls[index];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LinkDetailPage(
                                title: '${videoUrl.quality}p',
                                link: videoUrl.url,
                              ),
                            ),
                          );
                        },
                        title: Text(videoUrl.quality.toString()),
                        subtitle: Text(
                          videoUrl.url,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: _youtubeVideoUrls.length,
                  ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(16),
              child: Text(
                "Vimeo URI : https://vimeo.com/6718739",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 15,
                    ),
              ),
            ),
            Text(
              "Vimeo Video Quality Links",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            _vimeoVideoUrls.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final videoUrl = _vimeoVideoUrls[index];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LinkDetailPage(
                                title: '${videoUrl.quality}p',
                                link: videoUrl.url,
                              ),
                            ),
                          );
                        },
                        title: Text(videoUrl.quality.toString()),
                        subtitle: Text(
                          videoUrl.url,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: _vimeoVideoUrls.length,
                  ),
          ],
        ),
      ),
    );
  }
}

class LinkDetailPage extends StatelessWidget {
  const LinkDetailPage({
    super.key,
    required this.title,
    required this.link,
  });

  final String title;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          link,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
