part of 'authentication_handler_bloc_bloc.dart';

enum AuthenticationStatus {
  loggedIn,
  loggedOut,
}

class AuthenticationHandlerBlocState extends Equatable {
  final AuthenticationStatus status;

  const AuthenticationHandlerBlocState._(
      {this.status = AuthenticationStatus.loggedOut});

  const AuthenticationHandlerBlocState.loggedIn(AuthenticationStatus status)
      : this._(status: status);

  const AuthenticationHandlerBlocState.loggedOut(AuthenticationStatus status)
      : this._(status: status);

  @override
  List<Object> get props => [status];
}
