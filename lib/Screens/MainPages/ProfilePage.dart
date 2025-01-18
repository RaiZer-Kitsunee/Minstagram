// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Screens/SubPages/EditProfilePage.dart';
import 'package:instagram_clone/Screens/SubPages/SettingPage.dart';
import 'package:instagram_clone/Services/FireBaseStore.dart';
import 'package:instagram_clone/Services/FirebaseAuth.dart';
import 'package:instagram_clone/widgets/DeleteBSheet.dart';
import 'package:instagram_clone/widgets/EditBSheet.dart';
import 'package:instagram_clone/widgets/PostWidget.dart';

class ProfilePage extends StatefulWidget {
  final PageController pageController;
  const ProfilePage({super.key, required this.pageController});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        .doc(currentuser!.email)
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
                    BuildSliverAppBar(context, user),

                    //* the profile things
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: BuildProfileThings(user, context),
                      ),
                    ),

                    //* tabs views
                    SliverToBoxAdapter(
                      child: BuildProfileTabs(context),
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
      BuildContext context, Map<String, dynamic>? user) {
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
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              widget.pageController.jumpToPage(2);
            },
            icon: Icon(
              Icons.add_box_outlined,
              size: 30,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: IconButton(
            icon: Icon(
              Icons.menu,
              size: 30,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingPage(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column BuildProfileTabs(BuildContext context) {
    return Column(
      children: [
        //* the tabs
        TabBar(
          indicatorColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.label,
          padding: EdgeInsets.only(top: 15),
          dividerColor: Theme.of(context).colorScheme.inversePrimary,
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
          height: MediaQuery.of(context).size.height * 0.52,
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
                      final posts = snapshot.data!.docs;

                      return ListView.builder(
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

                          if (data["email"] == authService.getCurrentUser()) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: MyDismissible(
                                docId,
                                context,
                                data,
                                Postwidget(
                                  onLongPress: () {
                                    editingController.text = data["content"];
                                    EditBSheet(
                                      context: context,
                                      editingController: editingController,
                                      fireStoreService: fireStoreService,
                                      docId: docId,
                                    );
                                  },
                                  postId: docId,
                                  data: data,
                                  isProfile: true,
                                ),
                              ),
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

  Dismissible MyDismissible(String docId, BuildContext context,
      Map<String, dynamic> data, Widget child) {
    return Dismissible(
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          fireStoreService.PostDelete(docId: docId);
        });
      },
      confirmDismiss: (direction) {
        return DeleteBSheet(context);
      },
      key: ValueKey(data),
      child: child,
    );
  }

  Column BuildProfileThings(Map<String, dynamic>? user, BuildContext context) {
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
                      backgroundImage: user?["imagePath"].startsWith("http")
                          ? NetworkImage(user?["imagePath"])
                          : FileImage(File(user?["imagePath"])),
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
                    fontSize: 15,
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
                  "Edit profile",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                width: 140,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(),
                    )),
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
