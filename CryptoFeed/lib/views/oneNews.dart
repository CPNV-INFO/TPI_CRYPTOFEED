import 'package:flutter/material.dart';
import 'package:untitled2/data/all.dart';
import 'package:url_launcher/url_launcher.dart' as url;

class OneNewsPage extends StatefulWidget {
  final Source source;
  final String url;
  final String urlToImage;
  final String title;
  final String publishedAt;
  final String content;
  final String description;
  final String author;

  OneNewsPage(this.source, this.url, this.urlToImage, this.title,
      this.publishedAt, this.content, this.description, this.author);

  @override
  State<OneNewsPage> createState() => _OneNewsPageState();
}

class _OneNewsPageState extends State<OneNewsPage> {
  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);
    if (diff.inDays >= 1) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays == 1) {
      return 'a day ago';
    } else if (diff.inHours > 1) {
      return '${diff.inHours} hours ago';
    } else if (diff.inHours == 1) {
      return 'an hour ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inMinutes == 1) {
      return 'a minute ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} seconds ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime ago = DateTime.parse(widget.publishedAt);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.source.name),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text(
                widget.title,
                style: const TextStyle(fontSize: 23),
              ),
              subtitle: TextButton(
                  onPressed: () {
                    url.launch(widget.url,
                        forceWebView: true, enableJavaScript: true);
                  },
                  child: const Text('Click to open in navigator')),
            ),
          ),
          Image.network(
            widget.urlToImage,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.amber,
                alignment: Alignment.center,
                child: const Text(
                  'Cannot load the image',
                  style: TextStyle(fontSize: 30),
                ),
              );
            },
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
          Card(
            child: ListTile(
              title: Text(widget.content),
            ),
          ),
          Text('Posted ' + convertToAgo(ago)),
          widget.author != "null"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Article written by "),
                    Text(
                      widget.author,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )
              : const Text("Unknown author...")
        ],
      ),
    );
  }
}
