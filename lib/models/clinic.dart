class Clinic {
  final String name;
  final double latitude;
  final double longitude;

  Clinic({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      name: json['tags']?['name'] ?? 'Unnamed Clinic',
      latitude: json['lat'],
      longitude: json['lon'],
    );
  }
}
