import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/core/errors/failures.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../errors/authFailures.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _fireStore;

  AuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn, FirebaseFirestore? fireStore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _fireStore = fireStore ?? FirebaseFirestore.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromCode(e.code);
    } on SocketException{
      throw NetworkFailure();
    } catch (e) {
      throw ServerFailure();
    }
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential result = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromCode(e.code);
    } on SocketException{
      throw NetworkFailure();
    } catch (e) {
      throw ServerFailure();
    }
  }

    Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromCode(e.code);
    } on SocketException{
      throw NetworkFailure();
    } catch (e) {
      throw ServerFailure();
    }
  }

  Future<void> signOut() async {
    try{
      final User? user = _firebaseAuth.currentUser;
      if(user!=null){
        bool isGoogleUser = user.providerData.any((info) => info.providerId == 'google.com');
        if(isGoogleUser){
          try{
            await _googleSignIn.signOut();
          }catch (e){
            throw ServerFailure();
          }
        }
      }
      await _firebaseAuth.signOut();
    }on FirebaseAuthException catch (e) {
      throw AuthFailure.fromCode(e.code);
    } on SocketException{
      throw NetworkFailure();
    } catch (e) {
      throw ServerFailure();
    }
  }

  Future<void> saveUserToFireStore(User user,{String? displayName})async{
    final userDoc = _fireStore.collection("Users").doc(user.uid);
    
    final generatedUserName = user.email!.split('@')[0];

    final docSnapShot = await userDoc.get();
    if(!docSnapShot.exists){
      await userDoc.set({
        "uid" : user.uid,
        "email" : user.email,
        "displayName" : displayName ?? user.displayName ?? generatedUserName,
        "searchName" : (displayName ?? user.displayName ?? generatedUserName).toLowerCase(),
        "createdAt" : FieldValue.serverTimestamp(),
        "profilePhoto" : user.photoURL ?? "https://placeholder.com/user_avatar.png"
      });
    }
  }

}
