import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcq/screens/about_screen.dart';
import 'package:hcq/screens/adventure_game_screen.dart';
import 'package:hcq/screens/feed_screen.dart';
import 'package:hcq/screens/map_screen2.dart';
import 'package:hcq/screens/notification_screen.dart';
import 'package:hcq/screens/profile_screen.dart';
import 'package:hcq/screens/search_screen.dart';
import 'package:hcq/screens/user_quiz_screen.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/widgets/profile_customization_widget.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String _displayName = '';
  String _profileImageUrl = ''; // Placeholder for profile image URL

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          _displayName = snapshot.data()?['username'] ?? '';
          _profileImageUrl = snapshot.data()?['photoUrl'] ?? '';
        });
      }
    }
  }

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
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
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(_profileImageUrl),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hi, $_displayName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
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
          // ListTile(
          //   leading: Image.asset(
          //     'assets/icons/doctor-icon.png',
          //     height: 24,
          //     width: 24,
          //     color: Colors.white,
          //   ),
          //   title: const Text('Consult with Doctor'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const DoctorsScreen()),
          //     );
          //   },
          // ),
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
            leading: const Icon(Icons.location_pin),
            title: const Text('Locate Clinic Nearby'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapScreen2()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.gamepad),
            title: const Text('Play Game'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdventureGame(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Take Quiz'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                    quizFilePath: 'assets/quiz_question_answers.json',
                  ),
                ),
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
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfileCustomizationWidget()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.domain_rounded),
            title: const Text('About the App'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
