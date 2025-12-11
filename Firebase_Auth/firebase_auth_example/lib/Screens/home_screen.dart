import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/features/auth/logic/auth_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/logic/auth_bloc.dart';
import '../features/auth/logic/auth_states.dart';


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
      body: BlocConsumer<AuthBloc,AuthStates>(
        listener: (context,state){
          if(state is AuthError){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error),backgroundColor: Colors.red),);
          }else if(state is AuthSuccess){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Successfully Log Out'),backgroundColor: Colors.green),
            );
            context.go('/logIn');
          }
        },
        builder: (context,state){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Text('Home Screen')),
              Center(child: Text('Email : ${user?.email}')),
              state is AuthLoading ? CircularProgressIndicator() : ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthSignOut());
                },
                child: Text('SignOut'),
              ),
            ],
          );
        },
      ),
    );
  }
}
