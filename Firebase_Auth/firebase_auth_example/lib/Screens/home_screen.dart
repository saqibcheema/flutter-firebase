import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              onPressed: (){
                FirebaseAuth.instance.signOut();
              },
              child: Text('SignOut')
          )
        ],
      ),
    );
  }
}
