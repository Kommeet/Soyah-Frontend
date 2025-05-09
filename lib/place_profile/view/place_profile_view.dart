import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:sohyah/home/models/place.dart';
import '../../app/view/common/continue_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:async';

class PlaceProfileView extends StatefulWidget {
  final Place place;

  const PlaceProfileView({super.key, required this.place});

  @override
  _PlaceProfileViewState createState() => _PlaceProfileViewState();
}

class _PlaceProfileViewState extends State<PlaceProfileView> {
  bool _isCameraOpen = false;
  bool _showCarousel = false;
  bool _isRecording = false;
  int _recordingSecondsLeft = 5;
  Timer? _recordingTimer;
  int _currentCarouselIndex = 0;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedVideo;
  XFile? _capturedVideo;
  XFile? _capturedImage;
  VideoPlayerController? _videoController;
  List<Map<String, dynamic>> _reels = [];
  List<Map<String, dynamic>> _photos = [];
  List<Map<String, dynamic>> _mediaItems = [];
  bool _isLoadingMedia = true;
  String? _mediaError;
  bool _isUploading = false;
  Map<String, VideoPlayerController> _reelControllers = {};
  final PageController _carouselController = PageController();
  List<String> _visitorImages = [];
  bool _isLoadingVisitors = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _fetchMedia();
    _fetchVisitorImages();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        final rearCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras!.first,
        );
        _cameraController = CameraController(
          rearCamera,
          ResolutionPreset.medium,
          enableAudio: true,
        );
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _fetchMedia() async {
    try {
      final placeId = widget.place.placeId;

      // Fetch reels
      final reelResponse = await http.get(
        Uri.parse(
          'https://soyah-go-wildflower-905-holy-morning-7136.fly.dev/api/reels?placeId=$placeId',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (reelResponse.statusCode == 200) {
        final reelData = jsonDecode(reelResponse.body);
        final List<dynamic> reels = reelData['reels'] ?? [];
        _reels = reels
            .map<Map<String, dynamic>>((reel) => {
                  'type': 'video',
                  'url': reel['url'] as String,
                  'firestoreDocPath': reel['firestoreDocPath'] ?? '',
                  'duration': 10,
                })
            .toList();
      } else {
        setState(() {
          _mediaError = 'Failed to load reels: ${reelResponse.reasonPhrase}';
        });
      }

      // Fetch photos from Firestore
      final photoSnapshot = await FirebaseFirestore.instance
          .collection('places')
          .doc(placeId)
          .collection('photos')
          .get();

      _photos = photoSnapshot.docs
          .map<Map<String, dynamic>>((doc) => {
                'type': 'image',
                'url': doc.data()['url'] as String,
                'firestoreDocPath': doc.reference.path,
              })
          .toList();

      // Combine reels and photos
      setState(() {
        _mediaItems = [..._reels, ..._photos];
        _isLoadingMedia = false;
      });
    } catch (e) {
      setState(() {
        _mediaError = 'Error loading media: $e';
        _isLoadingMedia = false;
      });
    }
  }

  Future<void> _fetchVisitorImages() async {
    setState(() {
      _isLoadingVisitors = true;
    });

    try {
      final images = await fetchVisitorImages(widget.place.placeId);
      setState(() {
        _visitorImages = images;
        _isLoadingVisitors = false;
      });
    } catch (e) {
      print('Error fetching visitor images: $e');
      setState(() {
        _visitorImages = [];
        _isLoadingVisitors = false;
      });
    }
  }

  Future<void> _quickRecordReel() async {
    var cameraStatus = await Permission.camera.request();
    var micStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && micStatus.isGranted) {
      if (_cameraController != null) {
        try {
          await _cameraController!.initialize();
          setState(() {
            _isCameraOpen = true;
          });

          await Future.delayed(const Duration(milliseconds: 500));
          _startAutoRecording();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error initializing camera: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera or microphone permission denied')),
      );
    }
  }

  Future<void> _startAutoRecording() async {
    if (!_cameraController!.value.isInitialized) {
      return;
    }

    try {
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _recordingSecondsLeft = 5;
      });

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_recordingSecondsLeft > 1) {
            _recordingSecondsLeft--;
          } else {
            _finishQuickRecording();
            timer.cancel();
          }
        });
      });

      Future.delayed(const Duration(seconds: 5), () {
        if (_isRecording) {
          _finishQuickRecording();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting video recording: $e')),
      );
    }
  }

  Future<void> _finishQuickRecording() async {
    if (!_isRecording) {
      return;
    }

    _recordingTimer?.cancel();

    try {
      final video = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _capturedVideo = video;
      });

      _videoController = VideoPlayerController.file(File(video.path));
      await _videoController!.initialize();

      _showQuickVideoConfirmationDialog();
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error stopping video recording: $e')),
      );
    }
  }

  void _showQuickVideoConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Upload 5-Second Reel?'),
        content: _videoController != null
            ? SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    VideoPlayer(_videoController!),
                    Center(
                      child: IconButton(
                        icon: Icon(
                          _videoController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white.withOpacity(0.7),
                          size: 50,
                        ),
                        onPressed: () {
                          if (_videoController!.value.isPlaying) {
                            _videoController!.pause();
                          } else {
                            _videoController!.play();
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Text('Video captured successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _videoController?.dispose();
              setState(() {
                _capturedVideo = null;
                _isCameraOpen = false;
              });
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isUploading
                ? null
                : () {
                    Navigator.pop(context);
                    _uploadQuickReel();
                  },
            child: _isUploading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Upload'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadQuickReel() async {
    if (_capturedVideo == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final file = File(_capturedVideo!.path);
      final fileName =
          'quick_${widget.place.placeId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(_capturedVideo!.path)}';
      final storageRef =
          FirebaseStorage.instance.ref().child('reels').child(fileName);

      await storageRef.putFile(file);
      final downloadUrl = await storageRef.getDownloadURL();

      final docRef = await FirebaseFirestore.instance
          .collection('places')
          .doc(widget.place.placeId)
          .collection('reels')
          .add({
        'url': downloadUrl,
        'placeId': widget.place.placeId,
        'createdAt': FieldValue.serverTimestamp(),
        'duration': 5,
        'type': 'quick_reel',
      });

      final firestoreDocPath = docRef.path;
      await _saveReelToMongoDB(
        widget.place.placeId,
        firestoreDocPath,
        downloadUrl,
        5,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quick reel uploaded successfully')),
      );

      await _fetchMedia();

      _videoController?.dispose();
      setState(() {
        _capturedVideo = null;
        _isUploading = false;
        _isCameraOpen = false;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading quick reel: $e')),
      );
    }
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final image = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = image;
      });
      _showImageConfirmationDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking picture: $e')),
      );
    }
  }

  void _showImageConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Confirm Photo Upload'),
        content: _capturedImage != null
            ? Image.file(
                File(_capturedImage!.path),
                height: 200,
                fit: BoxFit.contain,
              )
            : Text('No photo captured'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _capturedImage = null;
              });
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isUploading
                ? null
                : () {
                    Navigator.pop(context);
                    _uploadImage();
                  },
            child: _isUploading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Upload'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadImage() async {
    if (_capturedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final file = File(_capturedImage!.path);
      final fileName =
          '${widget.place.placeId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(_capturedImage!.path)}';
      final storageRef =
          FirebaseStorage.instance.ref().child('photos').child(fileName);

      await storageRef.putFile(file);
      final downloadUrl = await storageRef.getDownloadURL();

      final docRef = await FirebaseFirestore.instance
          .collection('places')
          .doc(widget.place.placeId)
          .collection('photos')
          .add({
        'url': downloadUrl,
        'placeId': widget.place.placeId,
        'createdAt': FieldValue.serverTimestamp(),
        'type': 'photo',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo uploaded successfully')),
      );

      await _fetchMedia();

      setState(() {
        _capturedImage = null;
        _isUploading = false;
        _isCameraOpen = false;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading photo: $e')),
      );
    }
  }

  Future<void> _startVideoRecording() async {
    if (!_cameraController!.value.isInitialized || _isRecording) {
      return;
    }

    try {
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _recordingSecondsLeft = 5;
      });

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_recordingSecondsLeft > 1) {
            _recordingSecondsLeft--;
          } else {
            _stopVideoRecording();
            timer.cancel();
          }
        });
      });

      Future.delayed(const Duration(seconds: 5), () {
        if (_isRecording) {
          _stopVideoRecording();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting video recording: $e')),
      );
    }
  }

  Future<void> _stopVideoRecording() async {
    if (!_isRecording) {
      return;
    }

    _recordingTimer?.cancel();

    try {
      final video = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _capturedVideo = video;
      });

      _videoController = VideoPlayerController.file(File(video.path));
      await _videoController!.initialize();

      _showVideoConfirmationDialog();
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error stopping video recording: $e')),
      );
    }
  }

  void _showVideoConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Confirm Video Upload'),
        content: _videoController != null
            ? SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    VideoPlayer(_videoController!),
                    Center(
                      child: IconButton(
                        icon: Icon(
                          _videoController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white.withOpacity(0.7),
                          size: 50,
                        ),
                        onPressed: () {
                          if (_videoController!.value.isPlaying) {
                            _videoController!.pause();
                          } else {
                            _videoController!.play();
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Text('No video captured'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _videoController?.dispose();
              setState(() {
                _capturedVideo = null;
              });
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isUploading
                ? null
                : () {
                    Navigator.pop(context);
                    _uploadCapturedVideo();
                  },
            child: _isUploading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Upload'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadCapturedVideo() async {
    if (_capturedVideo == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final file = File(_capturedVideo!.path);
      final fileName =
          '${widget.place.placeId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(_capturedVideo!.path)}';
      final storageRef =
          FirebaseStorage.instance.ref().child('reels').child(fileName);

      await storageRef.putFile(file);
      final downloadUrl = await storageRef.getDownloadURL();

      final docRef = await FirebaseFirestore.instance
          .collection('places')
          .doc(widget.place.placeId)
          .collection('reels')
          .add({
        'url': downloadUrl,
        'placeId': widget.place.placeId,
        'createdAt': FieldValue.serverTimestamp(),
        'duration': _videoController?.value.duration.inSeconds ?? 5,
      });

      final firestoreDocPath = docRef.path;
      await _saveReelToMongoDB(
        widget.place.placeId,
        firestoreDocPath,
        downloadUrl,
        _videoController?.value.duration.inSeconds ?? 5,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video uploaded successfully')),
      );

      await _fetchMedia();

      _videoController?.dispose();
      setState(() {
        _capturedVideo = null;
        _isUploading = false;
        _isCameraOpen = false;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading video: $e')),
      );
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      _videoController = VideoPlayerController.file(File(video.path));
      await _videoController!.initialize();

      final duration = _videoController!.value.duration.inSeconds;
      if (duration <= 10) {
        setState(() {
          _selectedVideo = video;
        });
        _showConfirmationDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Please select a video of 10 seconds or less')),
        );
        _videoController?.dispose();
      }
    }
  }

  Future<void> _showConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Confirm Video Upload'),
        content: _selectedVideo != null
            ? SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    VideoPlayer(_videoController!),
                    Center(
                      child: IconButton(
                        icon: Icon(
                          _videoController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white.withOpacity(0.7),
                          size: 50,
                        ),
                        onPressed: () {
                          if (_videoController!.value.isPlaying) {
                            _videoController!.pause();
                          } else {
                            _videoController!.play();
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Text('No video selected'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _videoController?.dispose();
              setState(() {
                _selectedVideo = null;
              });
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isUploading
                ? null
                : () {
                    Navigator.pop(context);
                    _uploadVideo();
                  },
            child: _isUploading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Upload'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveReelToMongoDB(String placeId, String firestoreDocPath,
      String videoUrl, int duration) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://soyah-go-wildflower-905-holy-morning-7136.fly.dev/api/save-reel'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'placeId': placeId,
          'firestoreDocPath': firestoreDocPath,
          'url': videoUrl,
          'duration': duration,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to save reel link to MongoDB: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error saving to MongoDB: $e');
    }
  }

  Future<void> _uploadVideo() async {
    if (_selectedVideo == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final file = File(_selectedVideo!.path);
      final fileName =
          '${widget.place.placeId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(_selectedVideo!.path)}';
      final storageRef =
          FirebaseStorage.instance.ref().child('reels').child(fileName);

      await storageRef.putFile(file);
      final downloadUrl = await storageRef.getDownloadURL();

      final docRef = await FirebaseFirestore.instance
          .collection('places')
          .doc(widget.place.placeId)
          .collection('reels')
          .add({
        'url': downloadUrl,
        'placeId': widget.place.placeId,
        'createdAt': FieldValue.serverTimestamp(),
        'duration': _videoController!.value.duration.inSeconds,
      });

      final firestoreDocPath = docRef.path;
      await _saveReelToMongoDB(
        widget.place.placeId,
        firestoreDocPath,
        downloadUrl,
        _videoController!.value.duration.inSeconds,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video uploaded successfully')),
      );

      await _fetchMedia();

      _videoController?.dispose();
      setState(() {
        _selectedVideo = null;
        _isUploading = false;
        _isCameraOpen = false;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading video: $e')),
      );
    }
  }

  Future<void> _initializeReelPlayer(String url) async {
    if (!_reelControllers.containsKey(url)) {
      final controller = VideoPlayerController.network(url);
      await controller.initialize();
      controller.setLooping(true);
      setState(() {
        _reelControllers[url] = controller;
      });
    }
  }

  Widget _buildCarouselOverlay() {
    return Stack(
      children: [
        PageView.builder(
          controller: _carouselController,
          itemCount: _mediaItems.length,
          onPageChanged: (index) {
            _reelControllers.forEach((_, controller) => controller.pause());

            setState(() {
              _currentCarouselIndex = index;
            });

            final media = _mediaItems[index];
            if (media['type'] == 'video' && _reelControllers.containsKey(media['url'])) {
              _reelControllers[media['url']]!.play();
            }
          },
          itemBuilder: (context, index) {
            final media = _mediaItems[index];

            if (media['type'] == 'image') {
              return Container(
                color: Colors.black,
                child: Center(
                  child: Image.network(
                    media['url'],
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return CircularProgressIndicator();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Error loading image', style: TextStyle(color: Colors.white));
                    },
                  ),
                ),
              );
            } else {
              final controller = _reelControllers[media['url']];
              return GestureDetector(
                onTap: () {
                  if (controller != null) {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                    setState(() {});
                  }
                },
                child: Container(
                  color: Colors.black,
                  child: Center(
                    child: controller != null
                        ? AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          )
                        : CircularProgressIndicator(),
                  ),
                ),
              );
            }
          },
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () {
              _reelControllers.forEach((_, controller) => controller.pause());
              setState(() {
                _showCarousel = false;
              });
            },
          ),
        ),
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_mediaItems.length, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentCarouselIndex == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraOverlay() {
    return Stack(
      children: [
        Container(
          color: Colors.black,
          child: Center(
            child: _cameraController != null &&
                    _cameraController!.value.isInitialized
                ? CameraPreview(_cameraController!)
                : CircularProgressIndicator(),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: 'photo_button',
                backgroundColor: Colors.white,
                child: Icon(Icons.camera_alt, color: Colors.black),
                onPressed: _isRecording ? null : _takePicture,
              ),
              FloatingActionButton(
                heroTag: 'video_button',
                backgroundColor: _isRecording ? Colors.red : Colors.white,
                child: _isRecording
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_recordingSecondsLeft',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.stop, color: Colors.white),
                        ],
                      )
                    : Icon(Icons.videocam, color: Colors.black),
                onPressed:
                    _isRecording ? _stopVideoRecording : _startVideoRecording,
              ),
              FloatingActionButton(
                heroTag: 'close_button',
                backgroundColor: Colors.white.withOpacity(0.7),
                mini: true,
                child: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  setState(() {
                    _isCameraOpen = false;
                    if (_isRecording) {
                      _stopVideoRecording();
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, String photoUrl) {
    void _openCarousel() {
      if (!_isCameraOpen && _mediaItems.isNotEmpty) {
        setState(() {
          _showCarousel = true;
          if (_mediaItems[_currentCarouselIndex]['type'] == 'video') {
            final url = _mediaItems[_currentCarouselIndex]['url'];
            if (_reelControllers.containsKey(url)) {
              _reelControllers[url]!.play();
            }
          }
        });
      }
    }

    return GestureDetector(
      onTap: _openCarousel,
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart && _mediaItems.isNotEmpty) {
            _openCarousel();
            return false;
          }
          return false;
        },
        background: Container(
          color: Colors.black,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(
            Icons.play_circle_filled,
            color: Colors.white,
            size: 40,
          ),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: widget.place.photoReference != null
                        ? Image.network(
                            photoUrl,
                            width: double.infinity,
                            height: 170,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              'assets/images/plcbg_1.png',
                              width: double.infinity,
                              height: 170,
                              fit: BoxFit.cover,
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                height: 170,
                                child: Center(child: CircularProgressIndicator()),
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/plcbg_1.png',
                            width: double.infinity,
                            height: 170,
                            fit: BoxFit.cover,
                          ),
                ),
              ],
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _quickRecordReel,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: const Icon(
                          Icons.videocam,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _pickVideo,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: const Icon(
                          Icons.video_call,
                          color: Colors.white,
                          size: 24,
                          ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  String _buildPhotoUrl(String? photoReference, String apiKey) {
    if (photoReference == null) {
      return 'assets/images/plcbg_1.png';
    }
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=800'
        '&photoreference=$photoReference'
        '&key=$apiKey';
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoController?.dispose();
    _reelControllers.forEach((_, controller) => controller.dispose());
    _carouselController.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String apiKey = 'AIzaSyAmQOxV80zIRfCZxDNcmVt83tuW1RlVo40';
    final String photoUrl = _buildPhotoUrl(widget.place.photoReference, apiKey);

    String openStatus = widget.place.isOpen != null
        ? (widget.place.isOpen! ? 'Open' : 'Closed')
        : 'Hours unavailable';
    String closingTime = widget.place.closingTime ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: Image.asset(
            'assets/images/back.png',
            scale: 1.3,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCard(context, photoUrl),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4, top: 8, right: 4, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.place.name,
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "$openStatus • ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: Colors.black),
                                ),
                                if (closingTime.isNotEmpty)
                                  Text(
                                    "Closes at $closingTime • ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: Colors.black),
                                  ),
                                Text(
                                  "${widget.place.distance.toStringAsFixed(1)} km away",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.place.rating.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(color: Colors.black),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.star,
                                  color: Color(0xFFFFCD29),
                                  size: 12,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),



                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4, top: 16, right: 4, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reels",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        _isLoadingMedia
                            ? const Center(child: CircularProgressIndicator())
                            : _mediaError != null
                                ? Text(
                                    _mediaError!,
                                    style: const TextStyle(color: Colors.red),
                                  )
                                : _mediaItems.isEmpty
                                    ? const Text("No media available")
                                    : SizedBox(
                                        height: 120,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _mediaItems.length,
                                          itemBuilder: (context, index) {
                                            final media = _mediaItems[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _showCarousel = true;
                                                    _currentCarouselIndex =
                                                        index;
                                                    _reelControllers.forEach(
                                                        (_, controller) =>
                                                            controller.pause());
                                                    if (media['type'] ==
                                                        'video') {
                                                      final url = media['url'];
                                                      if (_reelControllers
                                                          .containsKey(url)) {
                                                        _reelControllers[url]!
                                                            .play();
                                                      }
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 120,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 4,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      if (media['type'] ==
                                                          'video')
                                                        FutureBuilder(
                                                          future:
                                                              _initializeReelPlayer(
                                                                  media['url']),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .done) {
                                                              return ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                child:
                                                                    AspectRatio(
                                                                  aspectRatio:
                                                                      _reelControllers[
                                                                              media['url']]!
                                                                          .value
                                                                          .aspectRatio,
                                                                  child: VideoPlayer(
                                                                      _reelControllers[
                                                                          media[
                                                                              'url']]!),
                                                                ),
                                                              );
                                                            }
                                                            return const Center(
                                                                child:
                                                                    CircularProgressIndicator());
                                                          },
                                                        )
                                                      else
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child: Image.network(
                                                            media['url'],
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null)
                                                                return child;
                                                              return const Center(
                                                                  child:
                                                                      CircularProgressIndicator());
                                                            },
                                                            errorBuilder: (context,
                                                                error,
                                                                stackTrace) {
                                                              return const Text(
                                                                  'Error loading image');
                                                            },
                                                          ),
                                                        ),
                                                      if (media['type'] ==
                                                          'video')
                                                        Center(
                                                          child: Icon(
                                                            Icons
                                                                .play_circle_filled,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.8),
                                                            size: 40,
                                                          ),
                                                        ),
                                                      if (media['type'] ==
                                                          'video')
                                                        Positioned(
                                                          bottom: 8,
                                                          right: 8,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        4,
                                                                    vertical:
                                                                        2),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                            child: Text(
                                                              "${media['duration']}s",
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                        const SizedBox(height: 16),
                        Text(
                          "View your matches",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Transform.translate(
                                offset: Offset(-10 * index.toDouble(), 0),
                                child: const CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(
                                    'https://www.kasandbox.org/programming-images/avatars/marcimus-red.png',
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Frequent Visitors",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        _isLoadingVisitors
                            ? const Center(child: CircularProgressIndicator())
                            : _visitorImages.isEmpty
                                ? const Text("No visitors available")
                                : Row(
                                    children: [
                                      ...List.generate(
                                        _visitorImages.length > 5
                                            ? 5
                                            : _visitorImages.length,
                                        (index) {
                                          return Transform.translate(
                                            offset: Offset(
                                                -10 * index.toDouble(), 0),
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundImage: NetworkImage(
                                                  _visitorImages[index]),
                                              onBackgroundImageError:
                                                  (error, stackTrace) {
                                                print(
                                                    'Error loading visitor image: $error');
                                              },
                                              child: _visitorImages[index].isEmpty
                                                  ? Image.asset(
                                                      'assets/images/plcbg_1.png',
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                        const SizedBox(height: 16),
                        Image.asset(
                          'assets/images/chat_intro_lable.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),



                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: ContinueButtonWidget(
                      label: 'CHECK OUT',
                      width: 150,
                      onTap: () {
                        GoRouter.of(context).push('/main_nav');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isCameraOpen) _buildCameraOverlay(),
          if (_showCarousel && _mediaItems.isNotEmpty) _buildCarouselOverlay(),
        ],
      ),
    );
  }











  

  Future<List<String>> fetchVisitorImages(String placeId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://soyah-go-wildflower-905-holy-morning-7136.fly.dev/api/frequent-visitors?place_id=$placeId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> images = data['images'] ?? [];
        return images.map((image) => image.toString()).toList();
      } else {
        print('Failed to fetch visitor images: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('Error fetching visitor images: $e');
      return [];
    }
  }
}