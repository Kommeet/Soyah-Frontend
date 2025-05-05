part of 'app_bloc.dart';

sealed class AppState extends Equatable {
  const AppState();
}

final class AppInitial extends AppState {
  @override
  List<Object> get props => [];
}
