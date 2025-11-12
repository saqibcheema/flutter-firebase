import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Utils/routes.dart';
import '../Utils/utils.dart';
import '../widgets/login_signup_button.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void signIn() async{
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();


    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((onValue){
      context.push(Routes.login);
    }).onError((e,stackTrace){
      final String message;
      if(e is FirebaseAuthException){
        if (e.code == "user-not-found") {
          message = "No user found for that email";
        } else if (e.code == "wrong-password") {
          message = "Wrong password provided for that user";
        } else {
          message = "Something went wrong ${e.toString()}";
        }
        Utils().toastMessage(message);
      }else{
        message = "UnKnown Error ${e.toString()}";
        Utils().toastMessage(message);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("SignUp Screen"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
                validator: (value){
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if(value==null || value.isEmpty){
                    return "Enter the Email Address";
                  }else if (!emailRegex.hasMatch(value)) {
                    return 'Enter a valid email address';
                  }


                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter the Password";
                  }else if(value.length < 6){
                    return "Password length should be greater than 6";
                  }else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    return "Include at least one uppercase letter";
                  }else if(!RegExp(r'[0-9]').hasMatch(value)){
                    return "Include at least one number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 40,),
              FormButton(title: 'SignUp', onPressed: (){
                if(_formKey.currentState!.validate()){
                  signIn();
                }
              },),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  TextButton(onPressed: (){
                    context.go(Routes.login);
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
