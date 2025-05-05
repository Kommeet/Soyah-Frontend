import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../app/view/common/app_bar.dart';
import '../../app/view/common/continue_button.dart';

class LocationEnableView extends StatelessWidget {
  const LocationEnableView({super.key});

  // Function to request location permission
  Future<void> _requestLocationPermission(BuildContext context) async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();

      if (status.isGranted) {
        GoRouter.of(context).push('/enable_notification');
      } else if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission is required to proceed.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      GoRouter.of(context).push('/enable_notification');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(
        ctx: context,
        leadingCallBack: () {},
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/locationmap.png',
                width: 190,
                height: 190, 
                fit: BoxFit.contain,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.enableLocationTitle,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              const SizedBox(height: 2),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.enableLocationDesc,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: const Color(0xFF070201)),
              ),
            ],
          ),
          const Expanded(child: Spacer()),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: ContinueButtonWidget(
              label: 'ALLOW LOCATION',
              width: 180,
              onTap: () async {
                await _requestLocationPermission(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}