// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Services/FireBaseStore.dart';
import 'package:instagram_clone/Services/FirebaseAuth.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //* the current user
  User? currentuser = FirebaseAuth.instance.currentUser;

  //* controllers
  TextEditingController editingController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

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

  String imagePath = "";

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (selectedImage == null) {
      return print("its Empty");
    } else {
      setState(() {
        imagePath = selectedImage.path;
        print("Selected Image Path: ${selectedImage.path}");
      });
    }
  }

  void updateProfile(String imagePath) {
    authService.editProfileInfo(
      currentUser: authService.getCurrentUser(),
      username: usernameController.text,
      bio: bioController.text,
      imagePath: imagePath,
    );
    setState(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              usernameController.text = user?["username"];
              bioController.text = user?["bio"];
              return Padding(
                padding: const EdgeInsets.only(top: 40),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //* back arrow and title
                        PageTitle(context),

                        //* done button
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: DoneButton(),
                        )
                      ],
                    ),
                    SizedBox(height: 30),

                    //* all the things of the edit profile
                    BuildEditProfileThings(user),
                  ],
                ),
              );
            } else {
              return const Text("No Data");
            }
          },
        ));
  }

  Column BuildEditProfileThings(Map<String, dynamic>? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //* profile image
        GestureDetector(
          onTap: pickImage,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(500),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: user?["imagePath"].startsWith("http")
                  ? NetworkImage(user?["imagePath"])
                  : FileImage(
                      File(
                          imagePath.isEmpty ? (user?["imagePath"]) : imagePath),
                    ),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),

        //* text field for the User name
        EditPageTextFieldUsername(usernameController, context),

        underText(
            "Please choose a unique username. This will be your identifier.",
            context),

        //* text field for the bio
        EditPageTextFieldBio(bioController, context),

        underText(
            "Write a brief introduction about yourself (e.g., hobbies, profession, interests).",
            context),
      ],
    );
  }

  IconButton DoneButton() {
    return IconButton(
      onPressed: () => updateProfile(imagePath),
      icon: Icon(
        Icons.done,
        size: 28,
        color: Colors.blue,
      ),
    );
  }

  Row PageTitle(BuildContext context) {
    return Row(
      children: [
        //* back arrow
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),

        SizedBox(width: 30),

        //* setting text
        Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Theme.of(context).colorScheme.inversePrimary,
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
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: child),
      ),
    );
  }
}

Padding underText(String text, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
    child: Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

Padding EditPageTextFieldUsername(
    TextEditingController usernameController, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 30, right: 30, left: 30),
    child: TextField(
      controller: usernameController,
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        label: Text("Username"),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      style: TextStyle(
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
    ),
  );
}

Padding EditPageTextFieldBio(
    TextEditingController bioController, BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(top: 15, right: 30, left: 30),
    child: TextField(
      controller: bioController,
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.edit,
          color: Theme.of(context).colorScheme.primary,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        label: Text("Bio"),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        helperStyle: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        hintText: 'Write a short bio about yourself...',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
        alignLabelWithHint: true,
      ),
      style: TextStyle(
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      maxLines: 4,
      maxLength: 150,
    ),
  );
}
