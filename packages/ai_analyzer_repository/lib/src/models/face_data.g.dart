// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'face_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaceData _$FaceDataFromJson(Map<String, dynamic> json) => FaceData(
      headEulerAngleX: (json['headEulerAngleX'] as num?)?.toDouble(),
      headEulerAngleY: (json['headEulerAngleY'] as num?)?.toDouble(),
      headEulerAngleZ: (json['headEulerAngleZ'] as num?)?.toDouble(),
      faceLandmarkData: (json['faceLandmarkData'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(
                    k, (e as List<dynamic>).map((e) => e as int).toList()),
              ))
          .toList(),
      smilingProbability: (json['smilingProbability'] as num?)?.toDouble(),
      faceContourData: (json['faceContourData'] as List<dynamic>?)
          ?.map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, e as List<dynamic>),
              ))
          .toList(),
      publicPath: json['publicPath'] as String?,
    );

Map<String, dynamic> _$FaceDataToJson(FaceData instance) => <String, dynamic>{
      'headEulerAngleX': instance.headEulerAngleX,
      'headEulerAngleY': instance.headEulerAngleY,
      'headEulerAngleZ': instance.headEulerAngleZ,
      'faceLandmarkData': instance.faceLandmarkData,
      'smilingProbability': instance.smilingProbability,
      'publicPath': instance.publicPath,
      'faceContourData': instance.faceContourData,
    };
