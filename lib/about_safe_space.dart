import 'package:flutter/material.dart';

class AboutSafeSpace extends StatelessWidget {
  const AboutSafeSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About SafeSpace'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Welcome to SafeSpace!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'SafeSpace is designed to provide a secure and supportive environment for individuals seeking mental health and wellness resources. Our mission is to empower users to take control of their mental health journey through personalized tools and community support.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Text(
              'Features:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '- Access to mental health resources\n'
                  '- Community support and connection\n'
                  '- Personalized wellness tracking\n'
                  '- Privacy-focused design\n'
                  '- Period Tracker\n'
                  '- Fertility Tracker\n'
                  '- Mood Tracker (with notes post-it board)\n'
                  '- Water Intake Tracker\n'
                  '- Sleep Tracker\n'
                  '- Exercise Log\n'
                  '- Step Counter',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Text(
              'Emergency Services:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '- 911 Calling\n'
                  '- Text Services\n'
                  '- Nearby Shelters\n'
                  '- Food Pantries\n'
                  '- Suicide Hotlines\n'
                  '- Domestic Violence Hotlines',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Text(
              'Contact Us:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'If you have any questions or feedback, feel free to reach out to us at support@safespacetracker.com.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Text(
              'Thank you for being a part of the SafeSpace community!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
