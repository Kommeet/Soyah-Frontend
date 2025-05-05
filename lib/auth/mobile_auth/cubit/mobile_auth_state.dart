part of 'mobile_auth_cubit.dart';

final class MobileAuthState extends Equatable {
  const MobileAuthState(
      {this.countryCode = defaultCountry,
      this.isValidMobile = false,
      this.phoneNumber,
      this.isTnCChecked =false,
      this.currentState,
      this.resendToken,
      this.verificationId,
        this.otp,
      this.errorMessage});

  final String countryCode;
  final bool isTnCChecked;
  final bool isValidMobile;
  final String? phoneNumber;
  final String? otp;
  final CurrentState? currentState;
  final String? errorMessage;
  final String? verificationId;
  final int? resendToken;

  @override
  List<Object?> get props => [
        currentState,
        phoneNumber,
        otp,
        isTnCChecked,
        errorMessage,
        verificationId,
        resendToken,
        countryCode,
        isValidMobile
      ];

  MobileAuthState copyWith(
      {String? countryCode,
      bool? isValidMobile,
      bool? isTnCChecked,
      String? phoneNumber,
        String? otp,
      CurrentState? currentState,
      String? errorMessage,
      String? verificationId,
      int? resendToken}) {
    return MobileAuthState(
        countryCode: countryCode ?? this.countryCode,
        isValidMobile: isValidMobile ?? this.isValidMobile,
        isTnCChecked: isTnCChecked ?? this.isTnCChecked,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        otp: otp ?? this.otp,
        currentState: currentState ?? this.currentState,
        errorMessage: errorMessage ?? this.errorMessage,
        verificationId: verificationId ?? this.verificationId,
        resendToken: resendToken ?? this.resendToken);
  }
}

enum CurrentState { inProgress, success, failure, codeSent, userAction }
