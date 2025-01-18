// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //* refrences
  CollectionReference users = FirebaseFirestore.instance.collection("Users");

  //* get current user
  String getCurrentUser() {
    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    return userEmail!;
  }

  //* sign in with google method
  Future<UserCredential> sighInWithGoogle() async {
    //* trigger the google sigh in
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //* obtin the auth details from the requst
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    //*create a new credentail
    final credetial = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    addUserToFirebase(googleUser);

    //* once signed in return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credetial);
  }

  //* add google acount to firebase
  Future<void> addUserToFirebase(GoogleSignInAccount? googleUser) async {
    if (googleUser != null) {
      //* add the user to the database
      users.doc(googleUser.email).set({
        "email": googleUser.email,
        "uid": googleUser.id,
        "username": googleUser.displayName,
        "bio": "",
        "imagePath": googleUser.photoUrl,
      });
    }
  }

  //* register func
  Future<void> createAcounts(
      {required String email,
      required String password,
      required String username}) async {
    //* create a user
    UserCredential? user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    //* add the user email and username to firestore
    addEmailAndUserToFireStore(user, username);
  }

  //* set data to firestore
  Future<void> addEmailAndUserToFireStore(
      UserCredential? user, String username) async {
    //* add the user email and username to firestore
    if (user != null && user.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.user!.email)
          .set({
        "email": user.user!.email,
        "uid": user.user!.uid,
        "username": username,
        "bio": "",
        "imagePath": "",
      });
    }
  }

  //* login func
  Future<void> logInAcount(
      {required String email, required String password}) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  //* LogOut func
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  //* signOut from google method
  Future<void> sighOutfromGoogle() async {
    GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }

  // to reset the password
  Future<void> forgetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  //* A Search Function of all users in the database
  Stream<QuerySnapshot> filterdUsers(String quary) {
    if (quary.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection("Users")
          .where("username", isGreaterThanOrEqualTo: quary)
          .where("username", isLessThanOrEqualTo: quary + '\uf8ff')
          .snapshots();
    } else {
      return FirebaseFirestore.instance.collection("Users").snapshots();
    }
  }

  //* Editing the user name the image and the bio of the profile
  Future<void> editProfileInfo(
      {required String currentUser,
      required String username,
      required String bio,
      required String imagePath}) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser)
        .update(
      {
        "username": username,
        "bio": bio,
        "imagePath": imagePath,
      },
    );
    print("username is : " + username);
    print("bio is : " + bio);
    print("imagePath is : " + imagePath);
    print("profile updated");
  }
}
