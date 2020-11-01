import 'package:flutter/material.dart';
class SignButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  SignButton({this.text, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),),
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xff2B475D),
              fontSize: 20,
            ),
          ),
          color: Colors.white,
        ),
      ),
    );
  }
}
