// import 'package:equatable/equatable.dart';
// import '../models/place.dart';

// class HomeState extends Equatable {
//   final int selectedTabIndex;
//   final int selectedOptionIndex;
//   final List<Place> places;
//   final bool isLoading;

//   const HomeState({
//     this.selectedTabIndex = 0,
//     this.selectedOptionIndex = 0,
//     this.places = const [],
//     this.isLoading = false,
//   });

//   HomeState copyWith({
//     int? selectedTabIndex,
//     int? selectedOptionIndex,
//     List<Place>? places,
//     bool? isLoading,
//   }) {
//     return HomeState(
//       selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
//       selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
//       places: places ?? this.places,
//       isLoading: isLoading ?? this.isLoading,
//     );
//   }

//   @override
//   List<Object> get props => [selectedTabIndex, selectedOptionIndex, places, isLoading];
// }













import 'package:equatable/equatable.dart';
import '../models/place.dart';

class HomeState extends Equatable {
  final int selectedTabIndex;
  final int selectedOptionIndex;
  final List<Place> places;
  final bool isLoading;

  const HomeState({
    this.selectedTabIndex = 0,
    this.selectedOptionIndex = 0,
    this.places = const [],
    this.isLoading = false,
  });

  HomeState copyWith({
    int? selectedTabIndex,
    int? selectedOptionIndex,
    List<Place>? places,
    bool? isLoading,
  }) {
    return HomeState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      places: places ?? this.places,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [selectedTabIndex, selectedOptionIndex, places, isLoading];
}