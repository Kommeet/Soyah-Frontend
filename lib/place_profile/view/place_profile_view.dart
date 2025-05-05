import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:sohyah/home/models/place.dart';
import '../../app/view/common/continue_button.dart';

class PlaceProfileView extends StatelessWidget {
  final Place place;

  const PlaceProfileView({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final String apiKey = 'AIzaSyAmQOxV80zIRfCZxDNcmVt83tuW1RlVo40';
    final String photoUrl = _buildPhotoUrl(place.photoReference, apiKey);

    String openStatus = place.isOpen != null
        ? (place.isOpen! ? 'Open' : 'Closed')
        : 'Hours unavailable';
    String closingTime = place.closingTime ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: Image.asset(
            'assets/images/back.png',
            scale: 1.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCard(context, photoUrl),
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 8, right: 4, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Place Name
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // Open/Closing Time, Distance, and Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "$openStatus • ",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: Colors.black),
                            ),
                            if (closingTime.isNotEmpty)
                              Text(
                                "Closes at $closingTime • ",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(color: Colors.black),
                              ),
                            Text(
                              "${place.distance.toStringAsFixed(1)} km away",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              place.rating.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(color: Colors.black),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFFCD29),
                              size: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 16, right: 4, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "View your matches",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Transform.translate(
                            offset: Offset(-10 * index.toDouble(), 0),
                            child: const CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(
                                'https://www.kasandbox.org/programming-images/avatars/marcimus-red.png',
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Frequent Visitors",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Transform.translate(
                            offset: Offset(-10 * index.toDouble(), 0),
                            child: const CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(
                                'https://www.kasandbox.org/programming-images/avatars/marcimus-red.png',
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Image.asset(
                      'assets/images/chat_intro_lable.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: ContinueButtonWidget(
                  label: 'CHECK OUT',
                  width: 150,
                  onTap: () {
                    // GoRouter.of(context).push('/enable_location');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildPhotoUrl(String? photoReference, String apiKey) {
    if (photoReference == null) {
      return 'assets/images/plcbg_1.png';
    }
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=800'
        '&photoreference=$photoReference'
        '&key=$apiKey';
  }

  Widget _buildCard(BuildContext context, String photoUrl) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: place.photoReference != null
                ? Image.network(
                    photoUrl,
                    width: double.infinity,
                    height: 170,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/plcbg_1.png',
                        width: double.infinity,
                        height: 170,
                        fit: BoxFit.cover,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        height: 170,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/plcbg_1.png',
                    width: double.infinity,
                    height: 170,
                    fit: BoxFit.cover,
                  ),
          ),
        ],
      ),
    );
  }
}