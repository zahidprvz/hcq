import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcq/screens/adventure_game_screen.dart';
import 'package:hcq/screens/chatbot_screen.dart';
import 'package:hcq/screens/user_quiz_screen.dart';
import 'package:intl/intl.dart';
import 'package:hcq/screens/appointment_screen.dart';
import 'package:hcq/screens/colon_cancer_article_screen.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/widgets/challenges_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool hasAppointments = false;
  String appointmentDetails = '';

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference appointmentsRef = FirebaseFirestore.instance
        .collection('appointments')
        .doc(uid)
        .collection('userAppointments');

    appointmentsRef.get().then((snapshot) {
      _checkAppointmentsStatus(snapshot);
    });
  }

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
            icon: const Icon(Icons.gamepad),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdventureGame()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ChallengesSelectionCard(),
            const SizedBox(height: 20.0),
            hasAppointments
                ? _buildAppointmentCard()
                : _buildScheduleAppointmentCard(),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ColonCancerArticlesScreen(),
                  ),
                );
              },
              child: const Text(
                'View All Educational Articles',
                style: TextStyle(color: secondaryColor),
              ),
            ),
            const SizedBox(height: 20.0),
            _buildAIChatCard(),
            const SizedBox(height: 20.0),
            _buildQuizCard(), // Add the quiz card here
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Appointment Details:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              appointmentDetails,
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleAppointmentCard() {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Schedule an Appointment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'You have no appointments scheduled. Schedule one now to manage your health effectively.',
              style: TextStyle(fontSize: 14.0, color: Colors.black),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppointmentsScreen(),
                  ),
                );
              },
              child: const Text(
                'Schedule Appointment',
                style: TextStyle(color: secondaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIChatCard() {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chat with AI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Have a chat with our AI assistant to get answers to your queries.',
              style: TextStyle(fontSize: 14.0, color: Colors.black),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to AI Chat Screen
                // Replace `ChatScreen` with your actual AI chat screen widget
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      uid: FirebaseAuth.instance.currentUser!.uid,
                    ),
                  ),
                );
              },
              child: const Text(
                'Start Chat',
                style: TextStyle(color: secondaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard() {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Give a Quiz and Know Yourself Better',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Take a quiz to understand more about your health and get personalized insights.',
              style: TextStyle(fontSize: 14.0, color: Colors.black),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
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
              child: const Text(
                'Start Quiz',
                style: TextStyle(color: secondaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkAppointmentsStatus(QuerySnapshot snapshot) {
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot document = snapshot.docs.first;
      Map<String, dynamic> appointmentData =
          document.data() as Map<String, dynamic>;
      DateTime dateTime = DateTime.parse(appointmentData['dateTime']);
      String clinicName = appointmentData['clinicName'];
      String formattedDateTime =
          DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);

      // Calculate time left for appointment
      Duration timeLeft = dateTime.difference(DateTime.now());
      String timeLeftString =
          '${timeLeft.inHours}h ${timeLeft.inMinutes.remainder(60)}m ${timeLeft.inSeconds.remainder(60)}s';

      if (timeLeft.inSeconds <= 0) {
        // Appointment time has passed
        _deleteAppointment(document.id);
      }

      setState(() {
        hasAppointments = true;
        appointmentDetails =
            'Clinic: $clinicName\nDate & Time: $formattedDateTime\nTime Left: $timeLeftString';
      });
    } else {
      setState(() {
        hasAppointments = false;
      });
    }
  }

  void _deleteAppointment(String appointmentId) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference appointmentsRef = FirebaseFirestore.instance
        .collection('appointments')
        .doc(uid)
        .collection('userAppointments');

    try {
      await appointmentsRef.doc(appointmentId).delete();
      // print('Appointment deleted successfully');
    } catch (e) {
      // print('Error deleting appointment: $e');
    }
  }
}
