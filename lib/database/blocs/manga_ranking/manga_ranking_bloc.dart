import 'dart:convert';

import 'package:animephilic/authentication/authentication_exports.dart';
import 'package:animephilic/database/models/manga_ranking_model.dart';
import 'package:animephilic/database/models/field_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:http/http.dart' as http;

part 'manga_ranking_event.dart';
part 'manga_ranking_state.dart';

class MangaRankingBloc extends Bloc<MangaRankingEvent, MangaRankingState> {
  static final MangaRankingBloc instance = MangaRankingBloc._private();

  MangaRankingBloc._private() : super(const MangaRankingState.idle(null, null)) {
    on<MangaRankingEventFetchData>(_onFetchData);
    on<MangaRankingEventFetchNextData>(_onFetchNextData);
  }

  void _onFetchData(
    MangaRankingEventFetchData event,
    Emitter<MangaRankingState> emit,
  ) async {
    emit(const MangaRankingState.fetching());

    http.Response response = await http.get(
      Uri.parse(
          'https://api.myanimelist.net/v2/manga/ranking?ranking_type=${event.rankingType}&limit=20&fields=${AnimeFieldOptions().animeSeasonalFields}'),
      headers: {'Authorization': "Bearer ${Authentication().accessToken}"},
    );
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> mangaRankingJsonList = jsonData['data'];
    String nextUrl = jsonData['paging']['next'];

    List<MangaRankingItem> mangaRankingList = List.generate(
      mangaRankingJsonList.length,
      (index) => MangaRankingItem.fromJSON(mangaRankingJsonList[index]),
    );

    emit(MangaRankingState.idle(mangaRankingList, nextUrl));
  }

  void _onFetchNextData(
    MangaRankingEventFetchNextData event,
    Emitter<MangaRankingState> emit,
  ) async {
    http.Response response = await http.get(
      Uri.parse(event.nextUrl ??
          'https://api.myanimelist.net/v2/manga/ranking?ranking_type=${event.rankingType}&limit=20&fields=${AnimeFieldOptions().animeSeasonalFields}'),
      headers: {'Authorization': "Bearer ${Authentication().accessToken}"},
    );

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> mangaRankingJsonList = jsonData['data'];
    String nextUrl = jsonData['paging']['next'];

    List<MangaRankingItem> mangaRankingList = List.generate(
      mangaRankingJsonList.length,
      (index) => MangaRankingItem.fromJSON(mangaRankingJsonList[index]),
    );

    emit(MangaRankingState.idle(
      (event.mangaRankingList ?? []) + mangaRankingList,
      nextUrl,
    ));
  }
}
