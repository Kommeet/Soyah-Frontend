import 'dart:async';
import 'package:flutter/material.dart';
import '../models/meetup_request.dart';

class RequestService extends ChangeNotifier {
  List<MeetupRequest> _sentRequests = [];
  List<MeetupRequest> _receivedRequests = [];
  
  List<MeetupRequest> get sentRequests => _sentRequests;
  List<MeetupRequest> get receivedRequests => _receivedRequests;
  
  // Mock initial data
  void loadInitialData() {
    _sentRequests = [
      MeetupRequest(
        id: '1',
        senderName: 'User',
        senderImage: '',
        location: 'Le Restaurant',
        locationAddress: '123 Main St',
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
        locationAddress: '123 Main St',
        locationRating: 4.9,
        checkedInUsers: 15,
        dateSent: DateTime(2024, 3, 27),
        status: RequestStatus.accepted,
        meetupDateTime: DateTime(2024, 3, 27, 15, 0),
        distance: 2.0,
      ),
      // Add more mock data as needed
    ];
    
    _receivedRequests = [
      MeetupRequest(
        id: '3',
        senderName: 'Someone',
        senderImage: '',
        location: 'Le Restaurant',
        locationAddress: '123 Main St',
        locationRating: 4.9,
        checkedInUsers: 15,
        dateSent: DateTime(2024, 3, 27),
        status: RequestStatus.pending,
        distance: 2.0,
      ),
      // Add more mock data as needed
    ];
    
    notifyListeners();
  }
  
  // Send a new meetup request
  Future<void> sendRequest({
    required String location,
    required String locationAddress,
    required double locationRating,
    required int checkedInUsers,
    required double distance,
  }) async {
    final newRequest = MeetupRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: 'User',
      senderImage: '',
      location: location,
      locationAddress: locationAddress,
      locationRating: locationRating,
      checkedInUsers: checkedInUsers,
      dateSent: DateTime.now(),
      status: RequestStatus.pending,
      distance: distance,
    );
    
    _sentRequests.add(newRequest);
    notifyListeners();
    
    // In a real app, you would send this to a backend service
    return Future.delayed(Duration(seconds: 1));
  }
  
  // Accept a received request
  Future<void> acceptRequest({
    required String requestId,
    required DateTime meetupDateTime,
  }) async {
    final index = _receivedRequests.indexWhere((req) => req.id == requestId);
    if (index != -1) {
      final request = _receivedRequests[index];
      final updatedRequest = MeetupRequest(
        id: request.id,
        senderName: request.senderName,
        senderImage: request.senderImage,
        location: request.location,
        locationAddress: request.locationAddress,
        locationRating: request.locationRating,
        checkedInUsers: request.checkedInUsers,
        dateSent: request.dateSent,
        meetupDateTime: meetupDateTime,
        status: RequestStatus.accepted,
        distance: request.distance,
      );
      
      _receivedRequests[index] = updatedRequest;
      notifyListeners();
      
      // In a real app, you would send this to a backend service
      return Future.delayed(Duration(seconds: 1));
    }
  }
  
  // Decline a received request
  Future<void> declineRequest(String requestId) async {
    final index = _receivedRequests.indexWhere((req) => req.id == requestId);
    if (index != -1) {
      final request = _receivedRequests[index];
      final updatedRequest = MeetupRequest(
        id: request.id,
        senderName: request.senderName,
        senderImage: request.senderImage,
        location: request.location,
        locationAddress: request.locationAddress,
        locationRating: request.locationRating,
        checkedInUsers: request.checkedInUsers,
        dateSent: request.dateSent,
        status: RequestStatus.declined,
        distance: request.distance,
      );
      
      _receivedRequests[index] = updatedRequest;
      notifyListeners();
      
      // In a real app, you would send this to a backend service
      return Future.delayed(Duration(seconds: 1));
    }
  }
}
