import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import 'article_detail_page.dart';
import 'package:intl/intl.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(FetchNews());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Top Headlines'),
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<NewsBloc>().add(RefreshNews());
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.amber),
                    onPressed: () {
                      context
                          .read<NewsBloc>()
                          .add(SearchNews(_searchController.text));
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<NewsBloc, NewsState>(
                builder: (context, state) {
                  if (state is NewsLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.amber));
                  } else if (state is NewsLoaded) {
                    return ListView.builder(
                      itemCount: state.articles.length,
                      itemBuilder: (context, index) {
                        final article = state.articles[index];
                        final formattedDate = article.publishedAt != null
                            ? DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(article.publishedAt!))
                            : '';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ArticleDetailPage(article: article),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.grey[900],
                            margin: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (article.urlToImage != null)
                                  Hero(
                                    tag: article.urlToImage!,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                      child: Image.network(article.urlToImage!,
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(article.title,
                                          style: const TextStyle(
                                              color: Colors.amber,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 6),
                                      Text(article.description ?? 'No description',
                                          style: const TextStyle(color: Colors.white70)),
                                      const SizedBox(height: 6),
                                      Text(formattedDate,
                                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is NewsError) {
                    return Center(
                        child: Text(state.message,
                            style: const TextStyle(color: Colors.redAccent)));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
