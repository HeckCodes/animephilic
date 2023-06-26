import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_handler_event.dart';
part 'authentication_handler_state.dart';

class AuthenticationHandlerBloc
    extends Bloc<AuthenticationHandlerEvent, AuthenticationHandlerState> {
  AuthenticationHandlerBloc()
      : super(const AuthenticationHandlerState.loggedOut(
            AuthenticationStatus.loggedOut)) {
    on<AuthenticationHandlerEventLoggedIn>((event, emit) {
      emit(AuthenticationHandlerState.loggedIn(event.status));
    });
  }
}
