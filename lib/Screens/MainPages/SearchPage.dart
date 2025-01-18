// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/Screens/SubPages/SomeoneProfilePage.dart';
import 'package:instagram_clone/Services/FirebaseAuth.dart';
import 'package:instagram_clone/widgets/UserTile.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
          children: [
            //* search textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: SearchTextfield(),
            ),
            //* search list
            Expanded(
              child: BuildUserSearchList(),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> BuildUserSearchList() {
    return StreamBuilder<QuerySnapshot>(
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

            if (email != authService.getCurrentUser()) {
              return UserTile(
                userName: username,
                email: email,
                imagePath: imagePath,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SomeoneProfilePage(someEmail: email),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  }

  TextField SearchTextfield() {
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
}
