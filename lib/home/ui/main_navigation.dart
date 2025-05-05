import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sohyah/chat/chat_list/screens/chats_list_screen.dart';
import 'package:sohyah/chat/request_list/screens/requests_screen.dart';
import 'package:sohyah/home/bloc/home_bloc.dart';
import 'package:sohyah/home/bloc/home_event.dart';
import 'package:sohyah/home/bloc/home_state.dart';
import 'package:sohyah/home/ui/additional/places_tab.dart';

import 'package:sohyah/home/ui/widgets/bottom_nav_widget.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key, this.phoneNumber});

  final String? phoneNumber;

  List<Widget> get pages => [
        PlacesTabContent(userId: phoneNumber ?? ''),
        const Placeholder(),
        RequestsScreen(),
        const ChatsListScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeData()),
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(phoneNumber != null ? 'User: $phoneNumber' : 'Main Navigation'),
        // ),
        body: Stack(
          children: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return pages[state.selectedTabIndex];
              },
            ),
            const BottomNavWidget(),
          ],
        ),
      ),
    );
  }
}

