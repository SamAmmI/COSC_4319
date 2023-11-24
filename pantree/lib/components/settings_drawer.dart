import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantree/components/list_tile.dart';
import 'package:pantree/components/theme_notifier.dart';
import 'package:pantree/themes/themes.dart';
import 'package:provider/provider.dart';

class Settings_Drawer extends StatefulWidget {
  final Function()? onSettingsTap;

  const Settings_Drawer({
    Key? key,
    required this.onSettingsTap,
  }) : super(key: key);

  @override
  State<Settings_Drawer> createState() => _Settings_DrawerState();
}

class _Settings_DrawerState extends State<Settings_Drawer> {
  final GlobalKey<DrawerControllerState> _drawerKey =
      GlobalKey<DrawerControllerState>();

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void toggleTheme(ThemeNotifier themeNotifier) {
    themeNotifier.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();

    return Drawer(
      key: _drawerKey,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 50), // Add padding at the top
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: MyListTile(
                  icon: Icons.logout,
                  text: "Logout",
                  onTap: signOut,
                ),
              ),
            ],
          ),
          IconButton(
            icon: themeNotifier.currentTheme == lightTheme
                ? Icon(Icons.wb_sunny, color: Theme.of(context).iconTheme.color)
                : Icon(Icons.nights_stay,
                    color: Theme.of(context).iconTheme.color),
            onPressed: () {
              toggleTheme(themeNotifier);
            },
          ),
        ],
      ),
    );
  }
}
