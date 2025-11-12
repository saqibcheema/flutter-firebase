import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Utils/routes.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If error occurs
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Something went wrong. Please, try again later.'),
            ),
          );
        }

        // If user is logged in
        if (snapshot.hasData) {
          // Clear all previous routes and go to Home
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(Routes.home, extra: snapshot.data);
          });
        } else {
          // User not logged in → go to SignIn
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(Routes.login);
          });
        }

        // While redirecting, keep showing a loading screen
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
