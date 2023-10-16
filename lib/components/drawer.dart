import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/components/list_tile.dart';

class MyDrawer extends StatelessWidget {
  final Function()? onSignOutTap;
  const MyDrawer({
    super.key,
    required this.onSignOutTap
  });

  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: MyListTile(
              icon: Icons.logout,
              text: "Logout",
              onTap: signOut
            )
          )
        ],
      )
    );
  }
}