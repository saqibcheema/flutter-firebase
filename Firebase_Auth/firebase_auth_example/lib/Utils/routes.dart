import 'package:firebase_auth_example/Auth/Auth_Check.dart';
import 'package:flutter/material.dart';

import '../Screens/home_screen.dart';
import '../Screens/login_screen.dart';
import '../Screens/signIn_screen.dart';

class Routes{
  static const String signIn = '/';
  static const String login = '/LogIn';
  static const String home = '/Home';
  static const String authCheck = '/AuthCheck';

  static Map<String, WidgetBuilder> routes = {
    signIn: (context) => SignInScreen(),
    login: (context) => LoginScreen(),
    home: (context) => HomeScreen(),
    authCheck : (context) => AuthCheck()
  };
}