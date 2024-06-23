import 'package:flutter/material.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/utils/global_variables.dart';
import 'package:hcq/widgets/custom_drawer.dart'; // Import the CustomDrawer widget

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: webBackgroundColor,
        title: Image.asset(
          'assets/HCQ.png',
          height: 50.0,
        ),
        actions: [
          IconButton(
            onPressed: () => navigationTapped(0),
            icon: Icon(
              Icons.dashboard,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(1),
            icon: Icon(
              Icons.notifications,
              color: _page == 1 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(2),
            icon: Image.asset(
              'assets/icons/ai-chatting.png',
              height: 60, // Adjusted height for AI chatting icon
              width: 60, // Adjusted width for AI chatting icon
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(3),
            icon: Icon(
              Icons.article,
              color: _page == 3 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(4),
            icon: Image.asset(
              'assets/icons/community-icon.png',
              height: 30, // Normal icon size
              width: 30, // Normal icon size
              color: _page == 4 ? primaryColor : secondaryColor,
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(), // Use CustomDrawer here
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
    );
  }
}
