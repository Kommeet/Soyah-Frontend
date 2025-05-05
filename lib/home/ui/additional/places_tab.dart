import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sohyah/home/bloc/location_bloc.dart';
import 'package:sohyah/home/models/place.dart';
import 'package:sohyah/home/ui/additional/swipeable_card.dart';
import 'package:sohyah/home/ui/widgets/app_bar_widget.dart';
import 'package:sohyah/home/ui/widgets/drawer_widget.dart';

class PlacesTabContent extends StatelessWidget {
  final String? userId;
  const PlacesTabContent({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc()..add(GetLocationAndPlaces()),
      child: Scaffold(
        appBar: AppBarWidget(ctx: context),
        drawer: const DrawerWidget(),
        body: BlocConsumer<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state.error.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, locState) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(context),
                      _buildCurrentLocationCard(context, locState),
                      _buildFilterOptions(context),
                    ],
                  ),
                ),
                _buildPlacesList(context, locState),
                const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 110,
          padding: const EdgeInsets.only(left: 18, top: 0.0, right: 18, bottom: 0.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(text: "-----"),
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(text: AppLocalizations.of(context)!.findYourDateTitle),
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: const Color(0xFFFF715B),
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentLocationCard(BuildContext context, LocationState state) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 50,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: constraints.maxWidth > 400 ? 1 : 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_pin, color: Colors.purple, size: 12),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.youAreAt,
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.nearestPlace?.name ?? "Detecting location...",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          context.read<LocationBloc>().add(GetLocationAndPlaces());
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.checkOut,
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.redAccent),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  width: 1,
                  color: Colors.redAccent.withOpacity(0.3),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: constraints.maxWidth > 400 ? 1 : 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
  Row(
    children: [
      Icon(Icons.star, size: 12, color: Colors.purple),
      const SizedBox(width: 4),
      Text(
        "You have",
        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),
        overflow: TextOverflow.ellipsis,
      ),
    ],
  ),
  const SizedBox(height: 4),
  Text(
    "575 Credits",
    style: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
    overflow: TextOverflow.ellipsis,
  ),
  const SizedBox(height: 10),
  Expanded(
    child: Text(
      "You can use these points\n to check or start a chat.",
      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),
      overflow: TextOverflow.ellipsis,
    ),
  ),
],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildOptionButton(context, 0, "assets/images/allnear_ic.png", "All Nearby"),
          _buildOptionButton(context, 1, "assets/images/resturnat_ic.png", "Restaurants"),
          _buildOptionButton(context, 2, "assets/images/coffee_ic.png", "Cafes"),
          _buildOptionButton(context, 3, "assets/images/hotel_ic.png", "Hotels"),
        ],
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, int index, String assetPath, String label) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        final isSelected = state.selectedFilter == index;
        return InkWell(
          onTap: () {
            context.read<LocationBloc>().add(ChangeFilter(index));
          },
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Image.asset(assetPath, width: 30, height: 30),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlacesList(BuildContext context, LocationState state) {
    if (state.isLoading) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    
    if (state.places.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Text(
              state.error.isNotEmpty 
                ? "Error: ${state.error}" 
                : "No places found nearby",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final place = state.filteredPlaces[index];
          return SwipeableCard(
            key: ValueKey("card_${place.name}"),
            place: place,
            userId: userId!,
          );
        },
        childCount: state.filteredPlaces.length,
      ),
    );
  }
}