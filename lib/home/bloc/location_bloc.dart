import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sohyah/home/models/place.dart';

// Location Events
abstract class LocationEvent {}

class GetLocationAndPlaces extends LocationEvent {}

class ChangeFilter extends LocationEvent {
  final int index;
  ChangeFilter(this.index);
}

// Location State
class LocationState extends Equatable {
  final bool isLoading;
  final String error;
  final List<Place> places;
  final List<Place> filteredPlaces;
  final Position? currentPosition;
  final Place? nearestPlace;
  final int selectedFilter;
  
  const LocationState({
    this.isLoading = false,
    this.error = '',
    this.places = const [],
    this.filteredPlaces = const [],
    this.currentPosition,
    this.nearestPlace,
    this.selectedFilter = 0,
  });
  
  LocationState copyWith({
    bool? isLoading,
    String? error,
    List<Place>? places,
    List<Place>? filteredPlaces,
    Position? currentPosition,
    Place? nearestPlace,
    int? selectedFilter,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      places: places ?? this.places,
      filteredPlaces: filteredPlaces ?? this.filteredPlaces,
      currentPosition: currentPosition ?? this.currentPosition,
      nearestPlace: nearestPlace ?? this.nearestPlace,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
  
  @override
  List<Object?> get props => [
    isLoading, 
    error, 
    places, 
    filteredPlaces,
    currentPosition, 
    nearestPlace, 
    selectedFilter
  ];
}

// Location BLoC
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final String apiKey = 'AIzaSyAmQOxV80zIRfCZxDNcmVt83tuW1RlVo40';
  late final GoogleMapsPlaces places;
  
  LocationBloc() : super(const LocationState()) {
    places = GoogleMapsPlaces(apiKey: apiKey);
    
    on<GetLocationAndPlaces>(_onGetLocationAndPlaces);
    on<ChangeFilter>(_onChangeFilter);
  }
  
  Future<void> _onGetLocationAndPlaces(GetLocationAndPlaces event, Emitter<LocationState> emit) async {
    emit(state.copyWith(isLoading: true, error: ''));
    
    try {
      // Check location services
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Location services are disabled',
        ));
        return;
      }
      
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(state.copyWith(
            isLoading: false,
            error: 'Location permissions are denied',
          ));
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Location permissions are permanently denied',
        ));
        return;
      }
      
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      // Fetch nearby places
      final places = await _fetchNearbyPlaces(position);
      
      final nearestPlace = places.isNotEmpty ? places.first : null;
      
      emit(state.copyWith(
        isLoading: false,
        places: places,
        filteredPlaces: _getFilteredPlaces(places, state.selectedFilter),
        currentPosition: position,
        nearestPlace: nearestPlace,
      ));
      
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to get location: $e',
      ));
    }
  }
  
  void _onChangeFilter(ChangeFilter event, Emitter<LocationState> emit) {
    final filteredPlaces = _getFilteredPlaces(state.places, event.index);
    emit(state.copyWith(
      selectedFilter: event.index,
      filteredPlaces: filteredPlaces,
    ));
  }
  
  List<Place> _getFilteredPlaces(List<Place> places, int filterIndex) {
    if (filterIndex == 0) return places; // All
    
    String filterType;
    switch (filterIndex) {
      case 1: filterType = 'restaurant'; break;
      case 2: filterType = 'cafe'; break;
      case 3: filterType = 'lodging'; break;
      default: return places;
    }
    
    return places.where((place) => 
      place.type.toLowerCase() == filterType
    ).toList();
  }
  
  Future<List<Place>> _fetchNearbyPlaces(Position position) async {
    List<Place> allPlaces = [];
    List<String> types = ['restaurant', 'cafe', 'lodging'];
    
    for (String type in types) {
      try {
        final response = await places.searchNearbyWithRadius(
          Location(lat: position.latitude, lng: position.longitude),
          2000, // 2km radius
          type: type,
        );
        
        if (response.status == "OK") {
          for (var result in response.results) {
            double distance = _calculateDistance(
              position.latitude,
              position.longitude,
              result.geometry?.location.lat ?? 0,
              result.geometry?.location.lng ?? 0,
            );

            String? photoReference;
            if (result.photos != null && result.photos!.isNotEmpty) {
              photoReference = result.photos!.first.photoReference;
              print('Photo reference for ${result.name}: $photoReference'); // Debug log
            } else {
              print('No photos available for ${result.name}'); // Debug log
            }

            // Fetch place details for opening hours
            bool? isOpen;
            String? closingTime;
            try {
              final detailsResponse = await places.getDetailsByReference(
                result.placeId ?? '',
                fields: ['opening_hours'],
              );
              if (detailsResponse.status == "OK" && detailsResponse.result.openingHours != null) {
                isOpen = detailsResponse.result.openingHours!.openNow;
                final periods = detailsResponse.result.openingHours!.periods;
                if (periods != null && periods.isNotEmpty) {
                  // Get today's period (assuming periods[0] is the current day for simplicity)
                  final todayPeriod = periods[0];
                  if (todayPeriod.close != null) {
                    final closeTime = todayPeriod.close!.time;
                    // Format time (e.g., "1430" to "2:30 PM")
                    closingTime = _formatTime(closeTime);
                  }
                }
                print('Opening hours for ${result.name}: isOpen=$isOpen, closingTime=$closingTime'); // Debug log
              } else {
                print('No opening hours available for ${result.name}'); // Debug log
              }
            } catch (e) {
              print('Error fetching details for ${result.name}: $e'); // Debug log
            }
            
            allPlaces.add(Place(
              name: result.name,
              type: type,
              address: result.vicinity ?? 'No address available',
              distance: distance,
              lat: result.geometry?.location.lat ?? 0,
              lng: result.geometry?.location.lng ?? 0,
              placeId: result.placeId ?? '',
              photoReference: photoReference,
              isOpen: isOpen,
              closingTime: closingTime,
            ));
          }
        } else {
          print('Failed to fetch $type places: ${response.errorMessage}');
        }
      } catch (e) {
        print('Error fetching $type places: $e'); 
      }
    }
    
    // Sort places by distance
    allPlaces.sort((a, b) => a.distance.compareTo(b.distance));
    return allPlaces;
  }
  
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; 
    double phi1 = lat1 * pi / 180;
    double phi2 = lat2 * pi / 180;
    double deltaPhi = (lat2 - lat1) * pi / 180;
    double deltaLambda = (lon2 - lon1) * pi / 180;
    
    double a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return R * c; // Distance in km
  }

  String _formatTime(String time) {
    // Convert time from "HHmm" (e.g., "1430") to "HH:MM AM/PM" (e.g., "2:30 PM")
    try {
      int hour = int.parse(time.substring(0, 2));
      int minute = int.parse(time.substring(2, 4));
      String period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;
      return '$hour:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time; // Return raw time if parsing fails
    }
  }
}