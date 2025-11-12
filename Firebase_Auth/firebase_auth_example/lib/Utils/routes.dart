import 'package:firebase_auth_example/Auth/Auth_Check.dart';
import 'package:firebase_auth_example/Screens/home_screen.dart';
import 'package:firebase_auth_example/Screens/login_screen.dart';
import 'package:go_router/go_router.dart';
import '../Screens/signIn_screen.dart';

class Routes {
  static const String signIn = '/';
  static const String login = '/logIn';
  static const String home = '/home';
  static const String authCheck = '/authCheck';

  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
          path: Routes.signIn,
          builder: (context, state) => SignInScreen()
      ),
      GoRoute(
          path: Routes.login,
          builder: (context, state) => LoginScreen()
      ),
      GoRoute(
          path: Routes.home,
          builder: (context, state) => HomeScreen()
      ),
      GoRoute(
          path: Routes.authCheck,
          builder: (context, state) => AuthCheck()
      ),
    ],
  );
}


