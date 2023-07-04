
import 'package:flutter/material.dart';
import 'package:plant/constants.dart';
import 'package:plant/models/plants.dart';
import 'package:plant/ui/screens/widgets/plant_widget.dart';
class CustomTextfield extends StatelessWidget {
  final IconData icon;
  final bool obscureText;
  final String hintText;
  final TextEditingController controller;

  const CustomTextfield({
    Key? key, required this.icon, required this.obscureText, required this.hintText, required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter some text";
        }
        return null;
      },
      obscureText: obscureText,
      style: TextStyle(
        color: Constants.blackColor,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(icon, color: Constants.blackColor.withOpacity(.3),),
        hintText: hintText,
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