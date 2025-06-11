import 'package:google_maps_flutter/google_maps_flutter.dart';


class Facility {
  final String id;
  final String name;
  final LatLng location;
  final String description;
  final String? openTime;
  final String? closeTime;
  final int? price;

  Facility({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    this.openTime,
    this.closeTime,
    this.price,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id'].toString(),
      name: json['name'],
      location: LatLng(
        double.parse(json['lat']),
        double.parse(json['lng']),
      ),
      description: json['description'] ?? '',
      openTime: json['open_time'],
      closeTime: json['close_time'],
      price: json['price'],


    );
  }
}
