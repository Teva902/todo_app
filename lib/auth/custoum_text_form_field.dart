import 'package:flutter/material.dart';
import 'package:todo_app/app_colors.dart';

typedef MyValidator = String? Function(String?);

class CustoumTextFormField extends StatelessWidget {
  String label;

  MyValidator validator;

  TextEditingController controller;

  TextInputType keyType;

  bool obscureText;

  CustoumTextFormField(
      {required this.label,
      required this.validator,
      required this.controller,
      this.keyType = TextInputType.text,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.redColor, width: 2)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.redColor, width: 2)),
            labelText: label,
            errorMaxLines: 2),
        validator: validator,
        controller: controller,
        keyboardType: keyType,
        obscureText: obscureText,
      ),
    );
  }
}
