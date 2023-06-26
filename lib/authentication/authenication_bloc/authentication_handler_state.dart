part of 'authentication_handler_bloc.dart';

enum AuthenticationStatus {
  loggedIn,
  loggedOut,
}

class AuthenticationHandlerState extends Equatable {
  final AuthenticationStatus status;

  const AuthenticationHandlerState._(
      {this.status = AuthenticationStatus.loggedOut});

  const AuthenticationHandlerState.loggedIn(AuthenticationStatus status)
      : this._(status: status);

  const AuthenticationHandlerState.loggedOut(AuthenticationStatus status)
      : this._(status: status);

  @override
  List<Object> get props => [status];
}
