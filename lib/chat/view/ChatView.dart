import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../app/view/common/app_bar.dart';
import '../../app/view/common/continue_button.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool showCamera = false;
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  bool _isCameraInitialized = false;
  String _statusMessage = 'Camera not initialized';

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      // Step 1: Check and request permission
      setState(() {
        _statusMessage = 'Checking camera permission...';
      });
      if (!await _checkAndRequestPermission()) {
        setState(() {
          _statusMessage = 'Camera permission denied. Enable in settings.';
        });
        return;
      }

      // Step 2: Get available cameras with retry mechanism
      setState(() {
        _statusMessage = 'Detecting available cameras...';
      });
      List<CameraDescription> cameras = await _getAvailableCamerasWithRetry();
      if (cameras.isEmpty) {
        setState(() {
          _statusMessage = 'No cameras available on device';
        });
        return;
      }

      // Step 3: Select front camera
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      // Step 4: Initialize controller
      setState(() {
        _statusMessage = 'Creating camera controller...';
      });
      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      // Step 5: Initialize camera
      setState(() {
        _statusMessage = 'Initializing camera...';
      });
      _initializeControllerFuture = _cameraController!.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
            _statusMessage = 'Camera ready';
          });
        }
      }).catchError((e) {
        setState(() {
          _statusMessage = 'Camera init error: $e';
        });
        throw e;
      });

      await _initializeControllerFuture;
    } catch (e) {
      setState(() {
        _statusMessage = 'Camera setup failed: $e';
        if (e is PlatformException) {
          _statusMessage += '\nCode: ${e.code}\nDetails: ${e.details}';
        }
      });
    }
  }

  Future<bool> _checkAndRequestPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        return false;
      }
    }
    return true;
  }

  Future<List<CameraDescription>> _getAvailableCamerasWithRetry() async {
    const maxRetries = 3;
    for (int i = 0; i < maxRetries; i++) {
      try {
        return await availableCameras();
      } catch (e) {
        if (i == maxRetries - 1) rethrow;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    return [];
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    // Swiped right
                    setState(() {
                      showCamera = false;
                    });
                  } else if (details.primaryVelocity! < 0) {
                    // Swiped left
                    setState(() {
                      showCamera = true;
                    });
                  }
                },
                child: buildCard(context),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Le Restaurant',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'OPEN',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' · Closes 3PM · 2km away',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          '4.9',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.star,
                          color: Colors.amber[700],
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'View your matches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: index % 3 == 0
                            ? const AssetImage('assets/images/plctbg_1.png')
                            : null,
                        child: index % 3 != 0
                            ? Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Frequent Visitors',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: index % 2 == 0
                            ? const AssetImage('assets/images/chat_inttro_lable.png')
                            : null,
                        child: index % 2 != 0
                            ? Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Image button below Frequent Visitors
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    // Add your chat joining logic here
                    print('Visitor card clicked - Join chat');
                    // Example: GoRouter.of(context).push('/chat');
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/chat_intro_lable.png',
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ContinueButtonWidget(
                  label: 'CHECK OUT',
                  width: 150,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 170,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: showCamera
              ? (_cameraController == null || _initializeControllerFuture == null)
                  ? Center(child: Text(_statusMessage))
                  : FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: Text(_statusMessage));
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        if (_isCameraInitialized) {
                          return CameraPreview(_cameraController!);
                        }
                        return Center(child: Text(_statusMessage));
                      },
                    )
              : Image.asset(
                  'assets/images/plcbg_1.png',
                  width: double.infinity,
                  height: 170,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}