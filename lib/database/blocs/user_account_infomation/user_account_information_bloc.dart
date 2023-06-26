import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_account_information_event.dart';
part 'user_account_information_state.dart';

class UserAccountInformationBloc
    extends Bloc<UserAccountInformationEvent, UserAccountInformationState> {
  UserAccountInformationBloc() : super(UserAccountInformationInitial()) {
    on<UserAccountInformationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
