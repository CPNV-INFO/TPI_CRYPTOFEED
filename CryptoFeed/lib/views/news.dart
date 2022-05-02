import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/data/all.dart';
import 'package:untitled2/widget/all.dart';
import 'package:untitled2/views/all.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  static List<News> _news = [];
  int currentPage = 1;
  RefreshController controller = RefreshController(initialRefresh: true);
  final ScrollController _scrollController = ScrollController();

  Future<bool> getNews({bool isRefresh = false}) async {
    final response = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=crypto&apiKey=e05f822b086d44e7886db0ebbe4d54f6&page=$currentPage&pageSize=10&sortBy=publishedAt"));

    final totalResults = TotalResultsFromJson(response.body);
    final totalPages = int.parse(totalResults.totalResults) / 10;

    if (currentPage >= totalPages) {
      controller.loadNoData();
      return false;
    }

    if (response.statusCode == 200) {
      final result = NewsDataFromJson(response.body);

      if (isRefresh == true) {
        _news = result.articles;
      } else if (isRefresh == false) {
        _news.addAll(result.articles);
      }

      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  Widget _buildNews() {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Go back to top'),
        onPressed: () {
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn);
          });
        },
        icon: const Icon(Icons.arrow_upward),
      ),
      body: SmartRefresher(
        controller: controller,
        enablePullUp: true,
        onRefresh: () async {
          currentPage = 1;
          final result = await getNews(isRefresh: true);
          if (result) {
            controller.refreshCompleted();
          } else {
            controller.refreshFailed();
          }
        },
        onLoading: () async {
          currentPage++;
          final result = await getNews(isRefresh: false);
          if (result) {
            controller.loadComplete();
          } else {
            controller.loadFailed();
          }
          LoadStyle.ShowWhenLoading;
        },
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          itemCount: _news.length,
          itemBuilder: (context, index) {
            final news = _news[index];
            return Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(news.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(news.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => OneNewsPage(
                                news.source,
                                news.url,
                                news.urlToImage,
                                news.title,
                                news.publishedAt,
                                news.content,
                                news.description,
                                news.author),
                            transitionsBuilder: (c, anim, a2, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration:
                                const Duration(milliseconds: 200)),
                      );
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('News Feed'),
        centerTitle: true,
        /*actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],*/
      ),
      body: _buildNews(),
    );
  }
}
