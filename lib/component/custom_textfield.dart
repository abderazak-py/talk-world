import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talk_world/component/consts.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool hide;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const CustomTextField(
      {Key? key,
      required this.text,
      required this.icon,
      required this.hide,
      required this.controller,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        controller: controller,
        style: GoogleFonts.lato(
            textStyle: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
          color: kBlackColor,
        )),
        obscureText: hide,
        cursorColor: kSuperGreyColor,
        cursorHeight: 25,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 33, top: 20, bottom: 20),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: kGreyColor,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kGreyColor),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kGreyColor),
              borderRadius: BorderRadius.circular(15)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15)),
          labelText: text,
          labelStyle: GoogleFonts.lato(
              fontSize: 20,
              color: kSuperGreyColor,
              fontWeight: FontWeight.w800),
          hintText: text,
          hintStyle: GoogleFonts.lato(
              fontSize: 20,
              color: kSuperGreyColor,
              fontWeight: FontWeight.w800),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Icon(
              icon,
              color: kSuperGreyColor,
            ),
          ),
        ),
      ),
    );
  }
}
