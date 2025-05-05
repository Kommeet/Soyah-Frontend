import 'package:flutter_bloc/flutter_bloc.dart';
import 'privacy_event.dart';
import 'privacy_state.dart';

class PrivacyBloc extends Bloc<PrivacyEvent, PrivacyState> {
  PrivacyBloc() : super(PrivacyInitial()) {
    on<LoadPrivacyPolicy>((event, emit) {
      try {
        // Static privacy policy text (you can fetch this from an API if needed)
        const privacyText = '''
PRIVACY POLICIES ARE REQUIRED BY LAW

A privacy policy is a legal document where you disclose what data you collect from users, how you manage the collected data and how you use that data. The important objective of a privacy policy is to inform users how you collect, use and manage the collected.

PRIVACY POLICIES ARE REQUIRED BY LAW

At Website Name, accessible at Website.com, one of our main priorities is the privacy of our visitors.

THIS Privacy Policy document contains types of information that is collected and recorded by Website Name and how we use it.

IF YOU HAVE ADDITIONAL QUESTIONS OR REQUIRE MORE INFORMATION ABOUT OUR Privacy Policy, do not hesitate to contact us through email at

Email@Website.com

THIS privacy policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in Website Name. This policy is not applicable to any information collected
''';
        emit(PrivacyLoaded(privacyText));
      } catch (e) {
        emit(PrivacyError('Failed to load privacy policy'));
      }
    });
  }
}