import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hcq/screens/chatbot_screen.dart';
import 'package:hcq/screens/dashboard_screen.dart';
import 'package:hcq/screens/feed_screen.dart';
import 'package:hcq/screens/notification_screen.dart';
import 'package:hcq/screens/profile_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const DashboardScreen(),
  const NotificationScreen(),
  ChatBotScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
  const FeedScreen(),
];
