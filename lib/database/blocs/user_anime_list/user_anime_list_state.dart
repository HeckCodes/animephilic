part of 'user_anime_list_bloc.dart';

enum UserAnimeListDataState {
  idle,
  fetching,
}

class UserAnimeListState extends Equatable {
  final UserAnimeListDataState state;
  final List<UserAnimeListItem>? userAnimeList;

  const UserAnimeListState.idle(this.userAnimeList)
      : state = UserAnimeListDataState.idle;
  const UserAnimeListState.fetching({this.userAnimeList})
      : state = UserAnimeListDataState.fetching;

  @override
  List<Object?> get props => [state, userAnimeList];
}
