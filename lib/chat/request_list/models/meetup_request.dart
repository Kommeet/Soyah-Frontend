enum RequestStatus { pending, accepted, declined }

class MeetupRequest {
  final String id;
  final String senderName;
  final String senderImage;
  final String location;
  final String locationAddress;
  final double locationRating;
  final int checkedInUsers;
  final DateTime dateSent;
  final DateTime? meetupDateTime;
  RequestStatus status;
  final double distance;

  MeetupRequest({
    required this.id,
    required this.senderName,
    required this.senderImage,
    required this.location,
    required this.locationAddress,
    required this.locationRating,
    required this.checkedInUsers,
    required this.dateSent,
    this.meetupDateTime,
    this.status = RequestStatus.pending,
    required this.distance,
  });
}