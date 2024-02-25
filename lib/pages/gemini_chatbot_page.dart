import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:izhar/pages/home_page.dart';
import 'package:izhar/pages/profile_page.dart';

import '../components/drawer.dart';

class ChatbotIntegration extends StatefulWidget {
  const ChatbotIntegration({Key? key}) : super(key: key);


  @override
  State<ChatbotIntegration> createState() => _ChatbotIntegrationState();
}

class _ChatbotIntegrationState extends State<ChatbotIntegration> {

  final currentUser = FirebaseAuth.instance.currentUser!;
  ChatUser myself = ChatUser(id: '1', firstName: FirebaseAuth.instance.currentUser!.displayName ?? 'User');
  ChatUser bot = ChatUser(id: '2', firstName: 'Emo');
  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _responseController = TextEditingController();


  final CollectionReference<Map<String, dynamic>> _firestoreCollection =
  FirebaseFirestore.instance.collection('geminiMessages');

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _snapshotSubscription;

  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();

    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Listen to changes in the document specific to the current user
    _snapshotSubscription = _firestoreCollection.doc(currentUserId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data['response'] != null && data['response'].isNotEmpty) {
          _responseController.text = data['response'];

          if (!isFirstTime) {
            ChatMessage firestoreResponse = ChatMessage(
              text: data['response'],
              user: bot,
              createdAt: DateTime.now(),
            );
            allMessages.insert(0, firestoreResponse);

            setState(() {});
          }

          isFirstTime = false;
        }
      }
    });
  }

  void sendMessageToFirestore(String prompt) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Add the prompt and response under the document specific to the current user
      await _firestoreCollection.doc(currentUserId).set({
        'prompt': prompt,
        'response': '',
        'startTime': FieldValue.serverTimestamp(),
      });

      _promptController.clear();
      typing.remove(bot);
    } catch (e) {
      print("Error: $e");
    }
  }



  void signOut() {
    FirebaseAuth.instance.signOut();
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

  void goToHomePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text('E M O'),
        actions: [
        IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout)
        ),
        ],
      ),
      drawer: MyDrawer(
        onHomeTap: goToHomePage,
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              typingUsers: typing,
              currentUser: myself,
              onSend: (ChatMessage m) {
                typing.add(bot);
                // Send user message to Firestore
                sendMessageToFirestore(m.text);
                // Add user message to DashChat
                allMessages.insert(0, m);

                setState(() {});
              },
              messages: allMessages,
            ),
          ),
        ],
      ),
    );
  }
}
