// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, use_function_type_syntax_for_parameters

import 'package:flutter/material.dart';
import 'package:instagram_clone/Services/FireBaseStore.dart';
import 'package:instagram_clone/Services/FirebaseAuth.dart';
import 'package:instagram_clone/widgets/ErrorMessage.dart';
import 'package:instagram_clone/widgets/SnackMessage.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    //* conttollers
    TextEditingController postController = TextEditingController();

    //* refrenses
    FireStoreService fireStoreService = FireStoreService();
    AuthService authService = AuthService();

    //* functions
    void addPosts() async {
      if (postController.text.isEmpty) {
        SnackMessage(context: context, text: "The Field Is Empty");
      } else {
        try {
          await fireStoreService.PostAdd(
            userEmail: authService.getCurrentUser(),
            content: postController.text,
          );
          postController.clear();
          SnackMessage(context: context, text: "Post Added");
        } catch (e) {
          ErrorMessage("$e", context);
        }
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            //* title thing
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, top: 10),
                child: TitlePage(context),
              ),
            ),

            //* the textfield and the button
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: BuildAddPost(postController, addPosts, context),
            ),
          ],
        ),
      ),
    );
  }

  Column BuildAddPost(TextEditingController postController, void addPosts(),
      BuildContext context) {
    return Column(
      children: [
        //* the textfield of the title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: TextField(
            autofocus: false,
            controller: postController,
            decoration: InputDecoration(
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
              hintText: "Say Something...",
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),

        //* button
        GestureDetector(
          onTap: () => addPosts(),
          child: Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                "Save",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Text TitlePage(BuildContext context) {
    return Text(
      "Create Post :",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
