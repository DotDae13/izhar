import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:izhar/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  //currentUser
  final currentUser = FirebaseAuth.instance.currentUser!;

  //all users
  final userCollection = FirebaseFirestore.instance.collection("Users");

  //edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text("Edit $field",
          style: const TextStyle(
              color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //Cancel button
          TextButton(
            child: const Text('Cancel' ,
              style: TextStyle(
                  color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),

          //Save Button
          TextButton(
            child: const Text('Save' ,
              style: TextStyle(
                  color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    if(newValue.trim().isNotEmpty) {
      await userCollection
          .doc(currentUser.email)
          .update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Profile Page"),
        backgroundColor: Colors.grey[700],
      ),

      body:StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          // get user data
          if(snapshot.hasData) {
            final userData = snapshot.data!
                .data() as Map<String,
                dynamic>;

            return ListView(
              children: [

                const SizedBox(height: 50),

                const Icon(
                  Icons.person,
                  size: 72,
                ),

                const SizedBox(height: 10),

                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                MyTextBox(
                  text: userData['username'],
                  sectionName: 'username',
                  onPressed: () => editField('username'),
                ),

                MyTextBox(
                  text: userData['bio'],
                  sectionName: 'bio',
                  onPressed: () => editField('bio'),
                ),

                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Posts',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            );
        } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }

          return const Center(child: CircularProgressIndicator(),
          );
          },
      ),
    );
  }
}
