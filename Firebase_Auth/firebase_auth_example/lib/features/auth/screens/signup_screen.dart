import 'package:firebase_auth_example/features/auth/logic/auth_events.dart';
import 'package:firebase_auth_example/features/auth/logic/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/routes.dart';
import '../../../core/utils/utils.dart';
import '../logic/auth_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("SignUp Screen"),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<AuthBloc, AuthStates>(
        listener: (context, state) {
          if (state is AuthError) {
            UiUtils.showError(context, state.error);
          } else if (state is AuthSignUpSuccess) {
            UiUtils.showSuccess(context, "Successfully account created");
            context.go(Routes.login);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: showPassword,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: showPassword
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (value == null || value.isEmpty) {
                        return "Enter the Email Address";
                      } else if (!emailRegex.hasMatch(value)) {
                        return 'Enter a valid email address';
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
                        return "Enter the Password";
                      } else if (value.length < 6) {
                        return "Password length should be greater than 6";
                      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return "Include at least one uppercase letter";
                      } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return "Include at least one number";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40),
                  state is AuthLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                AuthSignUpRequested(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                ),
                              );
                              _passwordController.clear();
                              _emailController.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 70),
                          ),
                          child: Text(
                            'SignUp',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          context.go(Routes.login);
                        },
                        child: Text('SignIn'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
