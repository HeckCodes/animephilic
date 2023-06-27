import 'dart:convert';

import 'package:animephilic/authentication/authenticaton_exports.dart';
import 'package:animephilic/database/database_operations.dart';
import 'package:animephilic/database/models/user_anime_list_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:http/http.dart' as http;

part 'user_anime_list_event.dart';
part 'user_anime_list_state.dart';

class UserAnimeListBloc extends Bloc<UserAnimeListEvent, UserAnimeListState> {
  static final UserAnimeListBloc instance = UserAnimeListBloc._private();

  final DatabaseOperations _databaseOperations = DatabaseOperations.instance;

  UserAnimeListBloc._private() : super(const UserAnimeListState.idle(null)) {
    on<UserAnimeListEventFetchData>(_onFetchData);
    on<UserAnimeListEventLoadData>(_onLoadData);
  }

  void _onFetchData(
    UserAnimeListEventFetchData event,
    Emitter<UserAnimeListState> emit,
  ) async {
    emit(const UserAnimeListState.fetching());
    http.Response response = await http.get(
      Uri.parse(
          'https://api.myanimelist.net/v2/users/@me/animelist?fields=list_status&limit=999'),
      headers: {'Authorization': "Bearer ${Authentication().accessToken}"},
    );
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> userAnimeJsonList = jsonData['data'];
    List<UserAnimeListItem> userAnimeList = List.generate(
      userAnimeJsonList.length,
      (index) => UserAnimeListItem.fromJSON(userAnimeJsonList[index]),
    );

    Future.forEach(
        userAnimeList, (item) => _databaseOperations.updateUserAnime(item));

    emit(UserAnimeListState.idle(userAnimeList));
  }

  void _onLoadData(
    UserAnimeListEventLoadData event,
    Emitter<UserAnimeListState> emit,
  ) async {
    emit(const UserAnimeListState.fetching());
    List<UserAnimeListItem> userAnimeList =
        await _databaseOperations.getUserAnimeList(
      status: event.status,
      order: event.order,
      orderBy: event.orderBy,
    );
    emit(UserAnimeListState.idle(userAnimeList));
  }
}
