import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/core/routes/stream_listenable.dart';
import 'package:firebase_auth_example/features/chat/presentation/chat_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth_example/features/chat_list/presentation/home_screen.dart';
import 'package:firebase_auth_example/features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/chat/data/models/chatScreenArguments_model.dart';

class Routes {
  static const String signIn = '/';
  static const String login = '/logIn';
  static const String home = '/home';
  static const String chatScreen = '/ChatScreen';

  final GoRouter router = GoRouter(
    initialLocation:
        signIn,
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),


    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggedIn = user != null;


      final isOnSignUpPage = state.matchedLocation == signIn;
      final isOnLoginPage = state.matchedLocation == login;

      if (isLoggedIn && (isOnSignUpPage || isOnLoginPage)) {
        return home;
      }

      if (!isLoggedIn && !isOnSignUpPage && !isOnLoginPage) {
        return signIn;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(path: Routes.home, builder: (context, state) => HomeScreen()),
      GoRoute(
        path: Routes.chatScreen,

        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return ChatScreen(
            args: ChatScreenArguments(
              chatRoomId: args['roomId'],
              receiverId: args['receiverId'],
              receiverName: args['receiverName'],
              receiverProfilePic: args['receiverProfilePic'] ?? '',
            )
          );
        },
      ),
    ],
  );
}
