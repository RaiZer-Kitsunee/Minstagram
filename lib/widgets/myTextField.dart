// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String labelText;
  final bool isObsecure;
  final TextEditingController controller;
  const MyTextField(
      {super.key,
      required this.labelText,
      required this.isObsecure,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        label: Text(labelText),
        labelStyle:
            TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      obscureText: isObsecure,
    );
  }
}
