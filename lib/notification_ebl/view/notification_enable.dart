import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart'; 
import '../../app/view/common/app_bar.dart';
import '../../app/view/common/continue_button.dart';

class NotificationEnableView extends StatelessWidget {
  const NotificationEnableView({super.key});

  Future<void> _requestNotificationPermission(BuildContext context) async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      status = await Permission.notification.request();

      if (status.isGranted) {
        GoRouter.of(context).push('/main_nav');
      } else if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification permission is required to proceed.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      GoRouter.of(context).push('/main_nav');
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/notifications-img.png',
                  width: 190,
                  height: 190, 
                  fit: BoxFit.contain,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.enableNotificationTitle,
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
                        text: AppLocalizations.of(context)!.enableNotificationDesc,
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
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: ContinueButtonWidget(
              label: 'START YOUR JOURNEY',
              width: 200,
              onTap: () async {
                await _requestNotificationPermission(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}