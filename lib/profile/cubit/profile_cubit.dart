// import 'dart:async';
// import 'dart:io';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:ai_analyzer_repository/ai_ analyzer_repository.dart'
//     as ai_model;
// import 'package:cloud_connect_repository/cloud_connect_repository.dart'
//     as cloudConnect;
// import 'package:authentication_repository/authentication_repository.dart';
// import 'package:flutter/widgets.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/cupertino.dart';

// part 'profile_state.dart';

// class ProfileCubit extends Cubit<ProfileState> {
//   ProfileCubit({required this.currentUser, required this.authRepository})
//       : super(const ProfileState());

//   User currentUser;
//   final AuthenticationRepository authRepository;
//   late final StreamSubscription _subscription;
//   final ImagePicker _picker = ImagePicker();

//   String? getPhoneId() {
//     final phoneNumber = authRepository.getPhoneNumber();
//     if (phoneNumber == null || phoneNumber.isEmpty) {
//       return null;
//     }
//     // Sanitize phone number for use as ID
//     return phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
//   }

//   void selectPhoto(BuildContext context) async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: ImageSource.gallery,
//       );
//       List<ai_model.FaceData> faceList = [];
//       bool sameImage = false;
//       if (pickedFile != null) {
//         try {
//           ai_model.FaceData? faceData = await ai_model.AiAnalyzerRepository()
//               .analyseImage(pickedFile.path);

//           for (ai_model.FaceData faceObject in state.faceDataList) {
//             if (faceObject.smilingProbability == faceData!.smilingProbability &&
//                 faceObject.headEulerAngleX == faceData.headEulerAngleX) {
//               sameImage = true;
//             }
//           }

//           if (sameImage) {
//             emit(state.copyWith(
//                 uploadStatus: UploadStatus.analysisFailed,
//                 errorMessage: 'You cannot upload the same image again'));
//           } else {
//             faceList.addAll(state.faceDataList);
//             faceList.add(faceData!);

//             emit(state.copyWith(
//                 selectedImagePath: pickedFile.path,
//                 galleryUrls: state.galleryUrls,
//                 faceDataList: faceList,
//                 uploadStatus: UploadStatus.imageSelected));
//           }
//         } on ai_model.ImageAnalyseFailure catch (e) {
//           emit(state.copyWith(
//               uploadStatus: UploadStatus.analysisFailed,
//               errorMessage: e.message));
//         } catch (_) {
//           emit(state.copyWith(
//               uploadStatus: UploadStatus.analysisFailed, errorMessage: ''));
//         }
//       }
//     } catch (e) {
//       emit(state.copyWith(
//           uploadStatus: UploadStatus.analysisFailed, errorMessage: ''));
//     }
//   }

//   void uploadPhoto() async {
//     cloudConnect.CloudConnectRepository connect =
//         cloudConnect.CloudConnectRepository(currentUser: currentUser);
//     String? localFilePath = state.selectedImagePath;
//     emit(state.copyWith(
//       uploadStatus: UploadStatus.inProgress,
//     ));
//     connect.uploadPhoto(
//         imageFile: File(state.selectedImagePath!), path: 'preferred');
//     _subscription = connect.response.listen((response) {
//       List<String> galleryList = [];
//       if (response['uploadStatus'] == cloudConnect.UploadStatus.completed) {
//         galleryList.addAll(state.galleryUrls);
//         galleryList.add(response['downloadURL']);

//         emit(state.copyWith(
//             galleryUrls: galleryList,
//             selectedImagePath: '',
//             uploadStatus: UploadStatus.completed));

//         saveImageData(
//             filePath: localFilePath, publicPath: response['downloadURL']);
//       }
//       if (response['uploadStatus'] == cloudConnect.UploadStatus.error) {
//         emit(state.copyWith(
//           uploadStatus: UploadStatus.error,
//         ));
//       }
//     }, onError: (error) {
//       emit(state.copyWith(
//         uploadStatus: UploadStatus.error,
//       ));
//     });
//   }

//   void saveImageData(
//       {required String? filePath, required String publicPath}) async {
//     try {
//       if (filePath != null) {
//         final face =
//             await ai_model.AiAnalyzerRepository().analyseImage(filePath);

//         // Get phone ID for MongoDB document ID
//         final phoneId = getPhoneId();

//         if (face != null) {
//           // Check if this is the first image (profile picture)
//           bool isFirstImage = state.galleryUrls.isEmpty ||
//               (state.galleryUrls.length == 1 &&
//                   state.galleryUrls[0] == publicPath);

//           cloudConnect.CloudConnectRepository().saveData(dataMap: {
//             'phoneId': phoneId, // Add phone ID to data
//             'FaceData': face.toJson(),
//             'publicPath': publicPath,
//             'isProfilePicture':
//                 isFirstImage 
//           }, cloudFuntion: cloudConnect.CloudFuntions.AddPreferredPictureData);

//           if (isFirstImage) {
//             authRepository.saveProfilePictureUrl(publicPath);
//           }
//         }
//       }
//     } catch (_) {}
//   }
// }


import 'dart:async';
import 'dart:io';
import 'package:ai_analyzer_repository/ai_%20analyzer_repository.dart' as ai_model;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_connect_repository/cloud_connect_repository.dart' as cloudConnect;
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Add Firebase Storage

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.currentUser, required this.authRepository})
      : super(const ProfileState());

  User currentUser;
  final AuthenticationRepository authRepository;
  late final StreamSubscription _subscription;
  final ImagePicker _picker = ImagePicker();
  String? profilePictureUrl; // Variable to store profile picture URL

  String? getPhoneId() {
    final phoneNumber = authRepository.getPhoneNumber();
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return null;
    }
    // Sanitize phone number for use as ID
    return phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  }

  void selectPhoto(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      List<ai_model.FaceData> faceList = [];
      bool sameImage = false;
      if (pickedFile != null) {
        try {
          ai_model.FaceData? faceData =
              await ai_model.AiAnalyzerRepository().analyseImage(pickedFile.path);

          for (ai_model.FaceData faceObject in state.faceDataList) {
            if (faceObject.smilingProbability == faceData!.smilingProbability &&
                faceObject.headEulerAngleX == faceData.headEulerAngleX) {
              sameImage = true;
            }
          }

          if (sameImage) {
            emit(state.copyWith(
                uploadStatus: UploadStatus.analysisFailed,
                errorMessage: 'You cannot upload the same image again'));
          } else {
            faceList.addAll(state.faceDataList);
            faceList.add(faceData!);

            emit(state.copyWith(
                selectedImagePath: pickedFile.path,
                galleryUrls: state.galleryUrls,
                faceDataList: faceList,
                uploadStatus: UploadStatus.imageSelected));
          }
        } on ai_model.ImageAnalyseFailure catch (e) {
          emit(state.copyWith(
              uploadStatus: UploadStatus.analysisFailed,
              errorMessage: e.message));
        } catch (_) {
          emit(state.copyWith(
              uploadStatus: UploadStatus.analysisFailed, errorMessage: ''));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          uploadStatus: UploadStatus.analysisFailed, errorMessage: ''));
    }
  }

  void uploadPhoto() async {
    cloudConnect.CloudConnectRepository connect =
        cloudConnect.CloudConnectRepository(currentUser: currentUser);
    String? localFilePath = state.selectedImagePath;
    emit(state.copyWith(
      uploadStatus: UploadStatus.inProgress,
    ));
    connect.uploadPhoto(
        imageFile: File(state.selectedImagePath!), path: 'preferred');
    _subscription = connect.response.listen((response) {
      List<String> galleryList = [];
      if (response['uploadStatus'] == cloudConnect.UploadStatus.completed) {
        galleryList.addAll(state.galleryUrls);
        galleryList.add(response['downloadURL']);

        emit(state.copyWith(
            galleryUrls: galleryList,
            selectedImagePath: '',
            uploadStatus: UploadStatus.completed));

        saveImageData(
            filePath: localFilePath, publicPath: response['downloadURL']);
      }
      if (response['uploadStatus'] == cloudConnect.UploadStatus.error) {
        emit(state.copyWith(
          uploadStatus: UploadStatus.error,
        ));
      }
    }, onError: (error) {
      emit(state.copyWith(
        uploadStatus: UploadStatus.error,
      ));
    });
  }

  Future<void> saveImageData(
      {required String? filePath, required String publicPath}) async {
    try {
      if (filePath != null) {
        final face =
            await ai_model.AiAnalyzerRepository().analyseImage(filePath);

        // Get phone ID for MongoDB document ID and Firebase Storage
        final phoneId = getPhoneId();
        if (phoneId == null) {
          emit(state.copyWith(
              uploadStatus: UploadStatus.error,
              errorMessage: 'Phone ID not found'));
          return;
        }

        // Check if this is the first image (profile picture)
        bool isFirstImage = state.galleryUrls.isEmpty;

        // If first image, upload to Firebase Storage
        if (isFirstImage) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_images/$phoneId.jpg');
          final uploadTask = await storageRef.putFile(File(filePath));
          profilePictureUrl = await uploadTask.ref.getDownloadURL();
          authRepository.saveProfilePictureUrl(profilePictureUrl!);
        }

        if (face != null) {
          cloudConnect.CloudConnectRepository().saveData(dataMap: {
            'phoneId': phoneId,
            'FaceData': face.toJson(),
            'publicPath': publicPath,
            'isProfilePicture': isFirstImage,
            'profilePictureUrl': isFirstImage ? profilePictureUrl : null,
          }, cloudFuntion: cloudConnect.CloudFuntions.AddPreferredPictureData);
        }
      }
    } catch (e) {
      emit(state.copyWith(
          uploadStatus: UploadStatus.error, errorMessage: e.toString()));
    }
  }
}