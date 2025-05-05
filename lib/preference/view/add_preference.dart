import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:sohyah/preference/add_preference.dart';
import 'package:sohyah/preference/view/widget/gallery_view.dart';
import '../../app/routes/routes.dart';
import '../../app/view/common/app_bar.dart';
import '../../app/view/common/continue_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:authentication_repository/authentication_repository.dart';

class AddPreference extends StatelessWidget {
  const AddPreference({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => PreferenceCubit(
              currentUser:
                  context.read<AuthenticationRepository>().currentUser),
          child: PreferenceScreen(),
        ),
      ),
    );
  }
}

class PreferenceScreen extends StatelessWidget {
  PreferenceScreen({super.key});

  final List<XFile?> imageList = List.filled(4, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(
        // ctx: context,
        // leadingCallBack: () {},
        ctx: context,
        leadingCallBack: null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              AppLocalizations.of(context)!.preferenceHeader,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
              textAlign: TextAlign.left,
            ),
          ),
          
          // Original Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  const TextSpan(
                    children: [
                      TextSpan(
                        // text: AppLocalizations.of(context)!.preferenceHeader,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.preferenceTittle,
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
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const GalleryView(),
                  ),
                  const SizedBox(height: 40),  
                  _buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future pickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageList[index] = image;
    }
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

Widget _buildSubmitButton(BuildContext context) {
  return BlocConsumer<PreferenceCubit, PreferenceState>(
    listener: (context, state) {},
    builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: ContinueButtonWidget(
          width: 130,
          onTap: () async {
            var cubit = context.read<PreferenceCubit>();

            // Upload images first
            await cubit.uploadImages(cubit.state.galleryUrls);

            if (cubit.state.galleryUrls.length > 2) {
              GoRouter.of(context).push('/add_profile');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select at least 3 images'),
                ),
              );
            }
          },
        ),
      );
    },
  );
}