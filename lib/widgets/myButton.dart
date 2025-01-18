// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:instagram_clone/Themes/ThemeProvider.dart';
import 'package:provider/provider.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final bool Create;
  const MyButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.Create});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Create
              ? Colors.transparent
              : (Provider.of<ThemeProvider>(context).isDarkMode
                  ? Colors.blue.shade900
                  : Color.fromARGB(255, 155, 226, 229)),
          border: Create
              ? Border.all(
                  color: Provider.of<ThemeProvider>(context).isDarkMode
                      ? Colors.blue
                      : Colors.black)
              : Border(),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Create
                  ? Provider.of<ThemeProvider>(context).isDarkMode
                      ? Colors.blue
                      : Colors.black
                  : Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
      ),
    );
  }
}
