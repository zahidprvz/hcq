import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hcq/screens/map_screen2.dart'; // Import your map screen
import 'package:hcq/utils/colors.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  late StreamSubscription<DateTime> _timerSubscription;
  late Stream<QuerySnapshot> _appointmentsStream;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
    _startTimer();
  }

  @override
  void dispose() {
    _timerSubscription.cancel();
    super.dispose();
  }

  void _loadAppointments() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference appointmentsRef = FirebaseFirestore.instance
        .collection('appointments')
        .doc(uid)
        .collection('userAppointments');

    _appointmentsStream = appointmentsRef.snapshots();
  }

  void _startTimer() {
    _timerSubscription = Stream<DateTime>.periodic(
      const Duration(seconds: 1),
      (count) => DateTime.now(),
    ).listen((currentTime) {
      setState(() {}); // Update UI every second
    });
  }

  Future<void> _deleteAppointment(String appointmentId) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference appointmentsRef = FirebaseFirestore.instance
        .collection('appointments')
        .doc(uid)
        .collection('userAppointments');

    try {
      await appointmentsRef.doc(appointmentId).delete();
      print('Appointment deleted successfully');
    } catch (e) {
      print('Error deleting appointment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text('Appointments'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(16),
            child: const Text(
              'You have to schedule the original appointment manually. Here you can find info about nearby locations related to colon clinics, and you can also set timers for appointments.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _appointmentsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: secondaryColor,
                  ));
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No appointments found.'),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapScreen2(),
                              ),
                            );
                          },
                          child: const Text(
                            'Schedule an Appointment',
                            style: TextStyle(color: secondaryColor),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> appointmentData =
                        document.data() as Map<String, dynamic>;
                    DateTime dateTime =
                        DateTime.parse(appointmentData['dateTime']);
                    String appointmentId = document.id;
                    String clinicName = appointmentData['clinicName'];
                    String formattedDateTime =
                        DateFormat('MMM dd, yyyy - hh:mm:ss a')
                            .format(dateTime);

                    // Calculate time left for appointment
                    Duration timeLeft = dateTime.difference(DateTime.now());
                    String timeLeftString =
                        '${timeLeft.inHours}h ${timeLeft.inMinutes.remainder(60)}m ${timeLeft.inSeconds.remainder(60)}s';

                    if (timeLeft.inSeconds <= 0) {
                      // Appointment time has passed
                      _deleteAppointment(appointmentId);
                    }

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        title: Text(
                          clinicName,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date & Time: $formattedDateTime',
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              'Time Left: $timeLeftString',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: mobileBackgroundColor,
                                title: const Text('Delete Appointment'),
                                content: const Text(
                                    'Are you sure you want to delete this appointment?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: secondaryColor),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _deleteAppointment(appointmentId);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
