// ignore_for_file: file_names, must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Services/FirebaseAuth.dart';
import 'package:instagram_clone/Themes/ThemeProvider.dart';
import 'package:instagram_clone/widgets/ErrorMessage.dart';
import 'package:instagram_clone/widgets/myButton.dart';
import 'package:instagram_clone/widgets/myTextField.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //* controllers
  TextEditingController usernameContoller = TextEditingController();
  TextEditingController emailContoller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confrmePwController = TextEditingController();

  //* refrances
  AuthService authService = AuthService();
  bool isloding = false;

  //* functions
  void Register() async {
    setState(() {
      isloding = true;
    });
    if (passwordController.text == confrmePwController.text) {
      try {
        //* create the user
        await authService.createAcounts(
          email: emailContoller.text,
          password: passwordController.text,
          username: usernameContoller.text,
        );

        //* Stop the circle loding
        setState(() {
          isloding = false;
        });
      } on FirebaseAuthException catch (e) {
        //* stop the circle loding
        setState(() {
          isloding = false;
        });
        //* the error dialog
        ErrorMessage(e.code, context);
      }
    } else {
      setState(() {
        isloding = false;
      });
      ErrorMessage("Password don't Match !!", context);
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
          child: ListView(
            children: [
              //* logo and the text fields
              Padding(
                padding: EdgeInsets.only(top: 105),
                child: Column(
                  children: [
                    //* logo
                    Image.asset(
                      "assets/images/instagram.png",
                      scale: 7,
                    ),

                    SizedBox(height: 80),

                    //* user field
                    MyTextField(
                      labelText: "Username",
                      isObsecure: false,
                      controller: usernameContoller,
                    ),

                    SizedBox(height: 15),

                    //* email field
                    MyTextField(
                      labelText: "Email",
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

                    //* confrme Pw field
                    MyTextField(
                      labelText: "Confrme Password",
                      isObsecure: true,
                      controller: confrmePwController,
                    ),

                    SizedBox(height: 20),

                    //* login button
                    isloding
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : MyButton(
                            Create: false,
                            text: "Register",
                            onTap: () => Register(),
                          ),
                  ],
                ),
              ),

              //* the create button and logo
              Padding(
                padding: EdgeInsets.only(top: 65),
                child: Column(
                  children: [
                    //* create new acount
                    MyButton(
                      Create: true,
                      text: "Login to Account",
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
