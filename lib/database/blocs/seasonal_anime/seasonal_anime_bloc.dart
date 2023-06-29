import 'dart:convert';

import 'package:animephilic/authentication/authenticaton_exports.dart';
import 'package:animephilic/database/database_operations.dart';
import 'package:animephilic/database/models/field_options.dart';
import 'package:animephilic/database/models/seasonal_anime_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:http/http.dart' as http;

part 'seasonal_anime_event.dart';
part 'seasonal_anime_state.dart';

class SeasonalAnimeBloc extends Bloc<SeasonalAnimeEvent, SeasonalAnimeState> {
  static final SeasonalAnimeBloc instance = SeasonalAnimeBloc._private();

  final DatabaseOperations _databaseOperations = DatabaseOperations.instance;

  SeasonalAnimeBloc._private() : super(const SeasonalAnimeState.idle(null)) {
    on<SeasonalAnimeEventFetchData>(_onFetchData);
    on<SeasonalAnimeEventLoadData>(_onLoadData);
  }

  void _onFetchData(
    SeasonalAnimeEventFetchData event,
    Emitter<SeasonalAnimeState> emit,
  ) async {
    emit(const SeasonalAnimeState.fetching());

    http.Response response = await http.get(
      Uri.parse(
          'https://api.myanimelist.net/v2/anime/season/${event.year}/${event.season}?limit=499&fields=${AnimeFieldOptions().animeSeasonalFields}'),
      headers: {'Authorization': "Bearer ${Authentication().accessToken}"},
    );
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> seasonalAnimeJsonList = jsonData['data'];

    List<SeasonalAnimeItem> seasonalAnimeList = List.generate(
      seasonalAnimeJsonList.length,
      (index) => SeasonalAnimeItem.fromJSON(
        seasonalAnimeJsonList[index],
        event.year,
        event.season,
      ),
    );

    Future.forEach(seasonalAnimeList,
        (item) => _databaseOperations.updateSeasonalAnime(item));

    emit(SeasonalAnimeState.idle(seasonalAnimeList));
  }

  void _onLoadData(
    SeasonalAnimeEventLoadData event,
    Emitter<SeasonalAnimeState> emit,
  ) async {
    emit(const SeasonalAnimeState.fetching());
    List<SeasonalAnimeItem> seasonalAnimeList =
        await _databaseOperations.getSeasonalAnimeList(
      order: event.order,
      orderBy: event.orderBy,
      year: event.year,
      season: event.season,
    );
    emit(SeasonalAnimeState.idle(seasonalAnimeList));
  }
}
