import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'consts.dart';

class UserInfoCard extends StatelessWidget {
  final String info;
  final IconData icon;
  const UserInfoCard({super.key, required this.info, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kGreyColor,
        borderRadius: BorderRadius.circular(15),
      ),
      width: MediaQuery.of(context).size.width - 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
        child: Row(
          children: [
            Icon(icon, color: kSuperGreyColor),
            SizedBox(width: 20),
            Text(
              info,
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: kSuperGreyColor,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
