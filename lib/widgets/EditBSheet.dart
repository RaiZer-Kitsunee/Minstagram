// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:instagram_clone/Services/FireBaseStore.dart';
import 'package:instagram_clone/widgets/myTextField.dart';

EditBSheet({
  required BuildContext context,
  required TextEditingController editingController,
  required FireStoreService fireStoreService,
  required String docId,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //* title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Edit It ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade200,
                    fontSize: 20,
                  ),
                ),
                Icon(
                  Icons.edit,
                  color: Colors.grey.shade200,
                  size: 25,
                )
              ],
            ),
          ),

          //* textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: MyTextField(
              labelText: "New Someting...",
              isObsecure: false,
              controller: editingController,
            ),
          ),

          //* buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              button(
                onTap: () {
                  if (editingController.text.isNotEmpty) {
                    fireStoreService.PostUpdate(
                        docId: docId, NewContent: editingController.text);
                    editingController.clear();
                    Navigator.pop(context);
                  }
                },
                color: Colors.blue,
                text: "Save",
              ),
              SizedBox(width: 100),
              button(
                onTap: () => Navigator.pop(context),
                color: Colors.grey.shade200,
                text: "Cancel",
              ),
            ],
          )
        ],
      ),
    ),
  );
}

GestureDetector button(
    {required void Function()? onTap,
    required Color color,
    required String text}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 50,
      width: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}
