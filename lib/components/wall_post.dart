import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:izhar/components/like_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  WallPost({super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
//user
  final currentUser = FirebaseAuth.instance.currentUser!;

  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Column(
            children: [
              LikeButton(
                  isLiked: isLiked,
                  onTap: toggleLike,
              )
            ],

          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[500]),
              ),
              const SizedBox(height: 5),
              Text(widget.message),
            ],
          )
        ],
      ),
    );
  }
}

