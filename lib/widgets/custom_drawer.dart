import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hcq/screens/consult_with_doctor.dart';
import 'package:hcq/screens/feed_screen.dart';
import 'package:hcq/screens/notification_screen.dart';
import 'package:hcq/screens/profile_screen.dart';
import 'package:hcq/screens/search_screen.dart';
import 'package:hcq/utils/colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 240,
      backgroundColor: mobileBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: mobileBackgroundColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Image.asset(
                  'assets/HCQ.png',
                  height: 50.0,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.feed),
            title: const Text('Feed'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search for users'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/doctor-icon.png',
              height: 24,
              width: 24,
              color: Colors.white,
            ),
            title: const Text('Consult with Doctor'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConsultWithDoctor()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
