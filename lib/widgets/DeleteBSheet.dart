// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Future<bool?> DeleteBSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      height: 240,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //* title
          Icon(
            Icons.delete,
            size: 80,
            color: Colors.grey.shade200,
          ),

          //* dialog
          Text(
            "Do You Realy Want To Delete That ?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade200,
            ),
          ),

          //* buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              button(
                onTap: () => Navigator.pop(context, true),
                color: Colors.red,
                text: "Yes",
              ),
              SizedBox(width: 100),
              button(
                onTap: () => Navigator.pop(context, false),
                color: Colors.grey.shade200,
                text: "No",
              ),
            ],
          )
        ],
      ),
    ),
  );
}

GestureDetector button(
    {required void Function()? onTap,
    required Color color,
    required String text}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 50,
      width: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}
