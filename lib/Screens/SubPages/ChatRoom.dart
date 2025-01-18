// ignore_for_file: unused_element, non_constant_identifier_names, use_function_type_syntax_for_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/Services/FireBaseStore.dart';
import 'package:instagram_clone/widgets/chatBubble.dart';

class ChatRoom extends StatefulWidget {
  final String reciverName;
  final String reciverID;
  const ChatRoom(
      {super.key, required this.reciverName, required this.reciverID});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    //* controllers
    TextEditingController messageController = TextEditingController();
    final ScrollController scrollController = ScrollController();

    //* refrences
    FireStoreService fireStoreService = FireStoreService();
    FocusNode myFocusNode = FocusNode();

    void scrollDown() {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 50,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }

    void sendMessgae() {
      //* don't send empty messages
      if (messageController.text.isNotEmpty) {
        //* add to database
        fireStoreService.sendMessage(widget.reciverID, messageController.text);
        //* clear field
        messageController.clear();
      }
      //* scroll when new message
      Future.delayed(
        Duration(milliseconds: 200),
        () => scrollDown(),
      );
    }

    @override
    void initState() {
      myFocusNode.addListener(
        () {
          if (myFocusNode.hasFocus) {
            Future.delayed(
              Duration(milliseconds: 500),
              () => scrollDown(),
            );
          }
        },
      );

      Future.delayed(
        Duration(milliseconds: 500),
        () => scrollDown(),
      );
      super.initState();
    }

    @override
    void dispose() {
      myFocusNode.dispose();
      messageController.dispose();
      scrollController.dispose();
      super.dispose();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: Column(
          children: [
            //* the app bar sort of
            PageTitle(context),

            //* List of the messages
            Expanded(
              child: BuildMessageList(fireStoreService, scrollController),
            ),

            //* textField of the user
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
              child: BuildUserInput(
                  myFocusNode, messageController, sendMessgae, context),
            ),
          ],
        ),
      ),
    );
  }

  Row BuildUserInput(
      FocusNode myFocusNode,
      TextEditingController messageController,
      void sendMessgae(),
      BuildContext context) {
    return Row(
      children: [
        //* textfield
        Expanded(
          child: TextField(
            focusNode: myFocusNode,
            controller: messageController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).colorScheme.inversePrimary,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              hintText: "Say Something...",
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              //* send button
              suffixIcon: Container(
                margin: EdgeInsets.only(right: 4, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(500),
                ),
                child: IconButton(
                  onPressed: sendMessgae,
                  icon: Icon(
                    Icons.send,
                    size: 30,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      ],
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> BuildMessageList(
      FireStoreService fireStoreService, ScrollController scrollController) {
    return StreamBuilder(
      stream: fireStoreService.getAllMessages(
          fireStoreService.currentUser!.uid, widget.reciverID),
      builder: (context, snapshot) {
        //* loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("loading..."),
          );
        }
        //* error
        if (snapshot.hasError) {
          return Text("There is an Error");
        }

        List messages = snapshot.data!.docs;

        //* has data
        if (snapshot.hasData) {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(top: 5),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              //* one message
              DocumentSnapshot message = messages[index];

              //* message data
              Map<String, dynamic> data =
                  message.data() as Map<String, dynamic>;

              bool isCurrentUser =
                  data["senderEmail"] == fireStoreService.currentUser!.email;

              var alignment =
                  isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

              Color color = isCurrentUser
                  ? Colors.blue
                  : Theme.of(context).colorScheme.primary;

              return ChatBubble(
                message: data["message"],
                color: color,
                alignment: alignment,
              );
            },
          );
        } else {
          return Text("There is no data");
        }
      },
    );
  }

  Row PageTitle(BuildContext context) {
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

        SizedBox(width: 99),

        //* setting text
        Text(
          widget.reciverName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ],
    );
  }
}
