import 'dart:convert';

import 'package:animephilic/authentication/authentication_exports.dart';
import 'package:animephilic/database/database_operations.dart';
import 'package:animephilic/database/models/stat_model.dart';
import 'package:animephilic/database/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:http/http.dart' as http;

part 'user_account_information_event.dart';
part 'user_account_information_state.dart';

class UserAccountInformationBloc extends Bloc<UserAccountInformationEvent, UserAccountInformationState> {
  static final UserAccountInformationBloc instance = UserAccountInformationBloc._private();

  final DatabaseOperations _databaseOperations = DatabaseOperations.instance;

  UserAccountInformationBloc._private() : super(const UserAccountInformationState.idle(null, null)) {
    on<UserAccountInformationEventFetchData>(_onFetchData);
    on<UserAccountInformationEventLoadData>(_onLoadData);
  }

  void _onFetchData(
    UserAccountInformationEventFetchData event,
    Emitter<UserAccountInformationState> emit,
  ) async {
    emit(const UserAccountInformationState.fetching());
    http.Response response = await http.get(
      Uri.parse('https://api.myanimelist.net/v2/users/@me?fields=anime_statistics'),
      headers: {'Authorization': "Bearer ${Authentication().accessToken}"},
    );
    Map<String, dynamic> userData = jsonDecode(response.body);
    Map<String, dynamic> userStat = userData['anime_statistics'];

    User user = User.fromJSON(userData);
    Stat stat = Stat.fromJSON(userStat);

    _databaseOperations.updateUserData(user);
    _databaseOperations.updateUserStat(stat);

    emit(UserAccountInformationState.idle(user, stat));
  }

  void _onLoadData(
    UserAccountInformationEventLoadData event,
    Emitter<UserAccountInformationState> emit,
  ) async {
    emit(const UserAccountInformationState.fetching());
    User user = await _databaseOperations.getUserData();
    Stat stat = await _databaseOperations.getUserStat();
    emit(UserAccountInformationState.idle(user, stat));
  }
}
