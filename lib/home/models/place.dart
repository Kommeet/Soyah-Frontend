// class Place {
//   final String name;
//   final String distance;
//   final double rating;
//   final int usersCheckedIn;

//   Place({
//     required this.name,
//     required this.distance,
//     required this.rating,
//     required this.usersCheckedIn,
//   });
// }




import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Place extends Equatable {
  final String name;
  final String type;
  final String address;
  final double distance;
  final double lat;
  final double lng;
  final double rating;
  final int usersCheckedIn;
  final String placeId; // <-- Added this field
  final String? photoReference;
  final bool? isOpen; // New field for open status
  final String? closingTime;

  const Place({
    required this.name,
    required this.type,
    required this.address,
    required this.distance,
    required this.lat,
    required this.lng,
    required this.placeId, 
    this.rating = 0.0,
    this.usersCheckedIn = 0,
    this.photoReference,
    this.isOpen,
    this.closingTime,

  });

  @override
  List<Object> get props =>
      [name, type, address, distance, lat, lng, placeId];

  double get latitude => lat;
  double get longitude => lng;
}