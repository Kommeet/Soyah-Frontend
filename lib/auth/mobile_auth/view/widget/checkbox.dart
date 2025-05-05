import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sohyah/auth/mobile_auth/cubit/mobile_auth_cubit.dart';

class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget({super.key});

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MobileAuthCubit, MobileAuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTap: state.isValidMobile
              ? () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                  context.read<MobileAuthCubit>().checkTnC(isChecked);
                }
              : null,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isChecked
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.2), // Background when checked
            ),
            child: isChecked
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
