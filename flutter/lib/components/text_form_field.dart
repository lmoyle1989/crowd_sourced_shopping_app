import 'package:flutter/material.dart';

class CrowdFormField extends StatelessWidget {
  final TextEditingController controller;
  final String fieldText;
  final double? errorHeight;
  final String? Function(String?) validator;
  final bool? isObscure;
  final TextInputType? keyboardType;
  final double? contWidth;
  final TextAlign? textAlignment;
  final bool? autocorrect;

  const CrowdFormField({
    Key? key, 
    required this.controller,
    required this.fieldText,
    required this.validator,
    this.errorHeight,
    this.isObscure,
    this.keyboardType,
    this.contWidth,
    this.textAlignment,
    this.autocorrect
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(6),
        width: MediaQuery.of(context).size.width * (contWidth ?? 0.75),
        child: TextFormField(
          controller: controller,
          obscureText: isObscure ?? false,
          textAlign: textAlignment ?? TextAlign.center,
          enableSuggestions: false,
          autocorrect: autocorrect ?? false,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: fieldText,
            errorStyle: TextStyle(height: errorHeight ?? 0.75)
          ),
          validator: validator,
          keyboardType: keyboardType ?? TextInputType.text,
        )
      )
    );
  }
}