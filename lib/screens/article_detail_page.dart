import 'package:flutter/material.dart';
import 'package:ort_app/models/article.dart';
import 'package:intl/intl.dart';

class ArticleDetailPage extends StatelessWidget {
  final Article article;
  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final formattedDate = article.publishedAt != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(article.publishedAt!))
        : '';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(article.sourceName ?? 'Article'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              Hero(
                tag: article.urlToImage!,
                child: Image.network(article.urlToImage!,
                    height: 250, width: double.infinity, fit: BoxFit.cover),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.title,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber)),
                  const SizedBox(height: 8),
                  Text("By ${article.author ?? 'Unknown'} • $formattedDate",
                      style: const TextStyle(color: Colors.white70)),
                  const Divider(color: Colors.amber),
                  Text(article.content ?? "No content available",
                      style: const TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
