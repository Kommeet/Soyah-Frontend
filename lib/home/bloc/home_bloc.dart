// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'home_event.dart';
// import 'home_state.dart';
// import '../models/place.dart';

// class HomeBloc extends Bloc<HomeEvent, HomeState> {
//   HomeBloc() : super(const HomeState()) {
//     on<LoadHomeData>(_onLoadHomeData);
//     on<ChangeTab>(_onChangeTab);
//     on<ChangeOption>(_onChangeOption);
//   }

//   void _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
//     emit(state.copyWith(isLoading: true));
//     // Simulate API call
//     await Future.delayed(const Duration(seconds: 1));
//     final places = List.generate(
//       10,
//       (index) => Place(
//         name: "Le Restaurant $index",
//         distance: "2 km",
//         rating: 4.9,
//         usersCheckedIn: 15,
//       ),
//     );
//     emit(state.copyWith(places: places, isLoading: false));
//   }

//   void _onChangeTab(ChangeTab event, Emitter<HomeState> emit) {
//     emit(state.copyWith(selectedTabIndex: event.index));
//   }

//   void _onChangeOption(ChangeOption event, Emitter<HomeState> emit) {
//     emit(state.copyWith(selectedOptionIndex: event.index));
//   }
// }









// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'home_event.dart';
// import 'home_state.dart';
// import '../models/place.dart';

// class HomeBloc extends Bloc<HomeEvent, HomeState> {
//   HomeBloc() : super(const HomeState()) {
//     on<LoadHomeData>(_onLoadHomeData);
//     on<ChangeTab>(_onChangeTab);
//     on<ChangeOption>(_onChangeOption);
//   }

//   Future<void> _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
//     emit(state.copyWith(isLoading: true));
//     // Simulate API call
//     await Future.delayed(const Duration(seconds: 1));
//     final places = List.generate(
//       10,
//       (index) => Place(
//         name: "Le Restaurant $index",
//         distance: "2 km",
//         rating: 4.9,
//         usersCheckedIn: 15, lat: 10.444,
//       ),
//     );
//     emit(state.copyWith(places: places, isLoading: false));
//   }

//   void _onChangeTab(ChangeTab event, Emitter<HomeState> emit) {
//     emit(state.copyWith(selectedTabIndex: event.index));
//   }

//   void _onChangeOption(ChangeOption event, Emitter<HomeState> emit) {
//     emit(state.copyWith(selectedOptionIndex: event.index));
//   }
// }




import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sohyah/home/bloc/home_event.dart';
import 'package:sohyah/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<ChangeTab>(_onChangeTab);
    on<ChangeOption>(_onChangeOption);
  }

  Future<void> _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    // This is now handled by LocationBloc
    emit(state.copyWith(isLoading: false));
  }

  void _onChangeTab(ChangeTab event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }

  void _onChangeOption(ChangeOption event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedOptionIndex: event.index));
  }
}