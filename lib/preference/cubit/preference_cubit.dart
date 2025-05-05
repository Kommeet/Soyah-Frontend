import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ai_analyzer_repository/ai_ analyzer_repository.dart' as ai_model;
import 'package:cloud_connect_repository/cloud_connect_repository.dart' as cloudConnect;
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

part 'preference_state.dart';

class PreferenceCubit extends Cubit<PreferenceState> {
  PreferenceCubit({required this.currentUser}) : super(const PreferenceState());

  User currentUser;
  late final StreamSubscription _subscription;
  final ImagePicker _picker = ImagePicker();

  void selectPhoto(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      List<ai_model.FaceData> faceList = [];
      bool sameImage = false;
      if (pickedFile != null) {
        try {
          ai_model.FaceData? faceData = await ai_model.AiAnalyzerRepository()
              .analyseImage(pickedFile.path);

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

  Future<void> uploadImages(List<String> imageUrls) async {
    for (String url in imageUrls) {
      await saveImageData(filePath: null, publicPath: url);
    }
  }

  Future<void> saveImageData({String? filePath, required String publicPath}) async {
    try {
      String? base64Image;

      if (filePath != null) {
        base64Image = base64Encode(await File(filePath).readAsBytes());
      }

      // Prepare JSON payload
      Map<String, dynamic> imageData = {
        if (base64Image != null) "faceData": base64Image,
        "publicPath": publicPath,
      };


      // Print the JSON data to the console
    print("Sending image data to backend: ${jsonEncode({"images": [imageData]})}");

      // Send data to Go backend
      const String apiUrl = "https://soyah-go-wildflower-905-holy-morning-7136.fly.dev/api/save-image-data";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"images": [imageData]}),
      );

      if (response.statusCode != 200) {
        print("Failed to save image data: ${response.body}");
      }
    } catch (e) {
      print("Error saving image data: $e");
    }
  }
}

