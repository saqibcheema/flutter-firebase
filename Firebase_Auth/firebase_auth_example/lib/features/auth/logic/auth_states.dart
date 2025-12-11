import 'package:equatable/equatable.dart';

class AuthStates extends Equatable{
  const AuthStates();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthStates{}
class AuthLoading extends AuthStates{}
class AuthSuccess extends AuthStates{}
class AuthLogInSuccess extends AuthStates{}
class AuthSignUpSuccess extends AuthStates{}
class AuthError extends AuthStates{
  final String error;
  const AuthError({required this.error});
  @override
  List<Object?> get props => [error];
}
