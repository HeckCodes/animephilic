part of 'user_manga_list_bloc.dart';

class UserMangaListEvent extends Equatable {
  const UserMangaListEvent();

  @override
  List<Object> get props => [];
}

class UserMangaListEventFetchData extends UserMangaListEvent {}

class UserMangaListEventLoadData extends UserMangaListEvent {
  final String status;
  final String orderBy;
  final String order;

  const UserMangaListEventLoadData({
    this.status = "all",
    this.orderBy = 'none',
    this.order = 'DESC',
  });

  @override
  List<Object> get props => [status, orderBy, order];
}
