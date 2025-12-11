import 'package:bloc/bloc.dart';
import 'package:firebase_auth_example/features/auth/data/repository/auth_repository.dart';
import 'package:firebase_auth_example/features/auth/logic/auth_events.dart';
import 'package:firebase_auth_example/features/auth/logic/auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthStates> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthSignUpRequested>((event, emit)async {
      emit(AuthLoading());
      try {
        await authRepository.signUpWithEmailPassword(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(error: e.toString()));
      }
    });

    on<AuthLogInRequested>((event, emit) async{
      emit(AuthLoading());
      try {
        await authRepository.signInWithEmailPassword(event.email, event.password);
        emit(AuthLogInSuccess());
      } catch (e) {
        emit(AuthError(error: e.toString()));
      }
    });

    on<AuthGoogleSignInRequested>((event, emit) async{
      emit(AuthLoading());
      try{
        await authRepository.signInWithGoogle();
        emit(AuthSignUpSuccess());
      }catch (e){
        emit(AuthError(error: e.toString()));
      }
    });

    on<AuthSignOut>((event,emit)async{
      emit(AuthLoading());
      try{
        await authRepository.signOut();
        emit(AuthSuccess());
      }catch (e){
        emit(AuthError(error: e.toString()));
      }
    });
  }
}
