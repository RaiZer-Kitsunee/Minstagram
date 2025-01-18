// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Screens/SubPages/MessagesPage.dart';
import 'package:instagram_clone/Screens/SubPages/SomeoneProfilePage.dart';
import 'package:instagram_clone/Services/FireBaseStore.dart';
import 'package:instagram_clone/Services/FirebaseAuth.dart';
import 'package:instagram_clone/widgets/PostWidget.dart';

class HomePage extends StatefulWidget {
  final PageController pageController;
  const HomePage({super.key, required this.pageController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //* refrences
  AuthService authService = AuthService();
  FireStoreService fireStoreService = FireStoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          //* the app bar
          SliverAppBar(
            floating: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text(
              "Instagram",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.favorite_border,
                  size: 30,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagesPage(),
                    ),
                  ),
                  icon: Icon(
                    Icons.message_outlined,
                    size: 30,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ],
          ),

          //* maybe if there a re images to show

          //* the home section
          SliverToBoxAdapter(
            child: buildThePostList(),
          )
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildThePostList() {
    return StreamBuilder(
      stream: fireStoreService.getAllPosts(),
      builder: (context, snapshot) {
        //* loding...
        if (snapshot.connectionState == ConnectionState.waiting) {
          Center(
            child: CircularProgressIndicator(),
          );
        }

        //* Errors
        if (snapshot.hasError) {
          Center(
            child: Text("SomeThing went Wrong"),
          );
        }

        //* Found Data
        if (snapshot.hasData) {
          //* get all docs of the collction
          List posts = snapshot.data!.docs;

          return posts.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 170),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.podcasts,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          size: 80,
                        ),
                        Text(
                          "There is No Posts",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(top: 5),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    //* get one doc
                    DocumentSnapshot document = posts[index];

                    //* id of the document
                    String docId = document.id;

                    //* get the data of the doc
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    return Postwidget(
                      isProfile: false,
                      data: data,
                      postId: docId,
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      onDoubleTap: () {
                        if (data["email"] == authService.getCurrentUser()) {
                          setState(
                            () {
                              widget.pageController.jumpToPage(3);
                            },
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SomeoneProfilePage(someEmail: data["email"]),
                            ),
                          );
                        }
                      },
                    );
                  });
        } else {
          return Center(child: Text("No Data"));
        }
      },
    );
  }
}
