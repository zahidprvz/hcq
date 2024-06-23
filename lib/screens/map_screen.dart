import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Clinics'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getCurrentLocation(),
        builder: (context, AsyncSnapshot<LatLng> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No location data.'));
          } else {
            LatLng currentLocation = snapshot.data!;
            return FutureBuilder(
              future: _getNearbyClinics(currentLocation),
              builder: (context, AsyncSnapshot<List<Marker>> clinicsSnapshot) {
                if (clinicsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (clinicsSnapshot.hasError) {
                  return Center(child: Text('Error: ${clinicsSnapshot.error}'));
                } else if (!clinicsSnapshot.hasData ||
                    clinicsSnapshot.data!.isEmpty) {
                  return const Center(child: Text('No clinics found nearby.'));
                } else {
                  List<Marker> clinicsMarkers = clinicsSnapshot.data!;
                  return FlutterMap(
                    options: MapOptions(
                      initialCenter: currentLocation,
                      initialZoom: 13.0,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.doubleTapZoom,
                      ),
                    ),
                    children: [
                      openStreetMapTileLayer,
                      MarkerLayer(
                        markers: clinicsMarkers,
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<LatLng> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting current location: $e');
      return const LatLng(
          38.8951, -77.0364); // Default location (Washington, DC)
    }
  }

  Future<List<Marker>> _getNearbyClinics(LatLng center) async {
    try {
      const String overpassUrl = 'https://overpass-api.de/api/interpreter';
      final String query = '''
        [out:json];
        node
          (around:5000,${center.latitude},${center.longitude})
          ["amenity"="cancer-clinic"];
        out body;
      ''';

      final response = await http.post(
        Uri.parse(overpassUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'data': query},
      );

      if (response.statusCode == 200) {
        List<dynamic> elements = jsonDecode(response.body)['elements'];
        return elements.map((element) {
          double lat = element['lat'];
          double lon = element['lon'];
          return Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(lat, lon),
            child: const Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 60,
            ),
          );
        }).toList();
      } else {
        throw Exception('Failed to load clinics');
      }
    } catch (e) {
      print('Error getting nearby clinics: $e');
      return []; // Return empty list if there's an error
    }
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.hcq.example',
    );
