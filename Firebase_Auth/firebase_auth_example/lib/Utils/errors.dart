import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/Utils/utils.dart';

void exceptionThrow(Object? e){
  final String message;
  if(e is FirebaseAuthException){
    if (e.code == "user-not-found") {
      message = "No user found for that email";
    } else if (e.code == "wrong-password") {
      message = "Wrong password provided for that user";
    } else {
      message = "Something went wrong ${e.toString()}";
    }
    Utils().toastMessage(message);
  }else{
    message = "UnKnown Error ${e.toString()}";
    Utils().toastMessage(message);
  }
}
