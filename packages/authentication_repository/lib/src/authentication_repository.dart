import 'dart:async';

import 'package:authentication_repository/src/models/user.dart';
import 'package:cache/cashe.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template verify_user_with_phonen_numberFailure}
/// Thrown during the verify process if a failure occurs.
/// {@endtemplate}
class VerifyPhoneNumberFailure implements Exception {
  /// {@macro verify_user_with_phonen_numberFailure}
  const VerifyPhoneNumberFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithPhoneNumber.html
  factory VerifyPhoneNumberFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const VerifyPhoneNumberFailure(
          'The email address is not valid.',
        );
      case 'user-disabled':
        return const VerifyPhoneNumberFailure(
          'The user account has been disabled.',
        );
      case 'user-not-found':
        return const VerifyPhoneNumberFailure(
          'No user found with this email.',
        );
      case 'wrong-password':
        return const VerifyPhoneNumberFailure(
          'Incorrect password.',
        );
      case 'email-already-in-use':
        return const VerifyPhoneNumberFailure(
          'The email address is already in use by another account.',
        );
      case 'operation-not-allowed':
        return const VerifyPhoneNumberFailure(
          'This sign-in method is not allowed.',
        );
      case 'weak-password':
        return const VerifyPhoneNumberFailure(
          'The password is too weak.',
        );
      case 'too-many-requests':
        return const VerifyPhoneNumberFailure(
          'Too many requests. Try again later.',
        );
      case 'network-request-failed':
        return const VerifyPhoneNumberFailure(
          'Network error. Please check your connection.',
        );
      case 'credential-already-in-use':
        return const VerifyPhoneNumberFailure(
          'This credential is already associated with a different user.',
        );
      case 'invalid-credential':
        return const VerifyPhoneNumberFailure(
          'The credential is invalid or expired.',
        );
      case 'requires-recent-login':
        return const VerifyPhoneNumberFailure(
          'Please log in again to perform this action.',
        );
      case 'account-exists-with-different-credential':
        return const VerifyPhoneNumberFailure(
          'An account already exists with the same email but different credentials.',
        );
      case 'invalid-verification-code':
        return const VerifyPhoneNumberFailure(
          'The verification code is invalid.',
        );
      case 'invalid-verification-id':
        return const VerifyPhoneNumberFailure(
          'The verification ID is invalid.',
        );
      case 'session-expired':
        return const VerifyPhoneNumberFailure(
          'The verification session has expired. Please try again.',
        );
      case 'missing-email':
        return const VerifyPhoneNumberFailure(
          'An email address must be provided.',
        );
      case 'internal-error':
        return const VerifyPhoneNumberFailure(
          'An internal error occurred. Please try again later.',
        );
      case 'unknown':
        return const VerifyPhoneNumberFailure(
          'An unknown error occurred. Please try again.',
        );
      default:
        return VerifyPhoneNumberFailure(
          'An unexpected error occurred.',
        );
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
    required SharedPreferences prefs,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        prefs = prefs;

  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final SharedPreferences prefs;
  
  // Constants for SharedPreferences keys
  static const String _profilePictureKey = 'profile_picture_url';

  bool isLoginFlow = false;
  bool? serviceEnabled;
  LocationPermission? permission;

  /// Whether or not the current environment is web
  /// Should only be overridden for testing purposes. Otherwise,
  /// defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  String? _verificationId;
  String? _phoneNumber;
  int? _resendToken;

  /// Getter for verificationId
  String? get verificationId => _verificationId;

  // Method to set phone number
  Future<void> setPhoneNumber(String phoneNumber) async {
    _phoneNumber = phoneNumber;
  }

  // Method to get phone number
  String? getPhoneNumber() {
    return _phoneNumber;
  }

  /// Save profile picture URL to SharedPreferences
  Future<void> saveProfilePictureUrl(String url) async {
    await prefs.setString(_profilePictureKey, url);
  }

  /// Get profile picture URL from SharedPreferences
  String? getProfilePictureUrl() {
    return prefs.getString(_profilePictureKey);
  }

  /// Setter for verificationId
  set verificationId(String? value) {
    _verificationId = value;
  }

  /// Getter for resendToken
  int? get resendToken => _resendToken;

  /// Setter for resendToken
  set resendToken(int? value) {
    _resendToken = value;
  }

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final int? last_auth = prefs.getInt('last_auth');
      if (last_auth == null) {
        if (firebaseUser != null && isLoginFlow) {
          writeLastAuthPref();
          final user = firebaseUser.toUser;
          _cache.write(key: userCacheKey, value: user);
          return user;
        } else {
          logOut();
          return User.empty;
        }
      } else {
        final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
        _cache.write(key: userCacheKey, value: user);
        return user;
      }
    });
  }

  Stream<int> countStream(int to) async* {
    for (int i = 1; i <= to; i++) {
      yield i;
    }
  }

  void writeLastAuthPref() async {
    await prefs.setInt('last_auth', DateTime.now().microsecondsSinceEpoch);
  }

  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  /// Creates a new user with the provided [mobile number].
  ///
  /// Throws a [VerifyUserWithPhoneNumberFailure] if an exception occurs.

  Future<void> verifyUserWithPhoneNumber({
    required String phoneNumber,
    required Function(firebase_auth.PhoneAuthCredential) verificationCompleted,
    required Function(firebase_auth.FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout, required int forceResendingToken,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: (verificationId, forceResendingToken) {
          this.verificationId = verificationId;
          this.resendToken = forceResendingToken;
          codeSent(verificationId, forceResendingToken);
        },
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw VerifyPhoneNumberFailure.fromCode(e.code);
    } catch (e) {
      throw const VerifyPhoneNumberFailure();
    }
  }

  Future<void> verifyCode(
      {required String verificationId, required String smsCode}) async {
    try {
      isLoginFlow = true;
      firebase_auth.PhoneAuthCredential phoneAuthCredential =
          firebase_auth.PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);
      await _firebaseAuth.signInWithCredential(phoneAuthCredential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw VerifyPhoneNumberFailure.fromCode(e.code);
    } catch (_) {
      throw const VerifyPhoneNumberFailure();
    }
  }

  Future<void> updateUserStage(String stage) async {
    var user = _firebaseAuth.currentUser;
    user!.updatePhotoURL(stage);
  }

  Future<void> resendCode({
    required int forceResendingToken,
    required String phoneNumber,
    required Function(firebase_auth.PhoneAuthCredential) verificationCompleted,
    required Function(firebase_auth.FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        forceResendingToken: forceResendingToken,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw VerifyPhoneNumberFailure.fromCode(e.code);
    } catch (_) {
      throw const VerifyPhoneNumberFailure();
    }
  }

  Future<void> signInWithCredential(
      {required firebase_auth.PhoneAuthCredential authCredential}) async {
    try {
      await _firebaseAuth.signInWithCredential(authCredential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw VerifyPhoneNumberFailure.fromCode(e.code);
    } catch (_) {
      throw const VerifyPhoneNumberFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  Future<void> determinePermission() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission ?? LocationPermission.denied;
  }
}

extension on firebase_auth.User {
  /// Maps a [firebase_auth.User] into a [User].
  User get toUser {
    return User(
      id: uid,
      mobile: phoneNumber,
      idToken: getIdToken(),
      stage: photoURL,
    );
  }
}