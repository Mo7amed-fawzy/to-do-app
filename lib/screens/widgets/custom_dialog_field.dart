import 'package:flutter/material.dart';
import 'package:to_do_app/core/func/custom_border_style.dart';

class CustomTextDialogField extends StatelessWidget {
  const CustomTextDialogField({
    super.key,
    required this.customHint,
    required this.textController,
  });

  final String customHint;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: customHint,
        border: customBorderStyle(),
      ),
    );
  }
}
