import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:sohyah/app/view/error_view.dart';
import 'package:sohyah/app/view/terms_conditions/screens/privacy_screen.dart';
import 'package:sohyah/auth/mobile_auth/mobile_auth.dart';
import 'package:sohyah/auth/onboard/onboard.dart';
import 'package:sohyah/auth/otp_verify/view/otp_verify.dart';
import 'package:sohyah/chat/chat_list/screens/chats_list_screen.dart';
import 'package:sohyah/chat/view/ChatView.dart';
import 'package:sohyah/home/models/place.dart';
import 'package:sohyah/home/ui/main_navigation.dart';
import 'package:sohyah/home/ui/request_screen.dart';

import '../../account_set/view/account_set_view.dart';
import '../../location_ebl/view/location_enable.dart';
import '../../main_navigation/view/MainNavigation.dart';
import '../../notification_ebl/view/notification_enable.dart';
import '../../place_profile/view/place_profile_view.dart';
import '../../preference/view/add_preference.dart';
import '../../profile/view/profile.dart';

/// A class that defines the routing structure for the application.
///
/// This class manages routing using the `go_router` package. It provides named routes
/// and their corresponding builders, as well as an error handling widget.

class Routes {
  /// The root path of the application, typically set to '/'.
  static const root = '/';

  /// The path for the home screen of the application.
  static const appHome = '/home';
  static const appHome2 = '/main_navigation';

  /// The path for the Onboard screen of the application.
  static const onboard = '/onboard';

  /// The path for the Mobile number screen of the application.
  static const enterMobileNumber = '/enter_mobile_number';

  /// The path for the OTP Verify screen of the application.
  static const otpVerify = '/otp_verify';

  /// The path for the OTP Verify screen of the application.
  static const addPreference = '/add_preference';

  /// A builder function that creates a `Home` widget for the home route.
  static const addProfile = '/add_profile';
  static const goToAccountSet = '/account_set';
  static const enableLocation = '/enable_location';
  static const enableNotification = '/enable_notification';
  static const goPlaceProfile = '/place_profile';

  static const termsConditions = '/terms_conditions';
  static const chatView = '/chat_view';
  static const requesttView = '/request_view';
  static const chatList = '/chat_list';
  static const mainNav = '/main_nav';


  static Widget _mainNavRouteBuilder(BuildContext context, GoRouterState state) {
  final extra = state.extra as Map<String, dynamic>?;
  final phoneNumber = extra?['phoneNumber'] as String?;
  return MainNavigationScreen(phoneNumber: phoneNumber);
}

  static Widget _chatViewBuilder(
    BuildContext context, GoRouterState state) =>
      const ChatView();

  static Widget _placeProfilePageRouteBuilder(
      BuildContext context, GoRouterState state) {
    Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
    return PlaceProfileView(
      place: extra['place'] as Place,
    );
  }

  static Widget _mainNavigationPageRouteBuilder(
          BuildContext context, GoRouterState state) =>
      const MainNavigation();

  static Widget _requestViewPageRouteBuilder(
          BuildContext context, GoRouterState state) =>
      const RequestsScreen();

  static Widget _chatListPageRouteBuilder(
          BuildContext context, GoRouterState state) =>
      const ChatsListScreen();

  /// A builder function that creates a `Onboard` widget for the home route.
  ///
  /// This function takes a `BuildContext` and a `GoRouterState` as arguments,
  /// but it always returns a const `Onboard` widget in this case.
  static Widget _onboardPageRouteBuilder(
          BuildContext context, GoRouterState state) =>
      const Onboard();

  static Widget _accountSetPageRouteBuilder(
          BuildContext context, GoRouterState state) =>
      const AccountSetView();
  static Widget _locationEnableRouteBuilder(
          BuildContext context, GoRouterState state) =>
      const LocationEnableView();
  static Widget _notificationEnableRouteBuilder(
          BuildContext context, GoRouterState state) =>
      const NotificationEnableView();

  /// A builder function that creates a `Onboard` widget for the home route.
  ///
  /// This function takes a `BuildContext` and a `GoRouterState` as arguments,
  /// but it always returns a const `Onboard` widget in this case.
  static Widget _enterMobileNumberRouteBuilder(
          BuildContext context, GoRouterState state) =>
      const MobileAuth();

  /// A builder function that creates a `Onboard` widget for the home route.
  ///
  /// This function takes a `BuildContext` and a `GoRouterState` as arguments,
  /// but it always returns a const `OTPVerify` widget in this case.
  static Widget _otpVerifyRouteBuilder(
      BuildContext context, GoRouterState state) {
    Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
    return OtpVerify(
      verificationId: extra['verificationId'],
      resendToken: extra['resendToken'],
      mobileNumber: extra['mobileNumber'],
    );
  }

  static Widget _addPreferenceRouteBuilder(
          BuildContext context, GoRouterState state) =>
      const AddPreference();

  static Widget _addProfileRouteBuilder(
          BuildContext context, GoRouterState state) =>
      const Profile();

  static Widget _termsConditionsRouteBuilder(
          BuildContext context, GoRouterState state) =>
      const PrivacyScreen();

  /// A widget builder function that returns an `ErrorView` widget when a routing error occurs.
  ///
  /// This function can be customized to display a more informative error message or handle errors differently.

  static Widget errorWidget(BuildContext context, GoRouterState state) =>
      const ErrorView();

  /// An instance of the `GoRouter` class that defines the application's routing configuration.
  ///
  /// This router is configured with the available routes, error handling, and optional redirects.

  static final GoRouter _router = GoRouter(
      routes: <GoRoute>[
        GoRoute(path: root, builder: _onboardPageRouteBuilder),
        GoRoute(
            path: enterMobileNumber, builder: _enterMobileNumberRouteBuilder),
        GoRoute(path: otpVerify, builder: _otpVerifyRouteBuilder),
        GoRoute(path: addPreference, builder: _addPreferenceRouteBuilder),
        GoRoute(path: addProfile, builder: _addProfileRouteBuilder),
        GoRoute(path: goToAccountSet, builder: _accountSetPageRouteBuilder),
        GoRoute(path: enableLocation, builder: _locationEnableRouteBuilder),
        GoRoute(
            path: enableNotification, builder: _notificationEnableRouteBuilder),
        // GoRoute(path: appHome, builder: _homePageRouteBuilder),
        GoRoute(path: appHome2, builder: _mainNavigationPageRouteBuilder),
        GoRoute(path: goPlaceProfile, builder: _placeProfilePageRouteBuilder),
        GoRoute(path: termsConditions, builder: _termsConditionsRouteBuilder),
        GoRoute(path: chatView, builder: _chatViewBuilder),
        GoRoute(path: requesttView, builder: _requestViewPageRouteBuilder),
        GoRoute(path: chatList, builder: _chatListPageRouteBuilder),
        GoRoute(path: mainNav, builder: _mainNavRouteBuilder),

      ],
      errorBuilder: errorWidget,
      redirect: (BuildContext context, GoRouterState state) {
        return;
      });

  /// A getter that provides access to the configured `GoRouter` instance.
  static GoRouter get router => _router;
}


