part of 'anime_ranking_bloc.dart';

enum AnimeRankingDataState {
  idle,
  fetching,
}

class AnimeRankingState extends Equatable {
  final AnimeRankingDataState state;
  final List<AnimeRankingItem>? animeRankingList;
  final String? nextUrl;

  const AnimeRankingState.idle(this.animeRankingList, this.nextUrl)
      : state = AnimeRankingDataState.idle;
  const AnimeRankingState.fetching({this.animeRankingList, this.nextUrl})
      : state = AnimeRankingDataState.fetching;

  @override
  List<Object?> get props => [state, animeRankingList, nextUrl];
}
