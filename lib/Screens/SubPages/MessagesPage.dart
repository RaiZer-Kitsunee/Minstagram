// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_interpolation_to_compose_strings, file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/Screens/SubPages/ChatRoom.dart';
import 'package:instagram_clone/Services/FirebaseAuth.dart';
import 'package:instagram_clone/widgets/ChatUserTile.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  //* controlles
  final TextEditingController _searchController = TextEditingController();

  // veriable
  String searchQuery = "";
  AuthService authService = AuthService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* the title
            PageTitle(),

            //* search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: MessageSearchTextField(),
            ),

            //* just a title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: SectionTitle(),
            ),

            //* the users that can chat with
            BuildMessageUsersList(),
          ],
        ),
      ),
    );
  }

  Expanded BuildMessageUsersList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: authService.filterdUsers(searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No results found'));
          }

          //* all the users
          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.only(top: 1),
            itemCount: users.length,
            itemBuilder: (context, index) {
              //* one user
              DocumentSnapshot user = users[index];

              //* the data
              Map<String, dynamic> data = user.data() as Map<String, dynamic>;

              String username = data["username"];
              String email = data["email"];
              String imagePath = data["imagePath"];
              String reciverID = data["uid"];

              if (email != authService.getCurrentUser()) {
                return ChatUserTile(
                  userName: username,
                  email: email,
                  imagePath: imagePath,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoom(
                        reciverName: username,
                        reciverID: reciverID,
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  Text SectionTitle() {
    return Text(
      "Messages:",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.inversePrimary,
        fontSize: 20,
      ),
    );
  }

  TextField MessageSearchTextField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        labelText: 'Search',
        labelStyle:
            TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      onChanged: (value) {
        setState(() {
          searchQuery = value.trim();
          print('Search Query: $searchQuery');
        });
      },
    );
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> PageTitle() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("Users")
          .doc(authService.getCurrentUser())
          .get(),
      builder: (context, snapshot) {
        //* loading
        //* it will look ridiciles we don't really need it

        //* error
        if (snapshot.hasError) {
          return Text("There is an Error");
        }

        //* Has Data
        if (snapshot.hasData) {
          Map<String, dynamic> user =
              snapshot.data!.data() as Map<String, dynamic>;

          return Row(
            children: [
              //* back arrow
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),

              SizedBox(width: 20),

              //* setting text
              Text(
                "${user["username"]}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          );
        } else {
          return Text("There is no data");
        }
      },
    );
  }
}
