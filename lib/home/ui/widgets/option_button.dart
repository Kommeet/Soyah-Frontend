import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sohyah/home/bloc/home_state.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';

class OptionButton extends StatelessWidget {
  final int index;
  final String assetPath;
  final String label;

  const OptionButton({
    super.key,
    required this.index,
    required this.assetPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        bool isSelected = state.selectedOptionIndex == index;
        return GestureDetector(
          onTap: () => context.read<HomeBloc>().add(ChangeOption(index)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFEEEB) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Image.asset(assetPath, width: 22, height: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: isSelected ? 11 : 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}