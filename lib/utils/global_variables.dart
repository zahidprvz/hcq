import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hcq/screens/chatbot_screen.dart';
import 'package:hcq/screens/colon_cancer_article_screen.dart';
import 'package:hcq/screens/dashboard_screen.dart';
import 'package:hcq/screens/feed_screen.dart';
import 'package:hcq/screens/notification_screen.dart';

const webScreenSize = 600;
const String mapApiKey = 'AIzaSyCFanwauncnnYJffClDptthcx_QohDLWVY';

List<Widget> homeScreenItems = [
  const DashboardScreen(),
  const NotificationScreen(),
  ChatScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
  const ColonCancerArticlesScreen(),
  // const ProfileCustomizationWidget(),
  const FeedScreen(),
];
