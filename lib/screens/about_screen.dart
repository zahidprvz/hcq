import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hcq/utils/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key});

  Future<void> _launchEmail(String email) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    final String emailAddress = _emailLaunchUri.toString();
    if (await canLaunch(emailAddress)) {
      await launch(emailAddress);
    } else {
      throw 'Could not launch email';
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri _phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunch(_phoneLaunchUri.toString())) {
      await launch(_phoneLaunchUri.toString());
    } else {
      throw 'Could not launch phone';
    }
  }

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Email: info@globalhealthdiagnostic.com',
                    style: TextStyle(
                        //
                        //decoration: TextDecoration.underline,
                        ),
                  ),
                ),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () => _launchPhone('+13465036713'),
                  child: const Text(
                    'Phone: +1 346-503-6713',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
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
