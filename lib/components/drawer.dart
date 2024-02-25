import 'package:flutter/material.dart';
import 'package:izhar/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onHomeTap;
  final void Function()? onProfileTap;
  final void Function()? onEmoTap;
  final void Function()? onSignOut;
  const MyDrawer({
    super.key,
    this.onHomeTap,
    this.onProfileTap,
    this.onEmoTap,
    this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),

              ),

              const Text("Developed by(IG): @not_tanwir",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 5,),

              MyListTile(
                icon: Icons.home,
                text: 'H O M E',
                onTap: onHomeTap,
              ),
              MyListTile(icon: Icons.person,
                  text: 'P R O F I L E',
                  onTap: onProfileTap
              ),
              MyListTile(icon: Icons.auto_awesome,
                  text: 'E M O (Under development)',
                  onTap: onEmoTap
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: MyListTile(
                icon: Icons.logout,
                text: 'L O G O U T',
                onTap: onSignOut
            ),
          ),

        ],
      ),

    );
  }
}
