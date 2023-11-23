/*import 'package:flutter/material.dart';
import 'package:pantree/components/drawer.dart';
import 'package:pantree/components/theme_notifier.dart';
import 'package:pantree/themes/themes.dart';
import 'package:provider/provider.dart';

class settings_screen extends StatefulWidget {
  const settings_screen({Key? key}) : super(key: key);

  @override
  State<settings_screen> createState() => _settings_screenState();
}

class _settings_screenState extends State<settings_screen> {
  @override
  Widget build(BuildContext context) {

    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      drawer: MyDrawer(
        onSignOutTap: () {},
        onFoodInventoryTap: () {},
        onNutritionTap: () {},
        onSettingsTap: () {},
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              LSection(
                title: "General",
                children: [
                  const ListTiles(
                    title: "User Profile",
                    icon: Icons.person_outline_rounded),
                  ListTiles(
                      title: "Theme",
                      icon: Icons.dark_mode_outlined,
                      trailing: Switch(
                        value: themeNotifier.currentTheme == darkTheme,
                        onChanged: (value) {
                          themeNotifier.toggleTheme();
                        }
                      ),
                  ),
                ],
              ),
              const Divider(),
              const LSection(
                title: "Other",
                children: [
                  ListTiles(
                    title: "About",
                    icon: Icons.info_outline_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListTiles extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  const ListTiles(
  {Key? key, required this.title, required this.icon, this.trailing})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {},
    );
  }
}

class LSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const LSection({
    Key? key,
    this.title,
    required this.children,
}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:pantree/components/theme_notifier.dart';
import 'package:pantree/screens/about_screen.dart';
import 'package:pantree/screens/userprofile_screen.dart';
import 'package:pantree/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class settings_screen extends StatefulWidget {
  const settings_screen({Key? key}) : super(key: key);

  @override
  State<settings_screen> createState() => _settings_screenState();
}

class _settings_screenState extends State<settings_screen> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              LSection(
                title: "General",
                children: [
                  ListTiles(
                    title: "My Profile",
                    icon: Icons.person_outline_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserProfileScreen()),
                      );
                    },
                  ),
                  ListTiles(
                    title: "Theme",
                    icon: Icons.dark_mode_outlined,
                    trailing: Switch(
                      value: themeNotifier.currentTheme == darkTheme,
                      onChanged: (value) {
                        themeNotifier.toggleTheme();
                      },
                    ),
                  ),
                ],
              ),
              const Divider(),
              LSection(
                title: "Other",
                children: [
                  ListTiles(
                    title: "About",
                    icon: Icons.info_outline_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutScreen()),
                      );
                    },
                  ),
                  ListTiles(
                      title: "Logout", icon: Icons.logout, onTap: signOut),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// In the existing file where ListTiles is defined
class ListTiles extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap; // Add this line

  const ListTiles({
    Key? key,
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: onTap, // Call onTap when the ListTile is tapped
    );
  }
}

class LSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const LSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
