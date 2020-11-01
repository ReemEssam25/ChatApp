import 'package:flutter/material.dart';
// ignore: must_be_immutable
class InputField extends StatelessWidget {
  final String hint;
  final bool obsecureText;
  final Function validator;
  TextEditingController textEditingController = new TextEditingController();

  InputField({this.hint, this.textEditingController, this.validator, this.obsecureText});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        obscureText: obsecureText,
        validator: validator,
        controller: textEditingController,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: Colors.white
          ) ,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
        ),
      ),
    );
  }
}