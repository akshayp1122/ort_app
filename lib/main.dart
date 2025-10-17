import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repository/news_repository.dart';
import 'bloc/news_bloc.dart';
import 'bloc/news_event.dart';
import 'screens/news_feed_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => NewsRepository(),
      child: BlocProvider(
        create: (context) =>
            NewsBloc(repository: context.read<NewsRepository>())..add(FetchNews()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ortez App',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
          ),
          home: const NewsFeedPage(),
        ),
      ),
    );
  }
}
