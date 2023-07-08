import 'package:flutter/material.dart';
import 'package:plant/constants.dart';

class CustomTextfield extends StatelessWidget {
  final IconData icon;
  final bool obscureText;
  final String hintText;
  final TextEditingController controller;
  final isPrice;

  const CustomTextfield({
    Key? key,
    required this.icon,
    required this.obscureText,
    required this.hintText,
    required this.controller,
    this.isPrice = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if(!isPrice) {
          if (value!.isEmpty) {
            return "Please enter $hintText";
          }
        }
        else {
          return null;
        }
        return null;
      },
      obscureText: obscureText,
      style: TextStyle(
        color: Constants.blackColor,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(
          icon,
          color: Constants.blackColor.withOpacity(.3),
        ),
        hintText: isPrice ? hintText : '$hintText *',
        hintStyle: TextStyle(
          color: Constants.blackColor.withOpacity(.3),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Constants.blackColor.withOpacity(.3)),
        ),
      ),
      cursorColor: Constants.blackColor.withOpacity(.5),
    );
  }
}
