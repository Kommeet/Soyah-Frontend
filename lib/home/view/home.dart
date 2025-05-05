import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../app/view/common/app_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _NearbyOptionsState createState() => _NearbyOptionsState();
}

class _NearbyOptionsState extends State<Home> {
  int selectedIndex = 0;
  int _selectedIndexBottomNavi = 0;
   late IconData icon;
   late String title;

  final List<Widget> _pages = [
    Center(child: Text('Places Page', style: TextStyle(fontSize: 20))),
    Center(child: Text('Map Page', style: TextStyle(fontSize: 20))),
    Center(child: Text('Requests Page', style: TextStyle(fontSize: 20))),
    Center(child: Text('Chat Page', style: TextStyle(fontSize: 20))),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndexBottomNavi = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const collapsedBarHeight = 60.0;
    const expandedBarHeight = 270.0;
    int _currentIndex = 0;

    return Scaffold(
      appBar: GlobalAppBar(
        bgColour: Theme.of(context).colorScheme.primaryContainer,
        ctx: context,
        leadingWidget: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black87,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        leadingCallBack: () {},
        actionWidget: IconButton(
          icon: Image.asset(
            'assets/images/user_ic.png',
            scale: 1.3,
          ),
          onPressed: () {
            // do something
          },
        ),
      ),


      drawer: Drawer(
        child: Container(
          color: Color(0xFFFF715B),
          padding: EdgeInsets.zero,// Background color of the drawer
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 80,
                padding: EdgeInsets.zero,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF715B),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:Image.asset(
                      'assets/images/ic_drawe_star.png', // Path to your image
                      width: 30,
                      height: 22,
                      color: null, // Prevents color overlay
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              _buildDrawerItem(
                img_path: 'assets/images/menu_ic_place.png',
                title: 'Places',
                onTap: () {
                  // Handle navigation
                },
              ),
              _buildDrawerItem(
                img_path: 'assets/images/menu_ic_map.png',
                title: 'Map',
                onTap: () {
                  // Handle navigation
                },
              ),
              _buildDrawerItem(
                img_path: 'assets/images/menu_ic_chat.png',
                title: 'Request',
                onTap: () {
                  // Handle navigation
                },
              ),
              _buildDrawerItem(
                img_path: 'assets/images/menu_ic_request.png',
                title: 'Chat',
                onTap: () {
                  // Handle navigation
                },
              ),
              _buildDrawerItem(
                img_path: 'assets/images/menu_ic_acc.png',
                title: 'Account',
                onTap: () {
                  // Handle navigation
                },
              ),
              Spacer(), // Push the logout button to the bottom
              const Divider(
                color: Colors.black,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              _buildDrawerItem(
                img_path: 'assets/images/logout.png',
                title: 'Logout',
                onTap: () {
                  // Handle logout
                },
              ),
            ],
          ),
        ),
      ),
    // drawer: buildDrawer(context),

      body: Stack(
        children: [
          // Background layer
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    //  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stack starting
                        Stack(
                          children: [
                            // Hi Jhone Container starting
                            Container(
                              width: double.infinity,
                              height: 172,
                              padding: const EdgeInsets.only(
                                  left: 18, top: 0.0, right: 18, bottom: 0.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                              ),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Hi Jhone!",
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .findYourDateTitle,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(
                                            color: const Color(0xFFFF715B)),
                                  ),
                                ],
                              ),
                            ),
                            // Hi Jhone Container ending

                            // You are at Box Container starting
                            Container(
                              margin: const EdgeInsets.only(top: 100),
                              height: 120,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 50,
                                        spreadRadius: 1,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  // You are at Box starting
                                  child: Row(
                                    children: [
                                      // Location Section
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.location_pin,
                                                    color: Colors.purple,
                                                    size: 12),
                                                SizedBox(width: 4),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .youAreAt,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 14),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .cloudCafe,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      color: Colors.black),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .checkOut,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge!
                                                      .copyWith(
                                                          color:
                                                              Colors.redAccent),
                                                ),
                                                SizedBox(width: 4),
                                                const Icon(Icons.logout,
                                                    color: Colors.redAccent,
                                                    size: 18),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Divider
                                      Container(
                                        height: 60,
                                        width: 1,
                                        color:
                                            Colors.redAccent.withOpacity(0.3),
                                      ),
                                      SizedBox(width: 20),
                                      // Credits Section
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const ImageIcon(
                                                    AssetImage(
                                                        "assets/images/crown.png"),
                                                    size: 10,
                                                    color: Colors.purple),
                                                SizedBox(width: 4),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .youHave,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .credits,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      color: Colors.black),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .userThesePoints,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // You are at Box ending
                                ),
                              ),
                            ),
                            // You are at Box Container ending
                          ],
                        ),
                        // Stack ending

                        // Nearby ,Hotel, Cafe  starting
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildOption(0, "assets/images/allnear_ic.png",
                                  AppLocalizations.of(context)!.allNearby),
                              buildOption(1, "assets/images/resturnat_ic.png",
                                  AppLocalizations.of(context)!.restaurants),
                              buildOption(2, "assets/images/coffee_ic.png",
                                  AppLocalizations.of(context)!.cafes),
                              buildOption(3, "assets/images/hotel_ic.png",
                                  AppLocalizations.of(context)!.hotels)
                            ],
                          ),
                        ),
                        // Nearby ,Hotel, Cafe  ending

                        buildUsereCard(context)


      ],
                    ),
                  ),
                ),
                // Places cards list starting
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        // color: index.isOdd ? Colors.white : Colors.black12,
                        child: Center(
                          child: _placeCard(context),
                        ),
                      );
                    },
                    childCount: 10,
                  ),
                ),
                // Places cards list ending
              ],
            ),
          ),

// Bottom Navigation Bar

          // Positioned Column
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black26,
                    //     blurRadius: 10,
                    //     offset: Offset(0, -2),
                    //   ),
                    // ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: BottomNavigationBar(
                      currentIndex: _selectedIndexBottomNavi,
                      onTap: _onItemTapped,
                      type: BottomNavigationBarType.fixed,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      // Highlighted color for selected icon and text
                      selectedItemColor: Theme.of(context).colorScheme.primary,
                      // Color for unselected icons and text
                      unselectedItemColor: Colors.black87,
                      showSelectedLabels: true,
                      showUnselectedLabels: true,
                      selectedLabelStyle: const TextStyle(
                        fontSize: 12, // Text size for selected menu item
                        fontWeight: FontWeight.bold, // Optional: make it bold
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 12, // Text size for unselected menu items
                      ),
                      items: const [
                        BottomNavigationBarItem(
                          icon:  ImageIcon(
                              AssetImage(
                                  "assets/images/ic_shop.png"),
                              size: 24),
                          label: 'Places',
                        ),
                        BottomNavigationBarItem(
                          icon: ImageIcon(
                              AssetImage(
                                  "assets/images/ic_map.png"),
                              size: 24),
                          label: 'Map',
                        ),
                        BottomNavigationBarItem(
                          icon:  ImageIcon(
                              AssetImage(
                                  "assets/images/ic_request.png"),
                              size: 24),
                          label: 'Requests',
                        ),
                        BottomNavigationBarItem(
                          icon:  ImageIcon(
                              AssetImage(
                                  "assets/images/ic_chat.png"),
                              size: 24),
                          label: 'Chat',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomMenu(context)
    );
  }

  Widget buildUsereCard(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),

            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Le Restaurant",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "4.9",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "View your matches",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Transform.translate(
                            offset: Offset(-10 * index.toDouble(), 0), // Adjust overlap by modifying the x-offset
                            child: CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(
                                'https://www.kasandbox.org/programming-images/avatars/spunky-sam-green.png', // Replace with user image URL
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 16),

                Row(
                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Frequent Visitors",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 16),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Transform.translate(
                            offset: Offset(-10 * index.toDouble(), 0), // Adjust overlap by modifying the x-offset
                            child: CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(
                                'https://www.kasandbox.org/programming-images/avatars/marcimus-red.png', // Replace with user image URL
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),

              SizedBox(height: 16),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Check In for 10 credits",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.red[400], // Set the background color of the drawer
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red, // Background color for header (matches the list)
              ),
                child: Container(
                  height: 800,
                  child: Image.asset(
                      'assets/images/ic_drawe_star.png', // Path to your image
                      width: 30,
                      height: 22,
                      color: null, // Prevents color overlay
                      fit: BoxFit.contain,
                    ),
                ),
            ),
            SizedBox(height: 40), // For spacing
            _buildDrawerItem(
              img_path: 'assets/images/user_ic.png',
              title: 'Places', onTap: () {},
            ),
            _buildDrawerItem(
              img_path: 'assets/images/user_ic.png',
              title: 'Map', onTap: () {},
            ),
            _buildDrawerItem(
              img_path: 'assets/images/user_ic.png',
              title: 'Requests', onTap: () {},
            ),
            _buildDrawerItem(
              img_path: 'assets/images/user_ic.png',
              title: 'Chat', onTap: () {},
            ),
            _buildDrawerItem(
              img_path: 'assets/images/user_ic.png',
              title: 'Account',
                onTap: () {},
            ),
            Spacer(), // Push the logout button to the bottom
            Divider(color: Colors.white, thickness: 0.3),
            _buildDrawerItem(
              img_path: 'assets/images/user_ic.png',
              title: 'Logout',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required String img_path,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Image.asset(
        img_path, // Path to your image
        width: 24, // Adjust size as needed
        height: 24,
      ),
      title: Text(
        title,
        style:  Theme.of(context)
          .textTheme
          .displayMedium!
          .copyWith(color: Theme.of(context).colorScheme.secondary),

      ),
      onTap: onTap,
    );
  }

  Widget buildDrawerItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.pink : Colors.black,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.pink : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomMenu(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndexBottomNavi],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndexBottomNavi,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor:
            Colors.pink, // Highlighted color for selected icon and text
        unselectedItemColor: Colors.grey, // Color for unselected icons and text
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.place_outlined),
            label: 'Places',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page_outlined),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: 'Chat',
          ),
        ],
      ),
    );
  }

  Widget buildOption(int index, String assetPath, String label) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index; // Update the selected button
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFEEEB) : Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Image.asset(
              assetPath,
              width: 22,
              height: 22,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: isSelected ? 11 : 10, // Change text size if selected
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeCard(BuildContext context) {
    return IntrinsicHeight(
      // backgroundColor: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/plcbg_1.png', // Replace with your asset image path
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // Distance Chip
                Positioned(
                  top: 17,
                  left: 14,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 10,
                          color: Color(0xFF9366F5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "2 km away",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Color(0xFF9366F5)),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Information
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        "Le Restaurant",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 4),

                      // Open and Closing Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Open •",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(color: Colors.white),
                              ),
                              Text(
                                "Closes at 3PM",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "4.9",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.white),
                              ),
                              SizedBox(width: 4),
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFFCD29),
                                size: 12,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Checked-in Users and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "15 users checked in",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
