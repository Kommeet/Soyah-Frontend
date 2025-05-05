import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sohyah/app/app.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sohyah/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// The main entry point of the application.
///
/// This function ensures WidgetsFlutterBinding is initialized, sets the global Bloc observer
/// to the `AppBlocObserver`, and finally runs the app using the `runApp` function with the
/// `App` widget as the root widget.
const String DEFAULT_USER_PASSWORD = "123456789";

const String APPLICATION_ID = "105143";
const String AUTH_KEY = "ak_P8CRbWXaqJ3QCeS";
const String AUTH_SECRET = "as_kN3a85MMbbgjEPw";
const String ACCOUNT_KEY = "ack_AffsJr7DoUo497xoizbY";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();
  //test comment
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final authenticationRepository = AuthenticationRepository(prefs: prefs);
  await authenticationRepository.determinePermission();
  await authenticationRepository.user.first;
  await dotenv.load(fileName: ".env");
  runApp(App(
    authenticationRepository: authenticationRepository,
  ));
}