part of 'manga_ranking_bloc.dart';

enum MangaRankingDataState {
  idle,
  fetching,
}

class MangaRankingState extends Equatable {
  final MangaRankingDataState state;
  final List<MangaRankingItem>? mangaRankingList;
  final String? nextUrl;

  const MangaRankingState.idle(this.mangaRankingList, this.nextUrl) : state = MangaRankingDataState.idle;
  const MangaRankingState.fetching({this.mangaRankingList, this.nextUrl}) : state = MangaRankingDataState.fetching;

  @override
  List<Object?> get props => [state, mangaRankingList, nextUrl];
}
