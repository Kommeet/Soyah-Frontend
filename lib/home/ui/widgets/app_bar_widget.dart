// import 'package:flutter/material.dart';

// class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
//   final BuildContext ctx;

//   const AppBarWidget({super.key, required this.ctx});

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//       leading: IconButton(
//         icon: const Icon(Icons.menu, color: Colors.black87),
//         onPressed: () {
//           Scaffold.of(context).openDrawer(); 
//         },
//       ),
//       actions: [
//         IconButton(
//           icon: Image.asset('assets/images/user_ic.png', scale: 1.3),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:sohyah/profile/profile.dart'; // Import ProfileCubit

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext ctx;

  const AppBarWidget({super.key, required this.ctx});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black87),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            // Get profile picture URL from AuthenticationRepository
            final authRepository = context.read<AuthenticationRepository>();
            final profilePictureUrl = authRepository.getProfilePictureUrl();

            return IconButton(
              icon: CircleAvatar(
                radius: 20,
                backgroundImage: profilePictureUrl != null
                    ? NetworkImage(profilePictureUrl)
                    : null,
                child: profilePictureUrl == null
                    ? Image.asset('assets/images/user_ic.png', scale: 1.3)
                    : null,
              ),
              onPressed: () {
                // Navigate to profile or handle click
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}