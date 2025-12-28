import 'package:bloc/bloc.dart';
import 'package:firebase_auth_example/core/errors/failures.dart';
import 'package:firebase_auth_example/features/auth/data/repository/auth_repository.dart';
import 'package:firebase_auth_example/features/auth/logic/auth_events.dart';
import 'package:firebase_auth_example/features/auth/logic/auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthStates> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthSignUpRequested>((event, emit)async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signUpWithEmailPassword(event.email, event.password);
        if(user!=null){
          await authRepository.saveUserToFireStore(user);
        }
        emit(AuthSuccess());
      }on Failure catch(e){
        emit(AuthError(error: e.message));
      } catch (e) {
        emit(AuthError(error: e.toString()));
      }
    });

    on<AuthLogInRequested>((event, emit) async{
      emit(AuthLoading());
      try {
        await authRepository.signInWithEmailPassword(event.email, event.password);
        emit(AuthLogInSuccess());
      }on Failure catch(e){
        emit(AuthError(error: e.message));
      } catch (e) {
        emit(AuthError(error: e.toString()));
      }
    });

    on<AuthGoogleSignInRequested>((event, emit) async{
      emit(AuthLoading());
      try{
        final user = await authRepository.signInWithGoogle();
        if(user!=null){
          await authRepository.saveUserToFireStore(user);
        }
        emit(AuthSignUpSuccess());
      }on Failure catch(e){
        emit(AuthError(error: e.message));
      } catch (e){
        emit(AuthError(error: e.toString()));
      }
    });

    on<AuthSignOut>((event,emit)async{
      emit(AuthLoading());
      try{
        await authRepository.signOut();
        emit(AuthSuccess());
      }on Failure catch(e){
        emit(AuthError(error: e.message));
      } catch (e){
        emit(AuthError(error: e.toString()));
      }
    });
  }
}
