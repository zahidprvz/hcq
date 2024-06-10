import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hcq/screens/add_post_screen.dart';
import 'package:hcq/screens/dashboard_screen.dart';
import 'package:hcq/screens/feed_screen.dart';
import 'package:hcq/screens/profile_screen.dart';
import 'package:hcq/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const DashboardScreen(),
  const SearchScreen(),
  const FeedScreen(),
  const Text('Notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
