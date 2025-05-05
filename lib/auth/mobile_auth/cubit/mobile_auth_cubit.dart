// import 'package:authentication_repository/authentication_repository.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:sohyah/auth/mobile_auth/mobile_auth.dart';

// part 'mobile_auth_state.dart';

// class MobileAuthCubit extends Cubit<MobileAuthState> {
//   MobileAuthCubit(this._authenticationRepository)
//       : _resendToken = 0,
//         super(const MobileAuthState());

//   final AuthenticationRepository _authenticationRepository;
//   int _resendToken; // Store the resend token

//   Future<void> submitMobileNumber() async {
//     try {
//       await _authenticationRepository.verifyUserWithPhoneNumber(
//         phoneNumber: '${state.countryCode} ${state.phoneNumber ?? ''}',
//         verificationCompleted: (firebase_auth.PhoneAuthCredential credential) async {
//           await _authenticationRepository.signInWithCredential(authCredential: credential);
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           emit(state.copyWith(
//             currentState: CurrentState.codeSent,
//             verificationId: verificationId,
//             resendToken: resendToken,
//           ));
//           _resendToken = resendToken ?? 0; // Save the resend token
//         },
//         forceResendingToken: _resendToken, // Use the stored token for resends
//         verificationFailed: (firebase_auth.FirebaseAuthException e) {
//           emit(state.copyWith(
//             errorMessage: VerifyPhoneNumberFailure.fromCode(e.code).message,
//             currentState: CurrentState.failure,
//           ));
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {},
//       );
//     } on VerifyPhoneNumberFailure catch (e) {
//       emit(state.copyWith(errorMessage: e.message, currentState: CurrentState.failure));
//     } catch (_) {
//       emit(state.copyWith(
//           errorMessage: 'Operation is not allowed. Please contact support.',
//           currentState: CurrentState.failure));
//     }
//   }

//   void checkTnC(bool isCheckedTnC) {
//     emit(state.copyWith(isTnCChecked: isCheckedTnC));
//   }

//   void changeCountryPicker(String countryCode) {
//     emit(state.copyWith(countryCode: countryCode));
//   }

//   String? getPhoneNumber() {
//     return state.phoneNumber;
//   }

//   void submitOtpNumber(String otp) {
//     print('Got pin on Cubit: $otp');
//   }

//   void phoneNumberChanged(String phoneNumber) {
//     emit(state.copyWith(
//       countryCode: state.countryCode,
//       isValidMobile: phoneNumber.isValidPhoneNumber(),
//       phoneNumber: phoneNumber,
//     ));
//   }
// }



import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:sohyah/auth/mobile_auth/mobile_auth.dart';

part 'mobile_auth_state.dart';

class MobileAuthCubit extends Cubit<MobileAuthState> {
  MobileAuthCubit(this._authenticationRepository)
      : _resendToken = 0,
        super(const MobileAuthState());

  final AuthenticationRepository _authenticationRepository;
  int _resendToken;

  Future<void> submitMobileNumber() async {
    try {
      final phoneNumber = '${state.countryCode} ${state.phoneNumber ?? ''}';
      
      await _authenticationRepository.setPhoneNumber(phoneNumber);
      
      await _authenticationRepository.verifyUserWithPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (firebase_auth.PhoneAuthCredential credential) async {
          await _authenticationRepository.signInWithCredential(authCredential: credential);
        },
        codeSent: (String verificationId, int? resendToken) {
          emit(state.copyWith(
            currentState: CurrentState.codeSent,
            verificationId: verificationId,
            resendToken: resendToken,
          ));
          _resendToken = resendToken ?? 0; 
        },
        forceResendingToken: _resendToken, // Use the stored token for resends
        verificationFailed: (firebase_auth.FirebaseAuthException e) {
          emit(state.copyWith(
            errorMessage: VerifyPhoneNumberFailure.fromCode(e.code).message,
            currentState: CurrentState.failure,
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on VerifyPhoneNumberFailure catch (e) {
      emit(state.copyWith(errorMessage: e.message, currentState: CurrentState.failure));
    } catch (_) {
      emit(state.copyWith(
          errorMessage: 'Operation is not allowed. Please contact support.',
          currentState: CurrentState.failure));
    }
  }

  void checkTnC(bool isCheckedTnC) {
    emit(state.copyWith(isTnCChecked: isCheckedTnC));
  }

  void changeCountryPicker(String countryCode) {
    emit(state.copyWith(countryCode: countryCode));
  }

  String? getPhoneNumber() {
    return state.phoneNumber;
  }

  void submitOtpNumber(String otp) {
    print('Got pin on Cubit: $otp');
    // Verify OTP
    // After verification, phone number is used as the ID in MongoDB
  }

  void phoneNumberChanged(String phoneNumber) {
    emit(state.copyWith(
      countryCode: state.countryCode,
      isValidMobile: phoneNumber.isValidPhoneNumber(),
      phoneNumber: phoneNumber,
    ));
  }
}