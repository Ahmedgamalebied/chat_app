import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyTextField extends StatelessWidget {
  MyTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.keyboradType,
    required this.obscureText,
    required TextInputType keyboardType,
    this.onChange,
  });
  String labelText;
  String hintText;
  TextInputType keyboradType;
  bool obscureText;
  Function(String)? onChange;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Is required';
        }
      },
      onChanged: onChange,
      keyboardType: keyboradType,
      obscureText: obscureText,
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          )),
    );
  }
}
