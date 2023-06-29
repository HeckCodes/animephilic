part of 'seasonal_anime_bloc.dart';

class SeasonalAnimeEvent extends Equatable {
  const SeasonalAnimeEvent();

  @override
  List<Object> get props => [];
}

class SeasonalAnimeEventFetchData extends SeasonalAnimeEvent {
  final int year;
  final String season;

  const SeasonalAnimeEventFetchData({
    required this.year,
    required this.season,
  });

  @override
  List<Object> get props => [year, season];
}

class SeasonalAnimeEventLoadData extends SeasonalAnimeEvent {
  final String orderBy;
  final String order;
  final int year;
  final String season;

  const SeasonalAnimeEventLoadData({
    this.orderBy = 'none',
    this.order = 'DESC',
    required this.year,
    required this.season,
  });

  @override
  List<Object> get props => [orderBy, order, year, season];
}
