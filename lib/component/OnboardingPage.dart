import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talk_world/component/consts.dart';

class OnboardingPictureText extends StatelessWidget {
  final String image;
  final String subtitle;
  const OnboardingPictureText(
      {Key? key, required this.image, required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  color: kBlackColor,
                )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
