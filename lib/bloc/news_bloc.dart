import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/news_repository.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repository;

  NewsBloc({required this.repository}) : super(NewsInitial()) {
    on<FetchNews>(_onFetchNews);
    on<RefreshNews>(_onRefreshNews);
    on<SearchNews>(_onSearchNews);
  }

  Future<void> _onFetchNews(FetchNews event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final articles = await repository.fetchNews();
      emit(NewsLoaded(articles));
    } catch (e) {
      emit(NewsError("Failed to load news: $e"));
    }
  }

  Future<void> _onRefreshNews(RefreshNews event, Emitter<NewsState> emit) async {
    try {
      final articles = await repository.fetchNews();
      emit(NewsLoaded(articles));
    } catch (e) {
      emit(NewsError("Failed to refresh news: $e"));
    }
  }

  Future<void> _onSearchNews(SearchNews event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final articles = await repository.fetchNews();
      final filtered = articles
          .where((a) =>
              a.title.toLowerCase().contains(event.query.toLowerCase()) ||
              (a.description ?? '').toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(NewsLoaded(filtered));
    } catch (e) {
      emit(NewsError("Search failed: $e"));
    }
  }
}
