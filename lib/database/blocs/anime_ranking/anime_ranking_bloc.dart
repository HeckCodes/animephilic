import 'dart:convert';

import 'package:animephilic/authentication/authenticaton_exports.dart';
import 'package:animephilic/database/models/anime_ranking_model.dart';
import 'package:animephilic/database/models/field_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:http/http.dart' as http;

part 'anime_ranking_event.dart';
part 'anime_ranking_state.dart';

class AnimeRankingBloc extends Bloc<AnimeRankingEvent, AnimeRankingState> {
  static final AnimeRankingBloc instance = AnimeRankingBloc._private();

  AnimeRankingBloc._private() : super(const AnimeRankingState.idle(null, null)) {
    on<AnimeRankingEventFetchData>(_onFetchData);
    on<AnimeRankingEventFetchNextData>(_onFetchNextData);
  }

  void _onFetchData(
    AnimeRankingEventFetchData event,
    Emitter<AnimeRankingState> emit,
  ) async {
    emit(const AnimeRankingState.fetching());

    http.Response response = await http.get(
      Uri.parse(
          'https://api.myanimelist.net/v2/anime/ranking?ranking_type=${event.rankingType}&limit=20&fields=${AnimeFieldOptions().animeSeasonalFields}'),
      headers: {'Authorization': "Bearer ${Authentication().accessToken}"},
    );
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> animeRankingJsonList = jsonData['data'];
    String nextUrl = jsonData['paging']['next'];

    List<AnimeRankingItem> animeRankingList = List.generate(
      animeRankingJsonList.length,
      (index) => AnimeRankingItem.fromJSON(animeRankingJsonList[index]),
    );

    emit(AnimeRankingState.idle(animeRankingList, nextUrl));
  }

  void _onFetchNextData(
    AnimeRankingEventFetchNextData event,
    Emitter<AnimeRankingState> emit,
  ) async {
    http.Response response = await http.get(
      Uri.parse(event.nextUrl ??
          'https://api.myanimelist.net/v2/anime/ranking?ranking_type=${event.rankingType}&limit=20&fields=${AnimeFieldOptions().animeSeasonalFields}'),
      headers: {'Authorization': "Bearer ${Authentication().accessToken}"},
    );

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> animeRankingJsonList = jsonData['data'];
    String nextUrl = jsonData['paging']['next'];

    List<AnimeRankingItem> animeRankingList = List.generate(
      animeRankingJsonList.length,
      (index) => AnimeRankingItem.fromJSON(animeRankingJsonList[index]),
    );

    emit(AnimeRankingState.idle(
      (event.animeRankingList ?? []) + animeRankingList,
      nextUrl,
    ));
  }
}
