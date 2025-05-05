import 'package:flutter/material.dart';
import '../models/meetup_request.dart';
import '../widgets/location_card.dart';
import 'date_time_selection_screen.dart';
import 'request_sent_screen.dart';

class RequestDetailScreen extends StatelessWidget {
  final MeetupRequest request;
  final bool isSent;

  RequestDetailScreen({
    required this.request,
    required this.isSent,
  });

  @override
  Widget build(BuildContext context) {
    // For requests I've sent
    if (isSent) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Color(0xFFFF6B6B)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
  Text(
    'Meetup for Coffee',
    style: Theme.of(context).textTheme.headlineLarge,
  ),
  SizedBox(height: 8),
  Text(
    'Date Sent: ${request.dateSent.day}th ${_getMonthName(request.dateSent.month)}, ${request.dateSent.year}',
    style: Theme.of(context).textTheme.bodyMedium,
  ),
  SizedBox(height: 30),

  // Request status
  (request.status == RequestStatus.pending)
    ? _buildStatusMessage(context, 'Request hasn\'t been accepted yet', Colors.orange)
    : (request.status == RequestStatus.accepted)
      ? _buildAcceptedDetails(context)
      : Container(),

  SizedBox(height: 30),

  // Location section
  Text(
    'Selected location',
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.bold,
    ),
  ),
  SizedBox(height: 10),
  LocationCard(
    locationName: request.location,
    distance: request.distance,
    rating: request.locationRating,
    checkedInUsers: request.checkedInUsers,
  ),

  // Chat unlock section
  Spacer(),
  Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Color(0xFFFFF1F1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Want to get to know your date more?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Unlock chat for 5 credits',
                style: TextStyle(
                  color: Color(0xFFFF6B6B),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
],

          ),
        ),
      );
    }
    
    // For requests I've received
    else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Color(0xFFFF6B6B)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meetup for Coffee',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 8),
              Text(
                '${request.dateSent.day}th ${_getMonthName(request.dateSent.month)}, ${request.dateSent.year}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20),
              
              // Request sender section
              Text(
                'Request sent by',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF1F1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Want to get to know your date more?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Unlock chat for 5 credits',
                            style: TextStyle(
                              color: Color(0xFFFF6B6B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              
              // Location section
              Text(
                'Selected location',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              LocationCard(
                locationName: request.location,
                distance: request.distance,
                rating: request.locationRating,
                checkedInUsers: request.checkedInUsers,
              ),
              
              SizedBox(height: 10),
              Text(
                'Once you accept the request, you can select a date and time for your meetup',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                ),
              ),
              
              // Accept/Decline buttons
              Spacer(),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle decline
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Decline',
                      style: TextStyle(
                        color: Color(0xFFFF6B6B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DateTimeSelectionScreen(request: request),
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_forward),
                    label: Text('ACCEPT'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildStatusMessage(BuildContext context, String message, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: color, size: 18),
          SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptedDetails(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meetup details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.access_time, color: Color(0xFFFF6B6B)),
              ),
              SizedBox(width: 10),
              Text(
                'Time: 3:00 PM',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.calendar_today, color: Color(0xFFFF6B6B)),
              ),
              SizedBox(width: 10),
              Text(
                'Date: 27th March, 2024',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on, color: Color(0xFFFF6B6B)),
              ),
              SizedBox(width: 10),
              Text(
                'Location: ${request.location}',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    List<String> months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}