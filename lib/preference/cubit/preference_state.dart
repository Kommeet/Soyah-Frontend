part of 'preference_cubit.dart';

class PreferenceState extends Equatable {
  const PreferenceState({
    this.selectedImagePath,
    this.galleryUrls = const [],
    this.faceDataList = const [],
    this.uploadStatus,
    this.errorMessage,
  });

  final String? selectedImagePath;
  final List<String> galleryUrls;
  final List<ai_model.FaceData> faceDataList;
  final UploadStatus? uploadStatus;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        selectedImagePath,
        galleryUrls,
        faceDataList,
        uploadStatus,
        errorMessage,
      ];

  PreferenceState copyWith({
    String? selectedImagePath,
    List<String>? galleryUrls,
    List<ai_model.FaceData>? faceDataList,
    UploadStatus? uploadStatus,
    String? errorMessage,
  }) {
    return PreferenceState(
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      faceDataList: faceDataList ?? this.faceDataList,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final class PreferenceInitial extends PreferenceState {}

enum UploadStatus {
  inProgress,
  completed,
  error,
  imageSelected,
  analysisFailed,
}
