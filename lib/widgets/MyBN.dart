// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class MyBN extends StatefulWidget {
  final int currentIndex;
  final PageController pageController;
  const MyBN({
    super.key,
    required this.currentIndex,
    required this.pageController,
  });

  @override
  State<MyBN> createState() => _MyBNState();
}

class _MyBNState extends State<MyBN> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      currentIndex: widget.currentIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedIconTheme: IconThemeData(size: 30),
      unselectedIconTheme: IconThemeData(size: 30),
      type: BottomNavigationBarType.fixed,
      onTap: (value) {
        setState(() {
          widget.pageController.jumpToPage(value);
        });
      },
      items: [
        //* first
        BottomNavigationBarItem(
          icon: Icon(
            widget.currentIndex == 0 ? Icons.home : Icons.home_outlined,
          ),
          label: "Home",
          backgroundColor: Colors.black,
        ),

        //* secound
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
          ),
          label: "Search",
          backgroundColor: Colors.black,
        ),

        //* thered
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_box_outlined,
          ),
          label: "add",
          backgroundColor: Colors.black,
        ),

        //* fourth
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
          ),
          label: "profile",
          backgroundColor: Colors.black,
        ),
      ],
    );
  }
}
