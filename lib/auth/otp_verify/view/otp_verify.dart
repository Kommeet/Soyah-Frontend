import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sohyah/auth/otp_verify/cubit/otp_verify_cubit.dart';
import 'package:sohyah/auth/otp_verify/view/widget/widget.dart';
import '../../../app/view/common/app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:authentication_repository/authentication_repository.dart';

class OtpVerify extends StatelessWidget {
  const OtpVerify(
      {super.key,
        required this.verificationId,
        this.resendToken,
        this.mobileNumber});

  final String verificationId;
  final int? resendToken;
  final String? mobileNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => OtpVerifyCubit(
              authenticationRepository:
              context.read<AuthenticationRepository>(),
              verificationId: verificationId,
              resendToken: resendToken),
          child: OtpVerifyScreen(
            verificationId: verificationId,
            resendToken: resendToken,
            mobileNumber: mobileNumber,
          ),
        ),
      ),
    );
  }
}

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen(
      {super.key,
        required this.verificationId,
        this.resendToken,
        this.mobileNumber});

  final String verificationId;
  final int? resendToken;
  final String? mobileNumber;

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  late Timer _timer;
  int _countdown = 90; // Initial countdown value (10 seconds)
  bool _canResend = false; // Whether the resend button is enabled

  @override
  void initState() {
    super.initState();

    startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true; // Enable the resend button or action
          _timer.cancel(); // Stop the timer once countdown finishes
        }
      });
    });
  }

  void resendOTP() {
    // Add logic to resend the OTP
    setState(() {
      _countdown = 10;
      _canResend = false;
    });
    startCountdown(); // Restart the countdown timer
  }
  void goBack() {
    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(
        ctx: context,
        leadingCallBack:  () {},
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.verifyNumber,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)!.verifyNumberMsg,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: const Color(0xFF070201)),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        widget.mobileNumber ?? '-',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Text(AppLocalizations.of(context)!.editNumber,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF9366F5))),
                ),
                const SizedBox(height: 16),
                PinInputField(
                  onCompleteOtp: (value) {
                    context.read<OtpVerifyCubit>().verifyOtp(otpCode: value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(
                    children: [
                      Text(AppLocalizations.of(context)!.resentOtp,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.8))),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          if (_canResend) {
                            context
                                .read<OtpVerifyCubit>()
                                .resendCode(widget.mobileNumber!);
                          }
                        },
                        child: Text(
                            _canResend
                                ? "Resend OTP" // When countdown ends, show "Resend OTP"
                                : "Resend in $_countdown s",
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF9366F5))),
                      )
                    ],
                  ),
                ),
              ],
            ),
            BlocConsumer<OtpVerifyCubit, OtpVerifyState>(
              listener: (context, state) {
                if (state.otpVerifyStatus == OtpVerifyStatus.otpResent) {
                  final snackBar = SnackBar(
                    content: const Text('OTP Code resent.'),
                    action: SnackBarAction(
                      label: 'Ok',
                      textColor: Colors.green,
                      onPressed: () {},
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (state.otpVerifyStatus == OtpVerifyStatus.success) {
                  GoRouter.of(context).push('/add_profile');
                }
              },
              builder: (context, state) {
                return state.otpVerifyStatus == OtpVerifyStatus.invalid
                    ? Row(
                  children: [
                    Icon(
                      Icons.error_rounded,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Make sure you are using the latest',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: Colors.black)),
                        Row(
                          children: [
                            Text(
                              'OTP number obtained through ',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(color: Colors.black),
                            ),
                            Text(
                                '${widget.mobileNumber!.substring(0, 6)}...',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                  color: const Color(0xFF9366F5),
                                  fontWeight: FontWeight.w700,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
                    : const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

