import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ort_app/models/article.dart';

class NewsRepository {
  final String _baseUrl = "https://newsapi.org/v2/top-headlines?country=us&apiKey=3c908d66c17e479980705eaf3ffff95a";

  Future<List<Article>> fetchNews({int page = 1}) async {
    final response = await http.get(Uri.parse("$_baseUrl&page=$page"));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List articles = jsonData['articles'];
      return articles.map((a) => Article.fromJson(a)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
