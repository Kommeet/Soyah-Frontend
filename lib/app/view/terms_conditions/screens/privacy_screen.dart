import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sohyah/app/view/common/app_bar.dart';
import '../bloc/privacy_bloc.dart';
import '../bloc/privacy_event.dart';
import '../bloc/privacy_state.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(
        ctx: context,
        leadingCallBack: null,
      ),
      body: Container(
        color: Colors.grey[200], 
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocProvider(
                  create: (context) => PrivacyBloc()..add(LoadPrivacyPolicy()),
                  child: BlocBuilder<PrivacyBloc, PrivacyState>(
                    builder: (context, state) {
                      if (state is PrivacyInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is PrivacyLoaded) {
                        return SingleChildScrollView(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5, 
                                color: Colors.black87,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms & Conditions\n\n',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Privacy Policies are Required by Law\n\n',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'A privacy policy is a legal document where you disclose what data you collect from users, how you manage the collected data and how you use that data. The important objective of a privacy policy is to inform users how you collect, use and manage the collected.\n\n',
                                ),
                                TextSpan(
                                  text: 'Privacy Policies are Required by Law\n\n',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'At Website Name, accessible at Website.com, one of our main priorities is the privacy of our visitors.\n\n',
                                ),
                                TextSpan(
                                  text:
                                      'This Privacy Policy document contains types of information that is collected and recorded by Website Name and how we use it.\n\n',
                                ),
                                TextSpan(
                                  text:
                                      'If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us through email at\n',
                                ),
                                TextSpan(
                                  text: 'Email@Website.com\n\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'This privacy policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in Website Name. This policy is not applicable to any information collected',
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (state is PrivacyError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}