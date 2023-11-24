import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pantree/auth/auth.dart';
import 'package:pantree/firebase_options.dart';
import 'package:pantree/components/theme_notifier.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Key? widgetkey;

  const MyApp({
    super.key,
    this.widgetkey,
  });

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.currentTheme,
        home: const AuthPage());
  }
}
