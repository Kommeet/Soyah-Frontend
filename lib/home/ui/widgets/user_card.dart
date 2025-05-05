import 'package:flutter/material.dart';
import '../../models/place.dart';

class UserCard extends StatelessWidget {
  final Place place;

  const UserCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Container(
          padding: const EdgeInsets.all(16), 
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer, 
            borderRadius: BorderRadius.circular(16), 
          ),
          width: double.infinity, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, 
            children: [
             
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      place.name,
                      style: const TextStyle(
                        color: Colors.black, 
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis, 
                      maxLines: 2,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        place.rating.toString(),
                        style: const TextStyle(
                          color: Colors.black, // Changed to black
                          fontSize: 16, // Keep original font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4), // Keep original spacing
                      const Icon(Icons.star, color: Colors.amber, size: 20), // Keep original icon color and size
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16), // Keep original spacing

              // Matches Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "View your matches",
                    style: TextStyle(
                      fontSize: 12, // Keep original font size
                      color: Colors.black, // Changed to black
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 16), // Keep original spacing
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(5, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0), // Add spacing between avatars
                            child: Transform.translate(
                              offset: Offset(-10 * index.toDouble(), 0), // Keep original overlap
                              child: CircleAvatar(
                                radius: 15, // Keep original size
                                backgroundImage: const NetworkImage(
                                  'https://www.kasandbox.org/programming-images/avatars/spunky-sam-green.png',
                                ),
                                child: index == 4 // Show "+X" on the last avatar if more matches
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "+2",
                                            style: TextStyle(
                                              color: Colors.white, // Keep white for contrast
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), // Keep original spacing

              // Frequent Visitors Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Frequent Visitors",
                    style: const TextStyle(
                      fontSize: 12, // Keep original font size
                      color: Colors.black, // Changed to black
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 16), // Keep original spacing
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(5, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0), // Add spacing between avatars
                            child: Transform.translate(
                              offset: Offset(-10 * index.toDouble(), 0), // Keep original overlap
                              child: CircleAvatar(
                                radius: 15, // Keep original size
                                backgroundImage: const NetworkImage(
                                  'https://www.kasandbox.org/programming-images/avatars/marcimus-red.png',
                                ),
                                child: index == 4 // Show "+X" on the last avatar if more visitors
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "+3",
                                            style: TextStyle(
                                              color: Colors.white, // Keep white for contrast
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), // Keep original spacing

              // Check-In Action
              GestureDetector(
                onTap: () {
                  // Add check-in logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Checked in! +10 credits")),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Check In for 10 credits at ${place.distance}",
                      style: const TextStyle(
                        color: Colors.black, // Changed to black
                        fontSize: 16, // Keep original font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8), // Keep original spacing
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.red, // Keep original icon color
                      size: 24, // Keep original icon size
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}