part of 'user_account_information_bloc.dart';

abstract class UserAccountInformationState extends Equatable {
  const UserAccountInformationState();
  
  @override
  List<Object> get props => [];
}

class UserAccountInformationInitial extends UserAccountInformationState {}
