import 'package:flutter/material.dart';
import 'package:sohyah/chat/presentation/widgets/app_bar.dart';
import '../models/meetup_request.dart';
import '../widgets/request_card.dart';
import 'request_detail_screen.dart';

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSentTab = true;

  // Sample data
  final List<MeetupRequest> sentRequests = [
    MeetupRequest(
      id: '1',
      senderName: 'User',
      senderImage: '',
      location: 'Le Restaurant',
      locationAddress: '',
      locationRating: 4.9,
      checkedInUsers: 15,
      dateSent: DateTime(2024, 3, 27),
      status: RequestStatus.pending,
      distance: 2.0,
    ),
    MeetupRequest(
      id: '2',
      senderName: 'User',
      senderImage: '',
      location: 'Le Restaurant',
      locationAddress: '',
      locationRating: 4.9,
      checkedInUsers: 15,
      dateSent: DateTime(2024, 3, 27),
      status: RequestStatus.accepted,
      distance: 2.0,
    ),
    MeetupRequest(
      id: '3',
      senderName: 'User',
      senderImage: '',
      location: 'Le Restaurant',
      locationAddress: '',
      locationRating: 4.9,
      checkedInUsers: 15,
      dateSent: DateTime(2024, 3, 27),
      status: RequestStatus.pending,
      distance: 2.0,
    ),
    MeetupRequest(
      id: '4',
      senderName: 'User', 
      senderImage: '',
      location: 'Le Restaurant',
      locationAddress: '',
      locationRating: 4.9,
      checkedInUsers: 15,
      dateSent: DateTime(2024, 3, 27),
      status: RequestStatus.accepted,
      distance: 2.0,
    ),
    MeetupRequest(
      id: '5',
      senderName: 'User',
      senderImage: '',
      location: 'Le Restaurant',
      locationAddress: '',
      locationRating: 4.9,
      checkedInUsers: 15,
      dateSent: DateTime(2024, 3, 27),
      status: RequestStatus.declined,
      distance: 2.0,
    ),
    MeetupRequest(
      id: '6',
      senderName: 'User',
      senderImage: '',
      location: 'Le Restaurant',
      locationAddress: '',
      locationRating: 4.9,
      checkedInUsers: 15,
      dateSent: DateTime(2024, 3, 27),
      status: RequestStatus.pending,
      distance: 2.0,
    ),
  ];

  final List<MeetupRequest> receivedRequests = [
    MeetupRequest(
      id: '7',
      senderName: 'Le Restaurant',
      senderImage: '',
      location: 'Le Restaurant',
      locationAddress: '',
      locationRating: 4.9,
      checkedInUsers: 15,
      dateSent: DateTime(2024, 3, 27),
      status: RequestStatus.pending,
      distance: 2.0,
    ),
    MeetupRequest(
      id: '8',
      senderName: 'Le Restaurant',
      senderImage: '',
      location: 'Le Restaurant',
      locationAddress: '', 
      locationRating: 4.9,
      checkedInUsers: 15,
      dateSent: DateTime(2024, 3, 27),
      status: RequestStatus.pending,
      distance: 2.0,
    ),
    MeetupRequest(
      id: '9',
      senderName: 'Le Restaurant',
      senderImage: '',
      location: 'Le Restaurant',
      locationAddress: '',
      locationRating: 4.9,
      checkedInUsers: 15,
      dateSent: DateTime(2024, 3, 27),
      status: RequestStatus.pending,
      distance: 2.0,
    ),
    MeetupRequest(
      id: '10',
      senderName: 'Le Restaurant',
      senderImage: '',
      location: 'Le Restaurant',
      locationAddress: '',
      locationRating: 4.9, 
      checkedInUsers: 15,
      dateSent: DateTime(2024, 3, 27),
      status: RequestStatus.pending,
      distance: 2.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _isSentTab = _tabController.index == 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(),

      body: Column(
        children: [
          Container(
  alignment: Alignment.centerLeft,
  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  child: SizedBox(
    width: MediaQuery.of(context).size.width * 2 / 3,
    child: Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xFFFF6B6B),
        ),
        indicatorColor: Colors.transparent, // <-- THIS LINE REMOVES BOTTOM LINE
        indicatorSize: TabBarIndicatorSize.tab,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Requests Sent', textAlign: TextAlign.center),
            ),
          ),
          Tab(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Requests Received', textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    ),
  ),
),




          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isSentTab 
                      ? '${sentRequests.length} Requests Sent in Total'
                      : '${receivedRequests.length} Requests Received in Total',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.filter_list, color: Color(0xFFFF6B6B)),
                  label: Text(
                    'All Requests',
                    style: TextStyle(color: Color(0xFFFF6B6B)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Sent Requests Tab
                ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: sentRequests.length,
                  itemBuilder: (context, index) {
                    final request = sentRequests[index];
                    return RequestCard(
                      request: request,
                      isSent: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestDetailScreen(
                              request: request,
                              isSent: true,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                
                // Received Requests Tab
                ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: receivedRequests.length,
                  itemBuilder: (context, index) {
                    final request = receivedRequests[index];
                    return RequestCard(
                      request: request,
                      isSent: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestDetailScreen(
                              request: request,
                              isSent: false,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
