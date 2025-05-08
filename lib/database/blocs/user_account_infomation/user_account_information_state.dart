part of 'user_account_information_bloc.dart';

enum UserDataState {
  idle,
  fetching,
}

class UserAccountInformationState extends Equatable {
  final UserDataState state;
  final User? user;
  final Stat? stat;

  const UserAccountInformationState.idle(this.user, this.stat)
      : state = UserDataState.idle;
  const UserAccountInformationState.fetching({this.user, this.stat})
      : state = UserDataState.fetching;

  @override
  List<Object?> get props => [state, user, stat];
}
