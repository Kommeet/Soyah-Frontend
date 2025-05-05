// ignore_for_file: avoid_print
import 'package:bloc/bloc.dart';

/// A custom BlocObserver that prints Bloc events, errors, changes, and transitions to the console.
///
/// This observer is primarily used for debugging purposes during development. It logs important
/// information about Bloc state changes and errors to aid in understanding and troubleshooting
/// application behavior.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  /// Prints the given [event] to the console when a new event is added to a Bloc.

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }
  /// Prints the given [error] and its associated [stackTrace] to the console when an error occurs in a Bloc.

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }

  /// Prints the given [change] to the console when a change in a Bloc's state occurs.

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    print(change);
  }

  /// Prints the given [transition] to the console when a Bloc transition occurs.

  @override
  void onTransition(
      Bloc<dynamic, dynamic> bloc,
      Transition<dynamic, dynamic> transition,
      ) {
    super.onTransition(bloc, transition);
     print(transition);
  }
}
