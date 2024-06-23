import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hcq/utils/global_variables.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'package:hcq/utils/colors.dart'; // Adjust the import path as per your project structure

class MapScreen2 extends StatefulWidget {
  const MapScreen2({Key? key}) : super(key: key);

  @override
  State<MapScreen2> createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen2> {
  final Location locationController = Location();
  LatLng? currentPosition;
  Set<Marker> markers = {};
  bool _isInfoBoxVisible = false;
  String _clinicInfo = '';
  String _clinicAddress = '';
  String _clinicPhone = '';
  String _clinicWebsite = '';
  BitmapDescriptor? customIcon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await fetchLocationUpdates();
    });
    setCustomMarkerIcon();
  }

  void setCustomMarkerIcon() async {
    customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(
        size: Size(58, 58),
      ),
      'assets/icons/doctor-icon.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          currentPosition == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: secondaryColor,
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentPosition!,
                    zoom: 13.0,
                  ),
                  markers: markers,
                  onTap: (LatLng position) {
                    setState(() {
                      _isInfoBoxVisible = false;
                    });
                  },
                ),
          if (_isInfoBoxVisible)
            Positioned(
              bottom: 50,
              left: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: mobileBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Clinic Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: secondaryColor, // Use secondary color
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _clinicInfo,
                        style: const TextStyle(
                          color: secondaryColor, // Use secondary color
                        ),
                      ),
                      Text(
                        'Address: $_clinicAddress',
                        style: const TextStyle(
                          color: secondaryColor, // Use secondary color
                        ),
                      ),
                      Text(
                        'Phone: $_clinicPhone',
                        style: const TextStyle(
                          color: secondaryColor, // Use secondary color
                        ),
                      ),
                      Text(
                        'Website: $_clinicWebsite',
                        style: const TextStyle(
                          color: secondaryColor, // Use secondary color
                        ),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          _scheduleMeeting();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              secondaryColor, // Use secondary color
                        ),
                        child: const Text(
                          'Schedule a Meeting',
                          style: TextStyle(
                            color: Colors.white, // Button text color
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isInfoBoxVisible = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              secondaryColor, // Use secondary color
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.white, // Button text color
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        fetchNearbyClinics(currentPosition!);
      }
    });
  }

  Future<void> fetchNearbyClinics(LatLng center) async {
    const String apiKey = mapApiKey; // Replace with your Google Maps API key
    const String apiUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

    final String requestUrl =
        '$apiUrl?location=${center.latitude},${center.longitude}&radius=5000&type=hospital&keyword=clinic&key=$apiKey';

    print('Request URL: $requestUrl'); // Print the request URL for debugging

    try {
      final response = await http.get(Uri.parse(requestUrl));

      print(
          'fetchNearbyClinics response: ${response.body}'); // Print the response body

      if (response.statusCode == 200) {
        List<dynamic> results = jsonDecode(response.body)['results'];
        if (results.isEmpty) {
          print('No clinics found.');
        }
        Set<Marker> newMarkers = results.map((result) {
          double lat = result['geometry']['location']['lat'];
          double lon = result['geometry']['location']['lng'];
          String name = result['name'];
          String address = result['vicinity'];
          String placeId = result['place_id'];

          return Marker(
            markerId: MarkerId(placeId),
            position: LatLng(lat, lon),
            infoWindow: InfoWindow(
              title: name,
              snippet: address,
            ),
            icon: customIcon ??
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            onTap: () {
              print('Marker tapped: $name, $address, $placeId');
              showClinicDetails(placeId);
            },
          );
        }).toSet();

        setState(() {
          markers = newMarkers;
        });
      } else {
        print('Failed to load clinics: ${response.body}');
      }
    } catch (e) {
      print('Error fetching nearby clinics: $e');
    }
  }

  void showClinicDetails(String placeId) async {
    const String apiKey = mapApiKey; // Replace with your Google Maps API key
    const String apiUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';

    final String requestUrl = '$apiUrl?place_id=$placeId&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(requestUrl));

      print(
          'showClinicDetails response: ${response.body}'); // Print the response body

      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body)['result'];
        String name = result['name'];
        String address = result['formatted_address'];
        String phoneNumber = result['formatted_phone_number'] ?? 'N/A';
        String website = result['website'] ?? 'N/A';

        setState(() {
          _isInfoBoxVisible = true;
          _clinicInfo = name;
          _clinicAddress = address;
          _clinicPhone = phoneNumber;
          _clinicWebsite = website;
        });
      } else {
        print('Failed to load clinic details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching clinic details: $e');
    }
  }

  void _scheduleMeeting() {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Schedule a Meeting'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDateTimePicker(
                labelText: 'Date',
                onChanged: (value) {
                  setState(() {
                    selectedDate = value;
                  });
                },
                initialDate: DateTime.now(),
              ),
              _buildDateTimePicker(
                labelText: 'Time',
                onChanged: (value) {
                  setState(() {
                    selectedTime = value;
                  });
                },
                initialDate: DateTime.now(),
                isTimePicker: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (selectedDate != null && selectedTime != null) {
                  DateTime combinedDateTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );
                  String formattedDateTime =
                      DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
                  Navigator.pop(context);
                  _storeAppointment(_clinicInfo, formattedDateTime);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select both date and time.'),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: secondaryColor, // Use secondary color
              ),
              child: const Text('Schedule'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: secondaryColor, // Use secondary color
              ),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to build DateTimePicker
  Widget _buildDateTimePicker({
    required String labelText,
    required Function(dynamic) onChanged,
    required DateTime initialDate,
    bool isTimePicker = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              color: secondaryColor, // Use secondary color
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              dynamic pickedValue;
              if (isTimePicker) {
                pickedValue = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(initialDate),
                );
              } else {
                pickedValue = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
              }
              if (pickedValue != null) {
                onChanged(pickedValue);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor, // Use secondary color
            ),
            child: Text(
              isTimePicker ? 'Select Time' : 'Select Date',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _storeAppointment(String clinicName, String dateTime) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference appointmentsRef = FirebaseFirestore.instance
          .collection('appointments')
          .doc(uid)
          .collection('userAppointments');

      Map<String, dynamic> appointmentData = {
        'clinicName': clinicName,
        'dateTime': dateTime,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await appointmentsRef.add(appointmentData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment scheduled successfully!')),
      );
    } catch (e) {
      print('Error storing appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Failed to schedule appointment. Please try again later.'),
        ),
      );
    }
  }
}
