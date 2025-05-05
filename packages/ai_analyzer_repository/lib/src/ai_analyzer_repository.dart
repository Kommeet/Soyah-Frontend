import 'dart:math';
import 'dart:typed_data';

import 'package:ai_analyzer_repository/src/models/face_data.dart';

import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ImageAnalyseFailure implements Exception {
  const ImageAnalyseFailure([
    this.message = 'An unknown exception occurred.',
  ]);
  final String message;

  factory ImageAnalyseFailure.fromCode(AnalysisType analysisType) {
    switch (analysisType) {
      case AnalysisType.FcaeNotFount:
        return const ImageAnalyseFailure(
          'Face not found.',
        );
      case AnalysisType.MultipleFace:
        return const ImageAnalyseFailure(
          'Multiple face in the photo ',
        );
      default:
        return const ImageAnalyseFailure();
    }
  }
}

class AiAnalyzerRepository {
  Uint8List? image;
  List<Map<String, List<int>>> faceLandmarkData = [];

  List<Map<String, List<Map<String, List<int>>>>> faceContourData = [];

  Future<FaceData?> analyseImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final options = FaceDetectorOptions(
        enableLandmarks: true,
        enableClassification: true,
        enableTracking: true,
        enableContours: true);
    final faceDetector = FaceDetector(options: options);

    FaceData? faceData;

    final List<Face> faces = await faceDetector.processImage(inputImage);
    if (faces.isEmpty)
      throw ImageAnalyseFailure.fromCode(AnalysisType.FcaeNotFount);
    if (faces.length > 1)
      throw ImageAnalyseFailure.fromCode(AnalysisType.MultipleFace);

    for (Face face in faces) {
      for (FaceLandmarkType faceLandmarkType in FaceLandmarkType.values) {
        if (face.landmarks[faceLandmarkType] != null) {
          Map<String, List<int>> faceLandmarkMap = {
            faceLandmarkTypeValues.reverse[faceLandmarkType]!: [
              face.landmarks[faceLandmarkType]!.position.x,
              face.landmarks[faceLandmarkType]!.position.y
            ],
          };
          faceLandmarkData.add(faceLandmarkMap);
        }
      }

      for (FaceContourType faceContourType in FaceContourType.values) {
        if (face.contours[faceContourType] != null) {
          List<Map<String, List<int>>> faceContourPointList = [];
          int i = 0;
          for (Point point in face.contours[faceContourType]!.points) {
            List<int> faceContourPoint = [];
            faceContourPoint.add(point.x.toInt());
            faceContourPoint.add(point.y.toInt());

            faceContourPointList.add({"$i": faceContourPoint});
            i = i + 1;
          }

          Map<String, List<Map<String, List<int>>>> faceContourTypeMap = {
            faceContourTypeValues.reverse[faceContourType]!:
                faceContourPointList
          };
          faceContourData.add(faceContourTypeMap);
        }
      }
      print(faceContourData);
      faceData = FaceData(
          headEulerAngleX: face.headEulerAngleX,
          headEulerAngleY: face.headEulerAngleY,
          headEulerAngleZ: face.headEulerAngleZ,
          faceLandmarkData: faceLandmarkData,
          smilingProbability: face.smilingProbability,
          faceContourData: faceContourData);
    }
    return faceData;
  }
}

enum AnalysisType { FcaeNotFount, MultipleFace, FcaeNotMatch }
