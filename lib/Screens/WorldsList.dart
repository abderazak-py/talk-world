import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talk_world/Screens/ChatPage.dart';
import 'package:talk_world/component/room_card.dart';
import '../component/consts.dart';

class WorldsList extends StatelessWidget {
  const WorldsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Row(
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
                            : NetworkImage(user.photoURL!) as ImageProvider,
                        backgroundColor: Colors.white,
                        radius: 19,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, profilePageRoute);
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
                ),
                Expanded(
                  child: ListView(
                    children: const [
                      RoomCard(
                          path: 'assets/images/gaming.jpg',
                          roomRoute: ChatPage(
                            collection: 'gaming',
                          )),
                      RoomCard(
                        path: 'assets/images/anime.jpg',
                        roomRoute: ChatPage(
                          collection: 'anime',
                        ),
                      ),
                      RoomCard(
                        path: 'assets/images/series.jpg',
                        roomRoute: ChatPage(
                          collection: 'series',
                        ),
                      ),
                      RoomCard(
                        path: 'assets/images/movies.jpg',
                        roomRoute: ChatPage(
                          collection: 'movies',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
