import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sohyah/home/bloc/home_state.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return BottomNavigationBar(
                currentIndex: state.selectedTabIndex,
                onTap: (index) => context.read<HomeBloc>().add(ChangeTab(index)),
                type: BottomNavigationBarType.fixed,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Colors.black87,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
                items: const [
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage("assets/images/ic_shop.png"), size: 24),
                    label: 'Places',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage("assets/images/ic_map.png"), size: 24),
                    label: 'Map',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage("assets/images/ic_request.png"), size: 24),
                    label: 'Requests',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage("assets/images/ic_chat.png"), size: 24),
                    label: 'Chat',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}