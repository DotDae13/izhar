import 'comments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:izhar/components/comment_button.dart';
import 'package:izhar/components/like_button.dart';
import 'package:izhar/helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  const WallPost({super.key,
    required this.message,
    required this.user,
    required this.time,
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

  //comment text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
    FirebaseFirestore.instance.collection(
        'User Posts')
        .doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }

  }
  
  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy" : currentUser.email,
      "CommentTime" : Timestamp.now()
        });
  }
  
  void showCommentDialog() {
    showDialog
      (context: context,
        builder: (context) => AlertDialog(
          title: const Text("Add Comment"),
          content: TextField(
            controller: _commentTextController,
            decoration: const InputDecoration(hintText: "Write a comment.."),
          ),
          actions: [
            //post button
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _commentTextController.clear();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                addComment(_commentTextController.text);
                Navigator.pop(context);
                _commentTextController.clear();
              },
              child: const Text("Post"),
            ),
          ],
        ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //wallpost
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //message
              Text(widget.message),

              const SizedBox(height: 5),

              //user
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      widget.user,
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    Text(
                      " • ",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    Text(
                      widget.time,
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),


            ],
          ),

          const SizedBox(height: 20,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LIKE
              Column(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),

                  const SizedBox(height: 5),
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],

              ),

              const SizedBox(width: 10),

              //COMMENT
              Column(
                children: [
                  CommentButton(onTap: showCommentDialog),

                  const SizedBox(height: 5),
                  const Text(
                    '',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20,),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore
                .instance.collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;
                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentedBy"],
                    time: formatDate(commentData["CommentTime"]),
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}

