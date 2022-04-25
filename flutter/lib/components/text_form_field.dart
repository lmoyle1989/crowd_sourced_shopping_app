import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String fieldText;
  final double? errorHeight;
  final String? Function(String?) validator;
  final bool? isObscure;
  final TextInputType? keyboardType;
  final double? contWidth;

  const TextFieldWidget({
    Key? key, 
    required this.controller,
    required this.fieldText,
    required this.validator,
    this.errorHeight,
    this.isObscure,
    this.keyboardType,
    this.contWidth
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: 
      Container(
        padding: const EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width * (contWidth ?? 0.75),
        child: TextFormField(
          controller: controller,
          obscureText: isObscure ?? false,
          textAlign: TextAlign.center,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: fieldText,
            isDense: true,
            errorStyle: TextStyle(height: errorHeight ?? 0.75)
          ),
          validator: validator,
          keyboardType: keyboardType ?? TextInputType.text,
        )
      )
    );
  }
}