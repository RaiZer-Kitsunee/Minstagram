import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/LikeButton.dart';

class Postwidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final String postId;
  final EdgeInsetsGeometry? margin;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  final void Function()? onIconPressed;
  final bool isProfile;
  final IconData? icon;
  const Postwidget({
    super.key,
    required this.data,
    this.margin,
    this.onDoubleTap,
    this.onLongPress,
    required this.isProfile,
    this.onIconPressed,
    this.icon,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.inversePrimary,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary,
              blurRadius: 2,
              spreadRadius: 1,
              offset: Offset(-4, 6),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            data["content"],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          subtitle: Text(
            data["email"],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          trailing: isProfile
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "${data["likes"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                )
              : LikeButton(
                  postId: postId,
                  initialLikes: data['likes'],
                  isLiked: (data['likedby'] ?? [])
                      .contains(FirebaseAuth.instance.currentUser?.uid),
                ),
        ),
      ),
    );
  }
}
