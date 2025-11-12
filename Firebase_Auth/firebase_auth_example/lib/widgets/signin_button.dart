import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/Utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../logic/google_signin.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: InkWell(
        onTap: ()async{
          await GoogleSignInHelper().signIn();
          if(!context.mounted) return;
          context.go(Routes.authCheck);
        },
        child: Container(
          height: 60,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(child: Text('SignIn with Google',style: TextStyle(color: Colors.white,fontSize: 20),)),
        ),
      ),
    );
  }
}
