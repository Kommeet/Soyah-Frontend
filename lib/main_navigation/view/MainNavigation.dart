import 'package:flutter/material.dart';

void main() {
  runApp(const MainNavigation());
}

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
            title: const Text('Find a Date'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ],
            expandedHeight: 200.0,
            backgroundColor: Colors.pink.shade100,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hi John!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Let's find yourself the perfect date!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: const [
                      Icon(Icons.credit_score, color: Colors.pink, size: 40),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '575 Credits',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'You can use these points to check in or start a chat.',
                              style: TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  _buildCategoryCard(Icons.location_on, "All Nearby"),
                  _buildCategoryCard(Icons.restaurant, "Restaurants"),
                  _buildCategoryCard(Icons.coffee, "Cafes"),
                  _buildCategoryCard(Icons.hotel, "Hotels"),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                // Mock data for list items
                final placeData = [
                  {
                    'image': 'https://source.unsplash.com/800x600/?restaurant',
                    'name': 'Le Restaurant',
                    'distance': '2 km away',
                    'status': 'Open • Closes at 3PM',
                    'users': '15 users checked in',
                    'rating': 4.9,
                  },
                  {
                    'image': 'https://source.unsplash.com/800x600/?cafe',
                    'name': 'Cloud Cafe',
                    'distance': '2 km away',
                    'status': 'Open • Closes at 3PM',
                    'users': '15 users checked in',
                    'rating': 4.9,
                  },
                ];
                final place = placeData[index % placeData.length];
                return _buildPlaceCard(
                  "",
                  "",
                  "",
                  "",
                  "",
                  "" as double,
                );
              },
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(IconData icon, String label) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.pink.shade50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.pink, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(String imageUrl, String name, String distance, String status,
      String usersCheckedIn, double rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(distance, style: const TextStyle(color: Colors.black54)),
                        Text(status, style: const TextStyle(color: Colors.black54)),
                        Text(usersCheckedIn, style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Icon(Icons.star, color: Colors.amber.shade600),
                      Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
