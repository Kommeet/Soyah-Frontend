import 'dart:convert';
import 'dart:io';

import 'package:ai_analyzer_repository/ai_%20analyzer_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:sohyah/profile/profile.dart';
import 'package:sohyah/profile/view/profile_gallery_view.dart';
import '../../app/routes/routes.dart';
import '../../app/view/common/app_bar.dart';
import '../../app/view/common/continue_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:authentication_repository/authentication_repository.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => ProfileCubit(
              currentUser: context.read<AuthenticationRepository>().currentUser,
              authRepository: context.read<AuthenticationRepository>()),
          child: ProfileScreen(),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

// In _ProfileScreenState class - Update saveFaceProfile function to mark first image as profile picture
Future<void> saveFaceProfile(List<String> galleryUrls, List<FaceData> faceDataList) async {
  const String apiUrl = 'https://soyah-go-wildflower-905-holy-morning-7136.fly.dev/api/save-face-profile';

  if (galleryUrls.length < 3) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select at least 3 images')),
    );
    return;
  }

  if (faceDataList.length != galleryUrls.length) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Face data mismatch with images')),
    );
    return;
  }

  // Get phone number to use as ID
  final phoneNumber = context.read<AuthenticationRepository>().getPhoneNumber();
  if (phoneNumber == null || phoneNumber.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Authentication error: Phone number not found')),
    );
    return;
  }

  // Sanitize phone number for use as ID
  final sanitizedPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

  final List<Map<String, dynamic>> imagesData = List.generate(galleryUrls.length, (index) {
    return {
      "faceData": faceDataList[index].toJson(), 
      "publicPath": galleryUrls[index],
      "isProfilePicture": index == 0, 
    };
  });

  if (kDebugMode) {
    print('Final JSON before sending: ${jsonEncode({
      "phoneId": sanitizedPhone,
      "images": imagesData
    })}');
  }

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "phoneId": sanitizedPhone,
        "images": imagesData
      }),
    );

    if (response.statusCode == 200) {
      // Save the profile picture URL to shared preference or some other persistent storage
      // so it can be accessed in other views
      if (galleryUrls.isNotEmpty) {
        await context.read<AuthenticationRepository>().saveProfilePictureUrl(galleryUrls[0]);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile images saved successfully')),
      );
      GoRouter.of(context).push(
  '/account_set',
  extra: {"phoneNumber": sanitizedPhone},
);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: ${response.body}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    bool chkUpdate = false; 
    return Scaffold(
      appBar: GlobalAppBar(
        ctx: context,
        leadingCallBack: null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.uploadFavourite,    //title text
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.black,
                  ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.favouriteDesc,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: const Color(0xFF070201)),
                ),
              ],
            ),
          ),
          const Expanded(child: ProfileGalleryView()),
          const SizedBox(height: 16),
          Center(child: _buildSubmitButton(context)),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: ContinueButtonWidget(
            width: 130,
            onTap: () {
              saveFaceProfile(state.galleryUrls, state.faceDataList);
            },
          ),
        );
      },
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.onTap,
    required this.image,
  });
  final File? image;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.red.withOpacity(0.2),
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.network(
                  image!.path,
                  fit: BoxFit.cover,
                ),
              )

            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.red.withOpacity(0.8),
                  ),
                  Text(
                    AppLocalizations.of(context)!.add,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.redAccent),
                  ),
                ],
              ),
      ),
    );
  }
}