import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talk_world/component/consts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: kBlueColor,
              blurRadius: 9, // soften the shadow
              spreadRadius: 0, //extend the shadow
            )
          ],
          color: kBlueColor,
          borderRadius: BorderRadius.circular(19),
        ),
        height: 70,
        width: 160,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.lato(
                textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 30,
              color: Colors.white,
            )),
          ),
        ),
      ),
    );
  }
}
