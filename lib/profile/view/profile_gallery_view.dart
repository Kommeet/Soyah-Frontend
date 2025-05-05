import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sohyah/profile/cubit/profile_cubit.dart';

class ProfileGalleryView extends StatelessWidget {
  const ProfileGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return state.uploadStatus == UploadStatus.inProgress
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: SizedBox(
                      height: 2,
                      child: LinearProgressIndicator(
                        color: Colors.greenAccent,
                      ),
                    ),
                  )
                : const SizedBox();
          },
        ),
        BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.uploadStatus == UploadStatus.analysisFailed) {
              final snackBar = SnackBar(
                content: Text(state.errorMessage ?? ''),
                action: SnackBarAction(
                  label: 'Ok',
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (state.selectedImagePath != null &&
                state.uploadStatus == UploadStatus.imageSelected) {
              context.read<ProfileCubit>().uploadPhoto();
            }
          },
          builder: (context, state) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    if (index < state.galleryUrls.length) {
                      return Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(70),
                          image: DecorationImage(
                            image: NetworkImage(state.galleryUrls[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          context.read<ProfileCubit>().selectPhoto(context);
                        },
                        child: const PlaceHolderWidget(),
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class PlaceHolderWidget extends StatelessWidget {
  const PlaceHolderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ProfileCubit>().selectPhoto(context);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
              Text(
                'Add',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
