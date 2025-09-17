import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Screens/profile_page.dart';
import 'consts.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Row(
      children: [
        SizedBox(width: 30),
        CircleAvatar(
          backgroundColor: kSuperGreyColor,
          radius: 20,
          child: CircleAvatar(
            backgroundImage: (user!.photoURL == null)
                ? AssetImage(
                    'assets/images/logo.png',
                  )
                : NetworkImage(user!.photoURL!) as ImageProvider,
            backgroundColor: Colors.white,
            radius: 19,
          ),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            child: Text(
              'My Profile',
              style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            )),
        Spacer(),
        TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text(
              'SignOut',
              style: GoogleFonts.lato(
                  color: Colors.red, fontWeight: FontWeight.w600),
            )),
        SizedBox(width: 30),
      ],
    );
  }
}
