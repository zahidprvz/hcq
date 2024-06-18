import 'package:flutter/material.dart';
import 'package:hcq/screens/game_screen.dart';
import 'package:hcq/utils/colors.dart'; // Import the GameScreen

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Dashboard'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.gamepad), // Replace with your desired icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameScreen()),
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text("This is Dashboard")),
    );
  }
}
