import 'dart:async'; // Stream k liye zaroori ha
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Ap ki screens k imports (Names wese hi hain jo ap ne diye)
import 'package:firebase_auth_example/Screens/home_screen.dart';
import 'package:firebase_auth_example/features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart'; // Ap ne kaha yehi SignInScreen ha

class Routes {
  static const String signIn = '/';       // Ye ap ki SignUp Screen ha (Note: Naming confusing ha pr ma change ni kr ra)
  static const String login = '/logIn';   // Ye Login Screen ha
  static const String home = '/home';     // Ye Home ha

  final GoRouter router = GoRouter(
    initialLocation: signIn, // App start hony par pehly yahan jaye gi (phir redirect check ho ga)

    // 1. REFRESH LOGIC: Jesy hi user login/logout ho ga, router khud refresh ho ga
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),

    // 2. REDIRECT LOGIC: Ye decide kary ga k user ko kahan bhejna ha
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggedIn = user != null;

      // Check karein banda abhi kahan khara ha
      // state.matchedLocation use krna behtar ha
      final isOnSignUpPage = state.matchedLocation == signIn;
      final isOnLoginPage = state.matchedLocation == login;

      // CASE A: Banda Login HA, aur wo Login ya SignUp page par khara ha -> Home bhej do
      if (isLoggedIn && (isOnSignUpPage || isOnLoginPage)) {
        return home;
      }

      // CASE B: Banda Login NAHI HA, aur wo Home par jany ki koshish kr raha ha -> Wapis SignUp (SignIn route) bhej do
      if (!isLoggedIn && !isOnSignUpPage && !isOnLoginPage) {
        return signIn;
      }

      // Baqi cases ma kuch mat kro (null return kro)
      return null;
    },

    routes: [
      GoRoute(
          path: Routes.signIn,
          builder: (context, state) => const SignInScreen() // Ap ki SignUp logic yahan ha
      ),
      GoRoute(
          path: Routes.login,
          builder: (context, state) => const LoginScreen() // Login logic yahan ha
      ),
      GoRoute(
          path: Routes.home,
          builder: (context, state) => const HomeScreen()
      ),
    ],
  );
}

// --- HELPER CLASS (Isy isi file k neechy rehny dein) ---
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}