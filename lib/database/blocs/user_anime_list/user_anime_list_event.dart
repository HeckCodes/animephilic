part of 'user_anime_list_bloc.dart';

class UserAnimeListEvent extends Equatable {
  const UserAnimeListEvent();

  @override
  List<Object> get props => [];
}

class UserAnimeListEventFetchData extends UserAnimeListEvent {}

class UserAnimeListEventLoadData extends UserAnimeListEvent {}
