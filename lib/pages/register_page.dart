import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  void signUp() async {
    showDialog(context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
    );

    if(passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context);
      displayMessage("Password don't match!");
      return;
    }

    try {
      //create the user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text
      );

      FirebaseFirestore.instance
      .collection("Users")
      .doc(userCredential.user!.email!)
      .set({
        'username' : emailTextController.text.split('@')[0], //initial username
        'bio' : 'Empty bio..' //initially empty bio
      });

      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog
      (context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(message),
          ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
          
                  //logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),
          
                  const SizedBox(height: 50),
          
                  //Welcome Message
                  Text(
                    "Let's create an account for you",
                    style: TextStyle(
                        color: Colors.grey[700]
                    ),
                  ),
          
                  const SizedBox(height: 25),
          
                  //Email TextField
                  MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
          
                  const SizedBox(height: 10),
          
                  //Password TextField
                  MyTextField(
                    controller: passwordTextController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
          
                  const SizedBox(height: 10),
          
                  //Confirm Password TextField
                  MyTextField(
                    controller: confirmPasswordTextController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
          
                  const SizedBox(height: 10),
          
                  //SignUp Button
                  MyButton(
                      onTap: signUp,
                      text: 'Sign Up'
                  ),
          
                  const SizedBox(height: 25),
          
                  //Go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                            color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login Now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //go to register page
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
