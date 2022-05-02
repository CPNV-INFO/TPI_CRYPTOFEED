import 'dart:convert';

TotalResults TotalResultsFromJson(String str) =>
    TotalResults.fromJson(json.decode(str));

NewsData NewsDataFromJson(String str) => NewsData.fromJson(json.decode(str));
//String NewsDataToJson(NewsData data) => json.encode(data.toJson());

class TotalResults {
  TotalResults({required this.totalResults});

  String totalResults;

  factory TotalResults.fromJson(Map<String, dynamic> json) => TotalResults(
        totalResults: json['totalResults'].toString(),
      );
}

class NewsData {
  NewsData({
    required this.articles,
  });

  List<News> articles;

  factory NewsData.fromJson(Map<String, dynamic> json) => NewsData(
        articles:
            List<News>.from(json['articles'].map((x) => News.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };
}

class News {
  News({
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.urlToImage,
    required this.url,
    required this.content,
    required this.author,
    required this.source,
  });

  String title;
  String description;
  String publishedAt;
  String urlToImage;
  String url;
  String content;
  String author;
  Source source;

  factory News.fromJson(Map<String, dynamic> json) => News(
        title: json['title'].toString(),
        description: json['description'].toString(),
        publishedAt: json['publishedAt'].toString(),
        urlToImage: json['urlToImage'].toString(),
        url: json['url'].toString(),
        content: json['content'].toString(),
        author: json['author'].toString(),
        source: Source.fromJson(json['source']),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "publishedAt": publishedAt,
        "urlToImage": urlToImage,
        "url": url,
        "content": content,
        "author": author,
        "source": source,
      };
}

class Source {
  Source({
    required this.name,
  });

  String name;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
