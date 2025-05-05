import 'package:flutter/material.dart';
import '../models/meetup_request.dart';
import 'request_sent_screen.dart';

class DateTimeSelectionScreen extends StatefulWidget {
  final MeetupRequest request;

  DateTimeSelectionScreen({required this.request});

  @override
  _DateTimeSelectionScreenState createState() => _DateTimeSelectionScreenState();
}

class _DateTimeSelectionScreenState extends State<DateTimeSelectionScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay(hour: 11, minute: 38);
  bool _isAM = true;

  @override
  Widget build(BuildContext context) {
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
              'Select date & time\nfor your booking',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet consectetur.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 30),
            
            // Date picker
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFF1F1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  // Month navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'September 2023',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left),
                            onPressed: () {
                              // Previous month
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.chevron_right),
                            onPressed: () {
                              // Next month
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Weekday headers
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildWeekdayHeader('Mo'),
                        _buildWeekdayHeader('Tu'),
                        _buildWeekdayHeader('We'),
                        _buildWeekdayHeader('Th'),
                        _buildWeekdayHeader('Fr'),
                        _buildWeekdayHeader('Sa'),
                        _buildWeekdayHeader('Su'),
                      ],
                    ),
                  ),
                  
                  // Calendar grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                    ),
                    itemCount: 35, // 5 weeks
                    itemBuilder: (context, index) {
                      // First day of month starts on Friday (index 4)
                      if (index < 4) {
                        return Container();
                      }
                      
                      // Days of the month
                      int day = index - 4 + 1;
                      if (day > 30) {
                        return Container();
                      }
                      
                      bool isSelected = day == 8; // 8th is selected
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = DateTime(2023, 9, day);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFFFF6B6B) : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$day',
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Time picker
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '11:38',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      _buildTimeToggle('AM', true),
                      SizedBox(width: 10),
                      _buildTimeToggle('PM', false),
                    ],
                  ),
                ],
              ),
            ),
            
            Spacer(),
            
            // Confirm button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestSentScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.arrow_forward),
                label: Text('CONFIRM MEETUP'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader(String day) {
    return SizedBox(
      width: 30,
      child: Text(
        day,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildTimeToggle(String label, bool isAM) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAM = isAM;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isAM == isAM ? Color(0xFFFF6B6B) : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _isAM == isAM ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}