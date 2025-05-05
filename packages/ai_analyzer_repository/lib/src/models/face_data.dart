import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'face_data.g.dart';

@JsonSerializable()
class FaceData {
  FaceData(
      {this.headEulerAngleX,
      this.headEulerAngleY,
      this.headEulerAngleZ,
      this.faceLandmarkData,
      this.smilingProbability,
      this.faceContourData,this.publicPath});

  final double? headEulerAngleX;
  final double? headEulerAngleY;
  final double? headEulerAngleZ;
  final List<Map<String, List<int>>>? faceLandmarkData;
  final double? smilingProbability;
  final String? publicPath;
  //final List<Map<String, List<List<int>>>>? faceContourData;
   final List<Map<String, List<dynamic>>>? faceContourData;

  factory FaceData.fromJson(Map<String, dynamic> json) =>
      _$FaceDataFromJson(json);

  Map<String, dynamic> toJson() => _$FaceDataToJson(this);
}

final faceLandmarkTypeValues = EnumValues({
  'bottomMouth': FaceLandmarkType.bottomMouth,
  'rightMouth': FaceLandmarkType.rightMouth,
  'leftMouth': FaceLandmarkType.leftMouth,
  'rightEye': FaceLandmarkType.rightEye,
  'leftEye': FaceLandmarkType.leftEye,
  'rightEar': FaceLandmarkType.rightEar,
  'leftEar': FaceLandmarkType.leftEar,
  'rightCheek': FaceLandmarkType.rightCheek,
  'leftCheek': FaceLandmarkType.leftCheek,
  'noseBase': FaceLandmarkType.noseBase,
});

final faceContourTypeValues = EnumValues({
  'face': FaceContourType.face,
  'leftEyebrowTop': FaceContourType.leftEyebrowTop,
  'leftEyebrowBottom': FaceContourType.leftEyebrowBottom,
  'rightEyebrowTop': FaceContourType.rightEyebrowTop,
  'rightEyebrowBottom': FaceContourType.rightEyebrowBottom,
  'leftEye': FaceContourType.leftEye,
  'rightEye': FaceContourType.rightEye,
  'upperLipTop': FaceContourType.upperLipTop,
  'upperLipBottom': FaceContourType.upperLipBottom,
  'lowerLipTop': FaceContourType.lowerLipTop,
  'lowerLipBottom': FaceContourType.lowerLipBottom,
  'noseBridge': FaceContourType.noseBridge,
  'noseBottom': FaceContourType.noseBottom,
  'leftCheek': FaceContourType.leftCheek,
  'rightCheek': FaceContourType.rightCheek,
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
