import 'package:flutter/material.dart';
import 'package:izhar/components/button.dart';
import 'package:izhar/components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                  "Welcome back, you have been missed!",
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

                //SignIn Button
                MyButton(
                    onTap: widget.onTap,
                    text: 'Sign In'
                ),

                const SizedBox(height: 10),

                //Go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue
                        ),

                      ),
                    ),
                  ],
                )

                //go to register page
              ],
            ),
          ),
        ),
      ),
    );
  }
}
