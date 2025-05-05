import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String locationName;
  final double distance;
  final double rating;
  final int checkedInUsers;

  LocationCard({
    required this.locationName,
    required this.distance,
    required this.rating,
    required this.checkedInUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.purpleAccent,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  '$distance km away',
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 100,
            color: Colors.grey.shade200,
            // Placeholder for location image
            // In a real implementation you'd use Image.network or similar
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locationName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Open • Closes at 3PM',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    SizedBox(width: 2),
                    Text(
                      '$rating',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  '$checkedInUsers users checked in',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}