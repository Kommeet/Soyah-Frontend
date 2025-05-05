

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:sohyah/app/app.dart';
import 'package:sohyah/theme/theme.dart';

import '../bloc/app_bloc.dart';


/// The main application widget.
///
/// This widget sets up the application with necessary configurations such as routing,
/// localization, and themes. It extends `StatelessWidget` because it does not require
/// mutable state.
///
class App extends StatelessWidget {
  const App(
      {required AuthenticationRepository authenticationRepository, super.key})
      : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;



  @override
  Widget build(BuildContext context) {
   return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>.value(value: _authenticationRepository),
      ],
      child: BlocProvider(
        create: (context) => AppBloc(),
        child: const AppView(),
      ),
    );
  }
}


class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(  // Configures the router for the application using the predefined routes.
    debugShowCheckedModeBanner: false,
      routerConfig: Routes.router,

      // Localization delegates to support internationalization.
      // These delegates load the necessary localization resources for the app.

      localizationsDelegates: const [
        AppLocalizations.delegate, // Delegate for app-specific localizations.
        GlobalMaterialLocalizations
            .delegate, // Delegate for material widgets localizations.
        GlobalWidgetsLocalizations
            .delegate, // Delegate for general widgets localizations.
        GlobalCupertinoLocalizations
            .delegate, // Delegate for Cupertino widgets localizations.
      ],

      supportedLocales: const [
        Locale('en'), // English
        Locale('de'), // German
      ],
      theme: lightTheme, // Light theme configuration.
      darkTheme: darkTheme,
);
  }
}
