import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinInputField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleteOtp;

  const PinInputField({
    super.key,
    this.length = 6,
    required this.onCompleteOtp,
  });

  @override
  State<PinInputField> createState() => _PinInputFieldState();
}

class _PinInputFieldState extends State<PinInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // OTP Boxes Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(widget.length, (index) {
            return Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4), // Reduced margin
                constraints: const BoxConstraints(
                  maxWidth: 50, // Maximum width
                  minWidth: 40, // Minimum width
                ),
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.transparent),
                ),
                alignment: Alignment.center,
                child: Text(
                  index < _controller.text.length ? _controller.text[index] : '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }),
        ),
        
        // Hidden Text Field
        _buildHiddenTextField(),
      ],
    );
  }

  Widget _buildHiddenTextField() {
    return SizedBox(
      height: 16,
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(widget.length),
        ],
        autofocus: true,
        style: const TextStyle(
          color: Colors.transparent,
          fontSize: 1,
        ),
        cursorColor: Colors.transparent,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          setState(() {
            if (value.length == widget.length) {
              widget.onCompleteOtp(value);
            }
          });
        },
      ),
    );
  }
}