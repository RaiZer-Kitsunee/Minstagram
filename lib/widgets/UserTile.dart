import 'dart:io';

import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String userName;
  final String email;
  final String imagePath;
  final void Function()? onTap;
  const UserTile({
    super.key,
    required this.userName,
    required this.email,
    this.onTap,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2.0,
              ),
            ),
            child: imagePath.isEmpty
                ? Icon(
                    Icons.person,
                    size: 35,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundImage: imagePath.startsWith("http")
                        ? NetworkImage(imagePath)
                        : FileImage(File(imagePath)),
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                  ),
          ),
          title: Text(
            userName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          subtitle: Text(
            email,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
