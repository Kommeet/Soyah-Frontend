import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sohyah/app/routes/routes.dart';
import 'package:sohyah/app/view/common/app_bar.dart';
import 'package:sohyah/app/view/common/continue_button.dart';
import 'package:sohyah/auth/mobile_auth/mobile_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sohyah/auth/mobile_auth/view/widget/widget.dart';

class MobileAuth extends StatelessWidget {
  const MobileAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              MobileAuthCubit(context.read<AuthenticationRepository>()),
          child: const SignUpScreen(),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(
        ctx: context,
        leadingCallBack: null,
      ),
      body: BlocConsumer<MobileAuthCubit, MobileAuthState>(
        listener: (context, state) {
          if (CurrentState.failure == state.currentState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Something went wrong')),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderText(context),
                        const SizedBox(height: 40),
                        _buildCountryPicker(context),
                        const SizedBox(height: 18),
                        _buildDescriptionText(context),
                        const SizedBox(height: 16),
                        const _TermsCheckBox(),
                        const SizedBox(height: 16), // Extra padding for spacing
                      ],
                    ),
                  ),
                ),
              ),
              // Fixed button at the bottom
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: _buildSubmitButton(context),
              ),
            ],
          );
        },
      ),
    );
  }

  // Rest of the methods remain unchanged
  Widget _buildHeaderText(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.mobileAuthHeader,
      style: Theme.of(context)
          .textTheme
          .headlineLarge!
          .copyWith(color: Theme.of(context).colorScheme.secondary),
    );
  }

  Widget _buildCountryPicker(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(60),
            left: Radius.circular(60),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            BlocBuilder<MobileAuthCubit, MobileAuthState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: _buildCountryDropdown(context, state),
                );
              },
            ),
            _buildVerticalDivider(context),
            _buildPhoneNumberField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryDropdown(BuildContext context, MobileAuthState state) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      child: DropdownButton<String>(
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.grey[800],
          size: 24,
        ),
        underline: const SizedBox(),
        value: state.countryCode,
        items: countryCodeArray.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(countryFlagMap[value]!),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.grey[900]),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          context.read<MobileAuthCubit>().changeCountryPicker(
                value ?? defaultCountry,
              );
        },
      ),
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: VerticalDivider(
        color: Colors.grey[800]?.withOpacity(0.2),
        thickness: 0.5,
      ),
    );
  }

  Widget _buildPhoneNumberField(BuildContext context) {
    return Expanded(
      flex: 3,
      child: TextField(
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .copyWith(color: Colors.grey[900]),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context)!.phoneNumber,
          hintStyle: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.grey[700]),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          PhoneNumberTextInputFormatter(),
        ],
        onChanged: (text) {
          context.read<MobileAuthCubit>().phoneNumberChanged(
                text.replaceAll(' ', ''),
              );
        },
      ),
    );
  }

  Widget buildPhoneInput(BuildContext context, MobileAuthState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildCountryDropdown(context, state),
          _buildVerticalDivider(context),
          _buildPhoneNumberField(context),
        ],
      ),
    );
  }

  Widget _buildDescriptionText(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Text(
        AppLocalizations.of(context)!.mobileAuthDescription,
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: const Color(0xFF070201).withOpacity(0.6)),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocConsumer<MobileAuthCubit, MobileAuthState>(
      listener: (context, state) {
        if (state.currentState == CurrentState.codeSent) {
          GoRouter.of(context).push('/otp_verify', extra: {
            'verificationId': state.verificationId ?? '',
            'resendToken': state.resendToken ?? 0,
            'mobileNumber':
                '${state.countryCode}${state.phoneNumber!.replaceAll(' ', '')}'
          });
        }
      },
      builder: (context, state) {
        return ContinueButtonWidget(
          width: 130,
          onTap: () => _handleSubmit(context, state),
        );
      },
    );
  }

  void _showError(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleSubmit(BuildContext context, MobileAuthState state) {
    if (state.isValidMobile && state.isTnCChecked) {
      context.read<MobileAuthCubit>().submitMobileNumber();
    } else {
      final errorText = !state.isTnCChecked
          ? AppLocalizations.of(context)!.tnCCheckedError
          : AppLocalizations.of(context)!.mobileAuthError;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 150, left: 20, right: 20),
        content: Text(errorText),
      ));
    }
  }
}

class _TermsCheckBox extends StatelessWidget {
  const _TermsCheckBox();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MobileAuthCubit, MobileAuthState>(
      builder: (context, state) {
        return Row(
          children: [
            const CheckBoxWidget(),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.mobileAuthTnCText,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: const Color(0xFF070201).withOpacity(0.8)),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () {
                GoRouter.of(context).push(Routes.termsConditions);
              },
              child: Text(
                AppLocalizations.of(context)!.mobileAuthTnCBtn,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}