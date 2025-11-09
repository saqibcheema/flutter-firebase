import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Utils/routes.dart';
import '../Utils/utils.dart';
import '../widgets/signin_button.dart';
import '../widgets/login_signup_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignInButton(),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the Email Address";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the Email Address";
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              FormButton(
                title: 'Login',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(email: email, password: password)
                        .then((userCredential) {
                          Navigator.pushNamed(context, Routes.authCheck);
                    }).catchError((error) {
                      // Handle error properly
                      String message = '';
                      if (error is FirebaseAuthException) {
                        message = error.message ?? 'An error occurred';
                      } else {
                        message = 'Something went wrong${error.toString()}';
                      }
                      Utils().toastMessage(message);
                    });
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('DO not have an account'),
                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, Routes.signIn);
                  }, child: Text('SignIn'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
