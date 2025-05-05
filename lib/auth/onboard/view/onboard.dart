import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A StatefulWidget that displays a video background with overlaying content for onboarding.
///
/// The `Onboard` widget uses the `video_player` and `chewie` packages to play a looping
/// video from assets. It also displays a gradient overlay and some text content for
/// onboarding purposes, with localized strings for the title and description.
class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    // Initialize the VideoPlayerController with an asset video
    _videoPlayerController =
        VideoPlayerController.asset('assets/video/on_board.mp4');

    // Once the video is initialized, set up the ChewieController
    _videoPlayerController.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        looping: true, // Loop the video
        autoPlay: true, // Auto play the video on load
        showControls: false, // Hide video controls
      );

      // Update the state to reflect the video initialization
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Dispose of the controllers to free up resources
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen video background
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoPlayerController.value.size.width,
                      height: _videoPlayerController.value.size.height,
                      child: Chewie(controller: _chewieController),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          // Gradient overlay on top of the video
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(1),
                    Colors.black.withOpacity(0.1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          // Centered text content with localized strings
          Positioned(
            left: 16,
            right: 16,
            bottom: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.splashTittle,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.splashText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 32),
                // Tap-able image button
               // '/enter_mobile_number', place_profile  home
                InkWell(
                  onTap: () {
                    GoRouter.of(context).push(
                      // '/main_nav',
                      '/enter_mobile_number',
                    );
                  },
                  child: Image.asset(
                    'assets/images/splash_btn.png',
                    scale: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
