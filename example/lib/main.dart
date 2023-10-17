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
  List<VideoQalityUrl> _videoUrls = [];

  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() async {
    final result = await tivy.getYouTubeVideoQualityUrls(
      'https://www.youtube.com/watch?v=_EYk-E29edo',
    );

    setState(() {
      _videoUrls = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(16),
            child: Text(
              "URI : https://www.youtube.com/watch?v=_EYk-E29edo",
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontSize: 15,
                  ),
            ),
          ),
          Text(
            "Video Quality Links",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Expanded(
            child: _videoUrls.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) {
                      final videoUrl = _videoUrls[index];
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
                    itemCount: _videoUrls.length,
                  ),
          ),
        ],
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
