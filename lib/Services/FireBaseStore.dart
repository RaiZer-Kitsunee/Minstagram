// ignore_for_file: file_names, avoid_print, non_constant_identifier_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/Models/MessageModel.dart';

class FireStoreService {
  //* refrence the collections
  CollectionReference posts = FirebaseFirestore.instance.collection("Posts");
  User? currentUser = FirebaseAuth.instance.currentUser;

  //* POSTES

  //* add a post
  Future<void> PostAdd({
    required String userEmail,
    required String content,
  }) async {
    await posts.add(
      {
        "content": content,
        "email": userEmail,
        "likes": 0,
        "likedby": [],
        "timestamp": Timestamp.now(),
      },
    );
    print("Post added");
  }

  //* Update post
  Future<void> PostUpdate(
      {required String docId, required String NewContent}) async {
    await posts.doc(docId).update(
      {
        "content": NewContent,
        "timestamp": Timestamp.now(),
      },
    );
  }

  //* delete post
  Future<void> PostDelete({required String docId}) async {
    await posts.doc(docId).delete();
  }

  //* get all posts
  Stream<QuerySnapshot> getAllPosts() {
    final postsStrem = posts.orderBy("timestamp", descending: true).snapshots();
    return postsStrem;
  }

  //* Chat Messages

  //* send a Message
  Future<void> sendMessage(String reciverID, String message) async {
    //* get the informaion
    final String currentUserID = currentUser!.uid;
    final String? currentUserEmail = currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    //* create the message
    Message newMessage = Message(
      reciverID: reciverID,
      senderID: currentUserID,
      senderEmail: currentUserEmail!,
      message: message,
      timestamp: timestamp,
    );

    //* create chat room
    List<String> ids = [currentUserID, reciverID];
    ids.sort();
    String chatRoomID = ids.join("_");

    //* give it all to the database
    await FirebaseFirestore.instance
        .collection("Chat-Rooms")
        .doc(chatRoomID)
        .collection("Messages")
        .add(
          newMessage.toMap(),
        );
  }

  //* get the Messages
  Stream<QuerySnapshot> getAllMessages(String senderID, String reciverId) {
    //* get the doc name
    List<String> ids = [senderID, reciverId];
    ids.sort();
    String chatRoomID = ids.join("_");

    return FirebaseFirestore.instance
        .collection("Chat-Rooms")
        .doc(chatRoomID)
        .collection("Messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
