import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/utils/global_variables.dart';
import 'package:hcq/widgets/custom_drawer.dart'; // Import the CustomDrawer widget

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(), // Use CustomDrawer here
      body: homeScreenItems[_page], // Display the current page
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard,
              size: 24, // Normal icon size
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              size: 24, // Normal icon size
              color: _page == 1 ? primaryColor : secondaryColor,
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/ai-chatting.png',
              height: 60, // Adjusted height for AI chatting icon
              width: 60, // Adjusted width for AI chatting icon
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
            label: 'Ask AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.article,
              size: 24, // Normal icon size
              color: _page == 3 ? primaryColor : secondaryColor,
            ),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/community-icon.png',
              height: 30, // Normal icon size
              width: 30, // Normal icon size
              color: _page == 4 ? primaryColor : secondaryColor,
            ),
            label: 'Community',
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
