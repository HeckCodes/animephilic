import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_handler_bloc_event.dart';
part 'authentication_handler_bloc_state.dart';

class AuthenticationHandlerBloc extends Bloc<AuthenticationHandlerBlocEvent,
    AuthenticationHandlerBlocState> {
  AuthenticationHandlerBloc()
      : super(const AuthenticationHandlerBlocState.loggedOut(
            AuthenticationStatus.loggedOut)) {
    on<LoggedInAuthenticationHandlerBlocEvent>((event, emit) {
      emit(AuthenticationHandlerBlocState.loggedIn(event.status));
    });
  }
}
