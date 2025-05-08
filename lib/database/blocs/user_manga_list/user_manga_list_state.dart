part of 'user_manga_list_bloc.dart';

enum UserMangaListDataState {
  idle,
  fetching,
}

class UserMangaListState extends Equatable {
  final UserMangaListDataState state;
  final List<UserMangaListItem>? userMangaList;

  const UserMangaListState.idle(this.userMangaList)
      : state = UserMangaListDataState.idle;
  const UserMangaListState.fetching({this.userMangaList})
      : state = UserMangaListDataState.fetching;

  @override
  List<Object?> get props => [state, userMangaList];
}
