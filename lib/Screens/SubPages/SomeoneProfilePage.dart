// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Services/FireBaseStore.dart';
import 'package:instagram_clone/Services/FirebaseAuth.dart';
import 'package:instagram_clone/widgets/PostWidget.dart';

class SomeoneProfilePage extends StatefulWidget {
  final String someEmail;
  const SomeoneProfilePage({super.key, required this.someEmail});

  @override
  State<SomeoneProfilePage> createState() => _SomeoneProfilePageState();
}

class _SomeoneProfilePageState extends State<SomeoneProfilePage> {
  //* the current user
  User? currentuser = FirebaseAuth.instance.currentUser;

  //* controllers
  TextEditingController editingController = TextEditingController();

  //* refrences
  FireStoreService fireStoreService = FireStoreService();
  AuthService authService = AuthService();

  //* get the information of the user
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.someEmail)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: FutureBuilder(
            future: getUserInfo(),
            builder: (context, snapshot) {
              //* waiting
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              //* error
              else if (snapshot.hasError) {
                return const Text("there is an error");
              }

              //* has data
              else if (snapshot.hasData) {
                Map<String, dynamic>? user = snapshot.data!.data();

                return CustomScrollView(
                  slivers: [
                    //* the app bar
                    BuildSliverAppBar(user, context),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: BuildSomeoneUserProfile(user, context),
                      ),
                    ),

                    //* tabs views
                    SliverToBoxAdapter(
                      child: BuildSomeoneTabsProfile(context),
                    )
                  ],
                );
              } else {
                return const Text("No Data");
              }
            },
          )),
    );
  }

  SliverAppBar BuildSliverAppBar(
      Map<String, dynamic>? user, BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        "${user?["username"]}",
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: 27,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).colorScheme.inversePrimary,
          )),
    );
  }

  Column BuildSomeoneTabsProfile(BuildContext context) {
    return Column(
      children: [
        //* the tabs
        TabBar(
          indicatorColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.label,
          padding: EdgeInsets.only(top: 15),
          dividerColor: Theme.of(context).colorScheme.inversePrimary,
          unselectedLabelColor: Theme.of(context).colorScheme.inversePrimary,
          overlayColor:
              MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
          tabs: [
            Tab(
              icon: Icon(
                Icons.grid_on,
                size: 30,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.video_collection_outlined,
                size: 30,
              ),
            ),
          ],
        ),
        //* tabs view
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: TabBarView(
            children: [
              //* first TAP
              Container(
                child: StreamBuilder(
                  stream: fireStoreService.getAllPosts(),
                  builder: (context, snapshot) {
                    //* loading
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    //* error
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("There is an Error"),
                      );
                    }

                    //* has data
                    if (snapshot.hasData) {
                      //* list of all the docs
                      List posts = snapshot.data!.docs;

                      return posts.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 170),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.podcasts,
                                      color: Colors.grey,
                                      size: 80,
                                    ),
                                    Text(
                                      "There is No Posts",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.only(top: 5),
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                //* the single doc
                                DocumentSnapshot document = posts[index];

                                //* document id
                                String docId = document.id;

                                //* the Map of the data
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;

                                if (data["email"] == widget.someEmail) {
                                  return Postwidget(
                                    isProfile: false,
                                    data: data,
                                    postId: docId,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            );
                    } else {
                      return Text("There is no Data");
                    }
                  },
                ),
              ),

              //* Second TAP
              Container(
                child: Center(
                  child: Text(
                    "Coming next Update",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column BuildSomeoneUserProfile(
      Map<String, dynamic>? user, BuildContext context) {
    return Column(
      children: [
        //*  picture and the stats and bio
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              //* profile statics
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //* profile picture
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(500),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: FileImage(
                        File(user?["imagePath"]),
                      ),
                      backgroundColor:
                          Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  //* posts numbers
                  Column(
                    children: [
                      Text(
                        "0",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  //* followers numbers
                  Column(
                    children: [
                      Text(
                        "0",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "followers",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  //* following numbers
                  Column(
                    children: [
                      Text(
                        "0",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "following",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //* bio
              Container(
                margin: EdgeInsets.symmetric(vertical: 7),
                width: MediaQuery.sizeOf(context).width,
                child: Text(
                  "${user?["bio"]}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),

        //* buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              button(
                child: Text(
                  "Follow",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                width: 140,
                onTap: () {},
              ),
              button(
                child: Text(
                  "Share profile",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                width: 140,
                onTap: () {},
              ),
              button(
                child: Icon(
                  Icons.person_add_outlined,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                width: 40,
                onTap: () {},
              )
            ],
          ),
        ),
      ],
    );
  }

  GestureDetector button(
      {required Widget child,
      required double? width,
      required void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: child),
      ),
    );
  }
}
