import 'package:flutter/material.dart';
import 'package:to_do_app/core/func/custom_border_style.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required bool isNotValidate,
    required this.myhintText,
  }) : _isNotValidate = isNotValidate;

  final TextEditingController controller;
  final bool _isNotValidate;
  final String myhintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          errorStyle: const TextStyle(color: Colors.white),
          errorText: _isNotValidate ? "Enter Proper Info" : null,
          hintText: myhintText,
          border: customBorderStyle()),
    );
  }
}
