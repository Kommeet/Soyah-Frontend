import 'package:flutter/material.dart';
import '../models/meetup_request.dart';
import 'package:intl/intl.dart';

class RequestCard extends StatelessWidget {
  final MeetupRequest request;
  final bool isSent;
  final VoidCallback onTap;

  RequestCard({
    required this.request,
    required this.isSent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget statusIndicator() {
      switch (request.status) {
        case RequestStatus.pending:
          return Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 4),
              Text(
                'Not accepted yet',
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 12,
                ),
              ),
            ],
          );
        case RequestStatus.accepted:
          return Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 4),
              Text(
                'Accepted',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                ),
              ),
            ],
          );
        case RequestStatus.declined:
          return Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 4),
              Text(
                'Declined',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          );
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(16),
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
        child: Row(
          children: [
            if (!isSent)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
              ),
            SizedBox(width: isSent ? 0 : 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isSent)
                    Text(
                      DateFormat('d\'th MMMM, yyyy').format(request.dateSent),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  Text(
                    'Meetup for Coffee',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'From ${request.location}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 4),
                  statusIndicator(),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.purpleAccent,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}