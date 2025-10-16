import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawnco/app/core/themes/theme_helper.dart';

class Textfield extends StatelessWidget {
  const Textfield({
    super.key,
    this.hintText,
    this.title,
    this.keyboardType,
    this.inputFormatters,
    this.validators,
    this.controller,
    this.onChanged,
  });

  final String? hintText;
  final String? title;
  final TextInputType? keyboardType;

  final List<TextInputFormatter>? inputFormatters;

  final FormFieldValidator? validators;

  final TextEditingController? controller;

  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validators,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppThemeHelper.color.surfaceDim.withValues(alpha: 0.7),
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppThemeHelper.color.surfaceDim.withValues(alpha: 0.7),
            width: 0.5,
          ),
        ),
        labelText: title,
        hintText: hintText,
        hintStyle: AppThemeHelper.font.description(
          color: AppThemeHelper.color.surfaceDim.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
