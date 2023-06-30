part of 'anime_ranking_bloc.dart';

class AnimeRankingEvent extends Equatable {
  const AnimeRankingEvent();

  @override
  List<Object> get props => [];
}

class AnimeRankingEventFetchData extends AnimeRankingEvent {
  final String rankingType;

  const AnimeRankingEventFetchData({required this.rankingType});

  @override
  List<Object> get props => [rankingType];
}

class AnimeRankingEventFetchNextData extends AnimeRankingEvent {
  final String nextUrl;
  final List<AnimeRankingItem> animeRankingList;

  const AnimeRankingEventFetchNextData(
      {required this.nextUrl, required this.animeRankingList});

  @override
  List<Object> get props => [nextUrl, animeRankingList];
}
