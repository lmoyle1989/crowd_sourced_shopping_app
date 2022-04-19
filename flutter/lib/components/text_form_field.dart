import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String fieldText;
  final bool isObscure;
  final double errorHeight;
  final String? Function(String?) validator;

  const TextFieldWidget({
    Key? key, 
    required this.controller,
    required this.fieldText,
    required this.isObscure,
    required this.errorHeight,
    required this.validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: 
      Container(
        padding: const EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width * .75,
        child: TextFormField(
          controller: controller,
          obscureText: isObscure,
          textAlign: TextAlign.center,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: fieldText,
            isDense: true,
            errorStyle: TextStyle(height: errorHeight)
          ),
          validator: validator
        )
      )
    );
  }
}