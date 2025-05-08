part of 'authentication_handler_bloc.dart';

class AuthenticationHandlerEvent extends Equatable {
  const AuthenticationHandlerEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationHandlerEventLoggedIn extends AuthenticationHandlerEvent {
  final AuthenticationStatus status;

  const AuthenticationHandlerEventLoggedIn(this.status);

  @override
  List<Object> get props => [status];
}
