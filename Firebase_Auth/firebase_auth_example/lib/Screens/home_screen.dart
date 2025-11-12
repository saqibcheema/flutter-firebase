import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Utils/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text('Home Screen'),
          ),
          Center(
            child: Text('Email : ${user?.email}'),
          ),
          ElevatedButton(
              onPressed: ()async{
                User? user = FirebaseAuth.instance.currentUser;

                if (user != null) {
                  // Check if logged in with Google
                  bool isGoogleUser = user.providerData.any((info) => info.providerId == 'google.com');

                  if (isGoogleUser) {
                    final GoogleSignIn _googleSignIn = GoogleSignIn();

                    try {
                      await _googleSignIn.signOut();
                      await _googleSignIn.disconnect(); // May fail if no cached session
                    } catch (e) {
                      print("GoogleSignIn disconnect failed: $e"); // Ignore, continue
                    }
                  }
                }

                FirebaseAuth.instance.signOut();
                if(!context.mounted) return;
                context.go(Routes.authCheck);
              },
              child: Text('SignOut')
          )
        ],
      ),
    );
  }
}
