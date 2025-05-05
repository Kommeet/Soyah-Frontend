import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../app/view/common/app_bar.dart';
import '../../app/view/common/continue_button.dart';

class AccountSetView extends StatelessWidget {
  const AccountSetView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the profile picture URL from AuthenticationRepository
    final String? profilePictureUrl = context.read<AuthenticationRepository>().getProfilePictureUrl();

    return Scaffold(
      appBar: GlobalAppBar(
        ctx: context,
        leadingCallBack: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  // Display profile picture if available, otherwise show the default image
                  profilePictureUrl != null && profilePictureUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(65), // Circular profile picture
                          child: Image.network(
                            profilePictureUrl,
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback to default image on error
                              return Image.asset(
                                'assets/images/profile_sample.png',
                                width: 130,
                                height: 130,
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        )
                      : Image.asset(
                          'assets/images/profile_sample.png',
                          width: 130,
                          height: 130,
                          fit: BoxFit.contain,
                        ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.accountAllSet,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.accountAllSetDesc,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: const Color(0xFF070201)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Be yourself.',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Embrace your uniqueness and let your true self shine.',
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Maintain your privacy.',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Make sure you do not overshare and give out any personal information.',
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Take Initiative.',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Let us know if you face anything uncomfortable or you want to report any issues you see.',
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: ContinueButtonWidget(
                label: 'I AGREE',
                width: 100,
                onTap: () {
                  GoRouter.of(context).push('/enable_location',);
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}