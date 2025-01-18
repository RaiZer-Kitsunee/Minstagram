import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final String postId;
  final int initialLikes;
  final bool isLiked;
  const LikeButton({
    super.key,
    required this.postId,
    required this.initialLikes,
    required this.isLiked,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late bool isLiked;
  late int likes;

  @override
  void initState() {
    isLiked = widget.isLiked;
    likes = widget.initialLikes;

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    scaleAnimation = Tween(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> toggleLike() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final postRef =
        FirebaseFirestore.instance.collection("Posts").doc(widget.postId);

    setState(() {
      if (isLiked) {
        likes--;
      } else {
        likes++;
      }
      isLiked = !isLiked;
    });

    //* animations
    animationController.forward().then((_) => animationController.reverse());

    //* update firebase
    await FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        final snapshot = await transaction.get(postRef);
        final likedBy = List<String>.from(snapshot['likedby'] ?? []);

        if (isLiked) {
          likedBy.add(userId);
        } else {
          likedBy.remove(userId);
        }

        transaction.update(postRef, {
          'likes': likes,
          'likedby': likedBy,
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleLike,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color:
                  isLiked ? Colors.blue : Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 4),
            Text(
              "$likes",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
