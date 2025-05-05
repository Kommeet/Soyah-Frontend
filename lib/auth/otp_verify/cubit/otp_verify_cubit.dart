import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
part 'otp_verify_state.dart';

class OtpVerifyCubit extends Cubit<OtpVerifyState> {
  OtpVerifyCubit(
      {required this.authenticationRepository,
      required this.verificationId,
      this.resendToken})
      : super(const OtpVerifyState());

  AuthenticationRepository authenticationRepository;
  String verificationId;
  int? resendToken;

  Future<void> verifyOtp({required String otpCode}) async {

    try {
      emit(state.copyWith(otpVerifyStatus: OtpVerifyStatus.inProgress));
      await authenticationRepository.verifyCode(
          verificationId: verificationId, smsCode: otpCode);

      emit(state.copyWith(otpVerifyStatus: OtpVerifyStatus.success));
    } on VerifyPhoneNumberFailure catch (e) {
      emit(state.copyWith(
          otpVerifyStatus: OtpVerifyStatus.invalid, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(otpVerifyStatus: OtpVerifyStatus.invalid));
    }
  }

  Future<void> resendCode(String phoneNumber) async {
    if (resendToken == null) return;
    try {
      await authenticationRepository.resendCode(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (firebase_auth.PhoneAuthCredential credential) async {},
          codeSent: (String freshVerificationId, int? freshResendToken) {
            verificationId = freshVerificationId;
            resendToken = freshResendToken;
            emit(state.copyWith(otpVerifyStatus: OtpVerifyStatus.otpResent));
          },
          verificationFailed: (firebase_auth.FirebaseAuthException e) {},
          codeAutoRetrievalTimeout: (String verificationId) {},
          forceResendingToken: resendToken!);
    } catch (_) {}
  }

  Future<void> updateUser({required String uid}) async {
   // await authenticationRepository.updateUserStage(stage: '1',uuid: uid);
 
  }
}
