part of 'user_anime_list_bloc.dart';

class UserAnimeListEvent extends Equatable {
  const UserAnimeListEvent();

  @override
  List<Object> get props => [];
}

class UserAnimeListEventFetchData extends UserAnimeListEvent {}

class UserAnimeListEventLoadData extends UserAnimeListEvent {
  final String status;
  final String orderBy;
  final String order;

  const UserAnimeListEventLoadData({
    this.status = "all",
    this.orderBy = 'none',
    this.order = 'DESC',
  });

  @override
  List<Object> get props => [status, orderBy, order];
}
