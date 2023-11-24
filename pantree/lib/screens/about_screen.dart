import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/icons/pantree_logo.png',
                  width: 120, // Adjust the width as needed
                  height: 120, // Adjust the height as needed
                ),
                const SizedBox(
                    width: 20), // Add some space between the image and text
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Pantree App',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    // Add more details about the app if needed
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Description: Your ultimate food management solution. Pantree helps you manage your pantry, track food items, and discover new recipes based on what you have in stock.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Features:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('• Inventory Management', style: TextStyle(fontSize: 16)),
            const Text('• Recipe Recommendations', style: TextStyle(fontSize: 16)),
            const Text('• Easy Food Tracking', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
