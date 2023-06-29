import 'dart:convert';

import 'package:animephilic/authentication/authenticaton_exports.dart';
import 'package:animephilic/database/database_operations.dart';
import 'package:animephilic/database/models/user_manga_list_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:http/http.dart' as http;

part 'user_manga_list_event.dart';
part 'user_manga_list_state.dart';

class UserMangaListBloc extends Bloc<UserMangaListEvent, UserMangaListState> {
  static final UserMangaListBloc instance = UserMangaListBloc._private();

  final DatabaseOperations _databaseOperations = DatabaseOperations.instance;

  UserMangaListBloc._private() : super(const UserMangaListState.idle(null)) {
    on<UserMangaListEventFetchData>(_onFetchData);
    on<UserMangaListEventLoadData>(_onLoadData);
  }

  void _onFetchData(
    UserMangaListEventFetchData event,
    Emitter<UserMangaListState> emit,
  ) async {
    emit(const UserMangaListState.fetching());
    http.Response response = await http.get(
      Uri.parse(
          'https://api.myanimelist.net/v2/users/@me/mangalist?fields=list_status&limit=999'),
      headers: {'Authorization': "Bearer ${Authentication().accessToken}"},
    );
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> userMangaJsonList = jsonData['data'];
    List<UserMangaListItem> userMangaList = List.generate(
      userMangaJsonList.length,
      (index) => UserMangaListItem.fromJSON(userMangaJsonList[index]),
    );

    _databaseOperations.updateUserMangaList(userMangaList);

    emit(UserMangaListState.idle(userMangaList));
  }

  void _onLoadData(
    UserMangaListEventLoadData event,
    Emitter<UserMangaListState> emit,
  ) async {
    emit(const UserMangaListState.fetching());
    List<UserMangaListItem> userMangaList =
        await _databaseOperations.getUserMangaList(
      status: event.status,
      order: event.order,
      orderBy: event.orderBy,
    );
    emit(UserMangaListState.idle(userMangaList));
  }
}
