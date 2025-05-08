part of 'user_account_information_bloc.dart';

class UserAccountInformationEvent extends Equatable {
  const UserAccountInformationEvent();

  @override
  List<Object?> get props => [];
}

/// To get data from API
class UserAccountInformationEventFetchData
    extends UserAccountInformationEvent {}

/// To get data from DB
class UserAccountInformationEventLoadData extends UserAccountInformationEvent {}
