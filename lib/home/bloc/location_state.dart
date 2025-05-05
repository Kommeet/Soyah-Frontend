import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sohyah/home/models/place.dart';

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