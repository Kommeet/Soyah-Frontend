import 'dart:async';
import 'dart:io';

import 'package:cloud_connect_repository/src/models/enum.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:authentication_repository/authentication_repository.dart';

class CloudFuntionFailure implements Exception {
  /// {@macro verify_user_with_phonen_numberFailure}
  const CloudFuntionFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithPhoneNumber.html
  factory CloudFuntionFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-phone-number':
        return const CloudFuntionFailure(
          'Mobile number is not valid or badly formatted.',
        );
      case 'TOO_SHORT':
        return const CloudFuntionFailure(
          'Mobile number is not valid or badly formatted.',
        );

      case 'operation-not-allowed':
        return const CloudFuntionFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'firebase_auth/invalid-verification-code':
        return const CloudFuntionFailure(
          'The verification code from SMS is invalid. Please check and enter the correct verification code again.',
        );

      default:
        return const CloudFuntionFailure();
    }
  }

  /// The associated error message.
  final String message;
}

class CloudConnectRepository {
  CloudConnectRepository({User? currentUser}) : _currentUser = currentUser;

  User? _currentUser;
  final _controller = StreamController<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get response => _controller.stream;

  void addToStream(Map<String, dynamic> response) =>
      _controller.sink.add(response);
  Future<String> getCloudUser({required Future<String?>? idToken}) async {
    try {
    
          await FirebaseFunctions.instance.httpsCallable('savedetails').call();
      // final bodyJson = jsonDecode(result.data) as Map<String, dynamic>;
      return 's';
    } on FirebaseFunctionsException catch (error) {
      throw CloudFuntionFailure.fromCode(error.code);
    }
  }

  Future<void> uploadPhoto({required File imageFile,required String path}) async {
    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(_currentUser!.id)
        .child(path)
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': imageFile.path},
    );

    try {
      UploadTask uploadTask = ref.putFile(imageFile, metadata);
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            addToStream({
              'progress': progress,
              'uploadStatus': UploadStatus.progressing
            });
            print("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            addToStream({
              'uploadStatus': UploadStatus.error,
            });
            break;
          case TaskState.success:
            addToStream({
              'downloadURL': await taskSnapshot.ref.getDownloadURL(),
              'uploadStatus': UploadStatus.completed
            });

            break;
        }
      });
    } catch (e) {
      addToStream({
        'uploadStatus': UploadStatus.error,
      });
    }
  }

  Future<void> saveData({required Map<String, dynamic> dataMap,required CloudFuntions cloudFuntion}) async {
    try {
      final result =
          await FirebaseFunctions.instance.httpsCallable(CloudFuntionsValues.reverse[cloudFuntion]!).call(dataMap);
     
      print(result);
    } on FirebaseFunctionsException catch (error) {
      print(error);
      throw CloudFuntionFailure.fromCode(error.code);
      
    }
  }
}

enum UploadStatus { progressing, completed, error }
