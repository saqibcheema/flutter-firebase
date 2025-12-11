import 'package:equatable/equatable.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthSignUpRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email,password];
}

class AuthLogInRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLogInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();

  @override
  List<Object?> get props => [];
}

class AuthSignOut extends AuthEvent{
  const AuthSignOut();

  @override
  List<Object?> get props => [];
}
