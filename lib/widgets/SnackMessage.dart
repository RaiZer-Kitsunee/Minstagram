// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

void SnackMessage({required BuildContext context, required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.grey.shade800,
      content: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    ),
  );
}
