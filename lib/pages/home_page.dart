import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:izhar/components/drawer.dart';
import 'package:izhar/components/text_field.dart';
import 'package:izhar/components/wall_post.dart';
import 'package:izhar/helper/helper_methods.dart';
import 'package:izhar/pages/profile_page.dart';

import 'gemini_chatbot_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Current User
  final currentUser = FirebaseAuth.instance.currentUser!;

  //Text Controller
  final textController = TextEditingController();

  //SignOut
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void postMessage() {
    if(textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail' : currentUser.email,
        'Message' : textController.text,
        'TimeStamp' : Timestamp.now(),
        'Likes': [],
      });
    }

    setState(() {
      textController.clear();
    });
  }

  void goToProfilePage() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ProfilePage(),
      ),
    );
  }

  void goToGeminiScreen() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatbotIntegration()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text("Izhar"),
        /**actions: [
          IconButton(
              onPressed: goToGeminiScreen,
              icon: const Icon(Icons.chat_bubble_outline)
          ),
        ],**/
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onEmoTap: goToGeminiScreen,
        onSignOut: signOut,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy(
                      "TimeStamp",
                      descending: false,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: formatDate(post['TimeStamp']),
                           );
                        },
                    );
                  }
                  else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error:${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                  },
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(child: MyTextField(
                    controller: textController,
                    hintText: "Just say it",
                    obscureText: false,
                  ),
                  ),

                  IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.arrow_circle_up)
                  )
                ],
              ),
            ),
        
            Text("Logged in as: ${currentUser.email!}"),
          ],
        ),
      ),
    );
  }
}
