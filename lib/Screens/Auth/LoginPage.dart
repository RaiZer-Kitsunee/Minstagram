// ignore_for_file: file_names, must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Services/FirebaseAuth.dart';
import 'package:instagram_clone/Themes/ThemeProvider.dart';
import 'package:instagram_clone/widgets/ErrorMessage.dart';
import 'package:instagram_clone/widgets/GoogleButton.dart';
import 'package:instagram_clone/widgets/myButton.dart';
import 'package:instagram_clone/widgets/myTextField.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //* controllers
  TextEditingController emailContoller = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //* refrenses
  AuthService authService = AuthService();
  bool isLoding = false;

  //* functions
  void login() async {
    setState(() {
      isLoding = true;
    });
    try {
      await authService.logInAcount(
          email: emailContoller.text, password: passwordController.text);
      setState(() {
        isLoding = false;
      });
    } on FirebaseAuthException catch (e) {
      ErrorMessage(e.code, context);
      setState(() {
        isLoding = false;
      });
    }
  }

  void loginGoogle() async {
    try {
      await authService.sighInWithGoogle();
    } on FirebaseAuthException catch (e) {
      ErrorMessage(e.code, context);
    }
  }

  void forgetpasword(BuildContext context) {
    if (emailContoller.text.isEmpty) {
      ErrorMessage("the email is empty", context);
    } else {
      try {
        authService.forgetPassword(email: emailContoller.text);
        ErrorMessage("Check your email for reset", context);
      } on FirebaseAuthException catch (e) {
        ErrorMessage(e.code, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Provider.of<ThemeProvider>(context).isDarkMode
                ? [
                    Color.fromARGB(255, 100, 29, 26), // Deep Orange-Brown
                    Color(0xFF1D1E33), // Dark Navy/Blackish Blue
                    Color(0xFF1D1E33), // Dark Navy/Blackish Blue
                    Color(0xFF1D1E33), // Dark Navy/Blackish Blue
                    Color(0xFF1D1E33), // Dark Navy/Blackish Blue
                    Color.fromARGB(255, 36, 36, 80), // Dark Purple
                  ]
                : [
                    Color.fromARGB(255, 155, 226, 229), // Light Cyan
                    Color(0xFFE2E1CC), // Light Yellowish Beige
                    Color(0xFFE2E1CC), // Light Yellowish Beige
                    Color(0xFFE2E1CC), // Light Yellowish Beige
                    Color(0xFFE2E1CC), // Light Yellowish Beige
                    Color.fromARGB(255, 155, 226, 229), // Pale Yellow/Beige
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Wrap(
            children: [
              //* logo and the text fields
              Padding(
                padding: const EdgeInsets.only(top: 175),
                child: Column(
                  children: [
                    //* logo
                    Image.asset(
                      "assets/images/instagram.png",
                      scale: 7,
                    ),

                    SizedBox(height: 120),

                    //* email field
                    MyTextField(
                      labelText: "Username,email or mobile number",
                      isObsecure: false,
                      controller: emailContoller,
                    ),

                    SizedBox(height: 15),

                    //* password field
                    MyTextField(
                      labelText: "Password",
                      isObsecure: true,
                      controller: passwordController,
                    ),

                    SizedBox(height: 15),

                    //* login button
                    isLoding
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : MyButton(
                            Create: false,
                            text: "Log in",
                            onTap: () => login(),
                          ),

                    SizedBox(height: 20),

                    //* forget password
                    GestureDetector(
                      onTap: () => forgetpasword(context),
                      child: Text(
                        "Forget password?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //* the create button and logo
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    //* the login google button
                    GoogleThing(
                      context: context,
                      onTap: loginGoogle,
                    ),
                    //* create new acount
                    MyButton(
                      Create: true,
                      text: "Create new account",
                      onTap: widget.onTap,
                    ),

                    SizedBox(height: 14),

                    //* compeny logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.games,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "KITSUNEE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
