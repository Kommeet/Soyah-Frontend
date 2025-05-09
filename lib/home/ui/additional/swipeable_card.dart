import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:sohyah/home/models/place.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

class SwipeableCard extends StatefulWidget {
  final Place place;
  final String userId;

  const SwipeableCard({super.key, required this.place, required this.userId});

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard> {
  late String photoUrl;
  final String apiKey = 'AIzaSyAmQOxV80zIRfCZxDNcmVt83tuW1RlVo40';
  List<String> frequentVisitorImages = [];

  @override
  void initState() {
    super.initState();
    photoUrl = _buildPhotoUrl(widget.place.photoReference);
    _fetchFrequentVisitors();
    _fetchPlaceDetails();
  }

  Future<void> _fetchPlaceDetails() async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=${widget.place.placeId}&fields=rating,opening_hours&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final result = data['result'];
      if (result != null) {
        setState(() {
          widget.place.rating = result['rating']?.toDouble() ?? 0.0;
          widget.place.isOpen = result['opening_hours']?['open_now'];

          final periods = result['opening_hours']?['periods'];
          if (periods != null) {
            final now = DateTime.now();
            final today = now.weekday % 7;
            final todayPeriod = periods.firstWhere(
                (p) => p['open']['day'] == today,
                orElse: () => null);

            if (todayPeriod != null) {
              final closeTime = todayPeriod['close']['time'];
              widget.place.closingTime =
                  '${closeTime.substring(0, 2)}:${closeTime.substring(2)}';
            }
          }
        });
      }
    }
  }

  Future<void> _fetchFrequentVisitors() async {
  final response = await http.get(
    Uri.parse(
        'https://soyah-go-wildflower-905-holy-morning-7136.fly.dev/api/frequent-visitors?place_id=${widget.place.placeId}'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> visitors = data['frequentVisitors'] ?? [];
    setState(() {
      frequentVisitorImages = visitors
          .where((visitor) =>
              visitor['profile_picture_url'] != null &&
              visitor['profile_picture_url'].isNotEmpty)
          .map((visitor) => visitor['profile_picture_url'] as String)
          .toList();
    });
  } else {
    setState(() {
      frequentVisitorImages = [];
    });
  }
}

  Future<void> _checkIn(String placeId, String userId) async {
    final authRepository = context.read<AuthenticationRepository>();
    final profilePictureUrl = authRepository.getProfilePictureUrl();

    final response = await http.post(
      Uri.parse(
          'https://soyah-go-wildflower-905-holy-morning-7136.fly.dev/api/check-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'place_id': placeId,
        'user_id': userId,
        'image': profilePictureUrl, 
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Checked in! +10 credits',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Check-in failed: ${response.reasonPhrase}')),
      );
    }
  }

  String _buildPhotoUrl(String? photoReference) {
    if (photoReference == null) {
      return 'assets/no_image.jpg';
    }
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=800'
        '&photoreference=$photoReference'
        '&key=$apiKey';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width * 0.85,
      child: CardSwiper(
        cardsCount: 2,
        isLoop: true,
        cardBuilder: (context, index, _, __) {
          if (index == 0) {
            return _buildPlaceCard(context);
          } else {
            return _buildUserCard(context);
          }
        },
        onSwipe: (previousIndex, currentIndex, direction) {
          return true;
        },
      ),
    );
  }

  Widget _buildPlaceCard(BuildContext context) {
    final place = widget.place;

    String openStatus = place.isOpen != null
        ? (place.isOpen! ? 'Open' : 'Closed')
        : 'Hours unavailable';
    String closingTime = place.closingTime ?? '';

    return GestureDetector(
      onTap: () async {
        bool? confirmCheckIn = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text(
              'Confirm Check-In',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'This action will deduct 10 credits from your account.\n\nDo you want to proceed?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text('Confirm'),
              ),
            ],
          ),
        );

        if (confirmCheckIn == true) {
          await _checkIn(widget.place.placeId, widget.userId);
          GoRouter.of(context).push('/place_profile', extra: {'place': place});
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              widget.place.photoReference != null
                  ? Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/plcbg_1.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    )
                  : Image.asset(
                      'assets/images/plcbg_1.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_pin,
                          size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        "${place.distance.toStringAsFixed(1)} km away",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          closingTime.isNotEmpty
                              ? '$openStatus • Closes at $closingTime'
                              : openStatus,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: Colors.white),
                        ),
                        Row(
                          children: [
                            Text(
                              place.rating.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.star,
                                color: Color(0xFFFFCD29), size: 14),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${place.usersCheckedIn} users checked in",
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Colors.white),
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

  Widget _buildUserCard(BuildContext context) {
    final place = widget.place;

    final List<String> matchImages = [
      'https://www.kasandbox.org/programming-images/avatars/marcimus-purple.png',
      'https://www.kasandbox.org/programming-images/avatars/marcimus-orange.png',
      'https://www.kasandbox.org/programming-images/avatars/marcimus.png',
      'https://www.kasandbox.org/programming-images/avatars/marcimus-red.png',
      'https://www.kasandbox.org/programming-images/avatars/marcimus-purple.png',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  place.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Text(
                    place.rating.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "View Your Matches",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.black,
                    ),
              ),
              SizedBox(
                width: 150,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      matchImages.length,
                      (index) {
                        return Transform.translate(
                          offset: Offset(-10 * index.toDouble(), 0),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(matchImages[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Frequent Visitors",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.black,
                    ),
              ),
              SizedBox(
                width: 150,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      frequentVisitorImages.isNotEmpty
                          ? frequentVisitorImages.length
                          : 1,
                      (index) {
                        return Transform.translate(
                          offset: Offset(-10 * index.toDouble(), 0),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: frequentVisitorImages.isNotEmpty
                                ? NetworkImage(frequentVisitorImages[index])
                                : const AssetImage('assets/no_image.jpg')
                                    as ImageProvider,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Checked in! +10 credits",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push(
                      '/place_profile',
                      extra: {'place': place},
                    );
                  },
                  child: const Text(
                    "Check In for 10 credits",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 16,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/back.png',
                  scale: 1.3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}