// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:instagram_clone/Screens/MainPages/HomePage.dart';
import 'package:instagram_clone/Screens/MainPages/ProfilePage.dart';
import 'package:instagram_clone/Screens/MainPages/SearchPage.dart';
import 'package:instagram_clone/Screens/MainPages/addPage.dart';
import 'package:instagram_clone/widgets/MyBN.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  //* page controller
  late PageController pageController;

  //* current index
  int? currentIndex = 0;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBN(
        currentIndex: currentIndex!,
        pageController: pageController,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        children: [
          HomePage(
            pageController: pageController,
          ),
          SearchPage(),
          const AddPage(),
          ProfilePage(
            pageController: pageController,
          ),
        ],
      ),
    );
  }
}
