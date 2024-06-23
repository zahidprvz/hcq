import 'package:flutter/material.dart';
import 'package:hcq/utils/colors.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text('About HCQ'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Global Health Diagnostics (GHDx)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Welcome to Global Health Diagnostics (GHDx), your personalized health companion!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Purpose of the App:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Global Health Diagnostics (GHDx) aims to provide users with accurate and timely health information, helping them monitor their health conditions, track medical history, and manage health-related data conveniently on their mobile devices.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Key Features:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              '- Personal health profile management\n'
              '- Health data tracking (e.g., medications, allergies)\n'
              '- Appointment reminders and scheduling\n'
              '- Emergency contacts and medical history storage\n'
              '- Health tips and articles',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Text(
              'About Global Health Diagnostics (GHDx) Team:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Global Health Diagnostics (GHDx) is developed and maintained by a team of passionate professionals dedicated to improving healthcare access and empowering individuals to take charge of their health journey.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Contact Us:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'For any questions, feedback, or support, please contact us at:\n'
              'Email: Info@ghmigroup.com\n'
              'Phone: +1 (281) 547-2572',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Copyright Global Health Diagnostics (GHDx) 2024',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
