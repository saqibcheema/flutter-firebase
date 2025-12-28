import 'package:firebase_auth_example/core/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/data/repository/auth_repository.dart';
import 'features/auth/logic/auth_bloc.dart';
import 'features/chat/data/repository/chat_repository.dart';
import 'features/chat/logic/chat_bloc.dart';
import 'features/chat_list/data/chatList_repository.dart';
import 'features/chat_list/logic/chatlist_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(authRepository: AuthRepository())),
          BlocProvider(create: (context) => ChatListBloc(chatListRepository: ChatListRepository())),
          BlocProvider(create: (context) => ChatBloc(chatRepository: ChatRepository())),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: Routes().router,
        ),
    );
  }
}
