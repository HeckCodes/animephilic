part of 'manga_ranking_bloc.dart';

class MangaRankingEvent extends Equatable {
  const MangaRankingEvent();

  @override
  List<Object?> get props => [];
}

class MangaRankingEventFetchData extends MangaRankingEvent {
  final String rankingType;

  const MangaRankingEventFetchData({required this.rankingType});

  @override
  List<Object> get props => [rankingType];
}

class MangaRankingEventFetchNextData extends MangaRankingEvent {
  final String? nextUrl;
  final List<MangaRankingItem>? mangaRankingList;
  final String rankingType;

  const MangaRankingEventFetchNextData({
    required this.nextUrl,
    required this.mangaRankingList,
    required this.rankingType,
  });

  @override
  List<Object?> get props => [nextUrl, mangaRankingList, rankingType];
}
