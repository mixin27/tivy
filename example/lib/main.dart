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
  VimeoVideo? _videoInfo;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() async {
    final videoInfo = await tivy.getVimeoVideoInfo(
      'your_vimeo_video_url',
    );

    final result = await tivy.getVimeoVideoQualityUrls(
      'your_vimeo_video_url',
    );
    setState(() {
      _videoInfo = videoInfo;
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
          if (_videoInfo != null) ...[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(16),
              child: Text(
                "URI : ${_videoInfo!.uri}",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 10),
            Image.network(_videoInfo!.thumbnailUrl),
            const SizedBox(height: 10),
          ],
          Text(
            "Quality",
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
