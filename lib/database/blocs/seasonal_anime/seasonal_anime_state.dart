part of 'seasonal_anime_bloc.dart';

enum SeasonalAnimeDataState {
  idle,
  fetching,
}

class SeasonalAnimeState extends Equatable {
  final SeasonalAnimeDataState state;
  final List<SeasonalAnimeItem>? seasonalAnimeList;

  const SeasonalAnimeState.idle(this.seasonalAnimeList)
      : state = SeasonalAnimeDataState.idle;
  const SeasonalAnimeState.fetching({this.seasonalAnimeList})
      : state = SeasonalAnimeDataState.fetching;

  @override
  List<Object?> get props => [state, seasonalAnimeList];
}
