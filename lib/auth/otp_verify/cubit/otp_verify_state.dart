part of 'otp_verify_cubit.dart';

final class OtpVerifyState extends Equatable {
  const OtpVerifyState({
    this.errorMessage,
    this.otpVerifyStatus,
  });

  final OtpVerifyStatus? otpVerifyStatus;
  final String? errorMessage;

  @override
  List<Object?> get props => [otpVerifyStatus, errorMessage];

  OtpVerifyState copyWith(
      {String? otpList,
      String? errorMessage,
      OtpVerifyStatus? otpVerifyStatus,
      bool? otpResendEnable}) {
    return OtpVerifyState(
      errorMessage: errorMessage ?? this.errorMessage,
      otpVerifyStatus: otpVerifyStatus ?? this.otpVerifyStatus,
    );
  }
}

final class OtpVerifyInitial extends OtpVerifyState {}

enum OtpVerifyStatus { inProgress, success, invalid, otpResent, initial }
