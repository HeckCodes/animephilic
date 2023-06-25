part of 'authentication_handler_bloc_bloc.dart';

class AuthenticationHandlerBlocEvent extends Equatable {
  const AuthenticationHandlerBlocEvent();

  @override
  List<Object> get props => [];
}

class LoggedInAuthenticationHandlerBlocEvent
    extends AuthenticationHandlerBlocEvent {
  final AuthenticationStatus status;

  const LoggedInAuthenticationHandlerBlocEvent(this.status);

  @override
  List<Object> get props => [status];
}
