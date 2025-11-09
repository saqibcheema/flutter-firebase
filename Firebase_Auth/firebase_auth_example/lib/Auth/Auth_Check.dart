import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Screens/home_screen.dart';
import '../Screens/signIn_screen.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return HomeScreen();
          }else if(snapshot.hasError){
            return Center(child: Text('Something went wrong. Please, try again later.'),);
          }else{
            return SignInScreen();
          }
        }
    );
  }
}
